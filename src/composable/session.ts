// FIXME: Token expiration and refresh

import type { Context } from "hono";
import { deleteCookie, setCookie, getCookie } from "hono/cookie";
import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import * as z from "zod";
import { toUint8Array, uint8ArrayToHex } from "uint8array-extras";
import dayjs from "dayjs";
import type { KyInstance } from "ky";
import type { AccessTokenSchema } from "../gh/oauth_token";
import { getUser } from "../gh/user";
import * as zu from "../zod-utils";

/**
 * Valid redirect destinations after authentication.
 */
export const REDIRECT_DESTINATIONS = ["/", "/basic", "/admin"] as const;

export type REDIRECT_DESTINATIONS = (typeof REDIRECT_DESTINATIONS)[number];

/**
 * Zod schema to validate redirect destinations.
 */
export const redirectDestinationSchema = z.enum(REDIRECT_DESTINATIONS);

/**
 * Generate OAuth state token.
 *
 * This provides 128 bits (16 bytes) of entropy for CSRF protection.
 * See https://datatracker.ietf.org/doc/html/rfc6749#section-10.12
 */
export function genOAuthState() {
  return uint8ArrayToHex(crypto.getRandomValues(new Uint8Array(16)));
}

/**
 * Store OAuth state and redirect destination in KV.
 */
export async function storeOAuthState(
  env: CloudflareBindings,
  redirect: REDIRECT_DESTINATIONS,
) {
  const state = genOAuthState();

  await env.OAUTH_STATE.put(state, redirect, {
    expirationTtl: 600, // 10 minutes
  });

  return state;
}

/**
 * Retrieve and delete OAuth state redirect destination from KV.
 * Returns null if state is invalid or expired.
 */
export async function getAndDeleteOAuthState(
  env: CloudflareBindings,
  state: string,
): Promise<REDIRECT_DESTINATIONS | null> {
  const redirect = await env.OAUTH_STATE.get(state);

  if (!redirect) {
    return null;
  }

  // Delete the state after retrieval (one-time use)
  await env.OAUTH_STATE.delete(state);

  // Validate the redirect is in our whitelist using Zod
  const validationResult = redirectDestinationSchema.safeParse(redirect);
  if (!validationResult.success) {
    return null;
  }

  return validationResult.data;
}

/**
 * Name of the cookie to store session ID.
 *
 * Note that the actual cookie name is prefixed with `__Host-` to enforce
 * secure cookie rules.
 * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#cookie_prefixes
 */
export const COOKIE_NAME = "doi-auth";

const cookieOpt = {
  path: "/",
  httpOnly: true,
  secure: true,
  prefix: "host",
} as const;

/**
 * Generate session ID.
 *
 * This provides 128 bites (16 bytes) of entropy, which is considered secure
 * enough according to OWASP recommendation of 64 bits.
 * See https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html#session-id-entropy
 */
function genSessionID() {
  return uint8ArrayToHex(crypto.getRandomValues(new Uint8Array(16)));
}

/**
 * Hash session ID.
 *
 * We only store hashed session ID in the kv, meanwhile client can hold the
 * session ID in cookie.
 *
 * Following recommendation from https://security.stackexchange.com/a/261773
 */
async function hashSessionID(sessID: string) {
  const hash = await crypto.subtle.digest("SHA-256", Uint8Array.from(sessID));

  return uint8ArrayToHex(toUint8Array(hash));
}

/**
 * Schema for session data stored in KV.
 */
export const SessionSchema = z.object({
  /**
   * Source of the user / IdP provider. Currently this is always "github".
   *
   * In the future we may support other providers and use this field as discriminator.
   */
  source: z.literal("github"),
  uid: z.string(),
  name: z.string(),
  login: z.string(),
  avatarUrl: z.string(),
  accessToken: z.string(),
  /**
   * Time for access token to expire, in milliseconds since epoch
   */
  accessTokenExpire: zu.unixEpochMs(),
  refreshToken: z.string().optional(),
});

/**
 * Store session data to KV.
 *
 * This function is mainly for testing only. You should use {@link setSession} instead.
 */
export async function storeSession(
  env: CloudflareBindings,
  content: z.input<typeof SessionSchema>,
  expire: dayjs.Dayjs,
) {
  const sessID = genSessionID();
  const sessHash = await hashSessionID(sessID);

  await env.SESSION.put(sessHash, JSON.stringify(content), {
    expiration: expire.unix(),
  });

  return sessID;
}

/**
 * Set session for current request (both cookie and kv).
 */
export async function setSession(
  c: Context<Env>,
  content: z.input<typeof SessionSchema>,
  expire: dayjs.Dayjs,
) {
  const sessID = await storeSession(c.env, content, expire);

  setCookie(c, COOKIE_NAME, sessID, cookieOpt);
}

/**
 * Delete cookie and session
 */
export async function deleteSession(c: Context<Env>) {
  const sessID = getCookie(c, COOKIE_NAME);
  if (sessID) {
    const sessHash = await hashSessionID(sessID);
    await c.env.SESSION.delete(sessHash);
  }

  deleteCookie(c, COOKIE_NAME, cookieOpt);
}

/**
 * Get session from request.
 *
 * When this returns some value, the session has been validated.
 *
 * When the session has expired, this will try to refresh the access token if available.
 * If refresh failed, the session will be deleted and null is returned.
 *
 * This function is cached/memorized if session isn't null.
 *
 * @see {requireSession} Middleware for requiring session
 * @see {mustSession} For getting session without handling null case
 */
export async function getSession(
  c: Context<Env>,
): Promise<z.output<typeof SessionSchema> | null> {
  const cached = c.get("session");
  if (cached != null) {
    return cached;
  }

  const sessID = getCookie(c, COOKIE_NAME, cookieOpt.prefix);

  // Cookie doesn't exist. User is unauthenticated.
  if (!sessID) {
    await deleteSession(c);
    return null;
  }

  const sessHash = await hashSessionID(sessID);
  const sessData = await c.env.SESSION.get(sessHash, "json");

  // Session does not exist, or expired
  if (sessData == null) {
    await deleteSession(c);
    return null;
  }

  const parsed = SessionSchema.safeParse(sessData);

  // Should not happen. This has to be a bug.
  // Or we changed session schema and messed up
  if (!parsed.success) {
    console.warn(
      `Failed to parse session data from kv: ${z.prettifyError(parsed.error)}`,
      parsed.error,
    );

    await deleteSession(c);
    return null;
  }

  // Cache/memorize session for this request
  c.set("session", parsed.data);

  return parsed.data;
}

/**
 * Exchange access token info to session content.
 */
export async function makeSessionContent(
  ky: KyInstance,
  tokens: z.output<typeof AccessTokenSchema>,
): Promise<z.output<typeof SessionSchema>> {
  const now = dayjs();

  const userInfo = await getUser(ky, tokens.access_token);
  return {
    source: "github",
    uid: userInfo.id.toString(),
    name: userInfo.name || userInfo.login,
    login: userInfo.login,
    avatarUrl: userInfo.avatar_url,
    accessToken: tokens.access_token,
    // Refresh after 8 hours, even if the GitHub app turned off token expiration.
    accessTokenExpire: now.add(8, "hour").valueOf(),
    refreshToken: tokens.refresh_token,
  };
}

/**
 * Middleware for requiring session before continue.
 *
 * @param onMissing Handle strategy for missing session.
 * "throw": HTTP response with error 401 status
 * "redirect": Redirect to login url
 */
// FIXME: redirect can redirect to some url after login
export function requireSession(onMissing: "redirect" | "throw" = "throw") {
  return createMiddleware<Env>(async (c, next) => {
    const sess = await getSession(c);
    if (sess != null) {
      await next();
      return;
    }

    if (onMissing === "throw") {
      throw new HTTPException(401, { message: "Unauthenticated" });
    }

    return c.redirect("/auth/github/login");
  });
}

/**
 * Same as {@link getSession}, except when the return value is null this will
 * raise 401 error.
 */
export async function mustSession(c: Context<Env>) {
  const sess = await getSession(c);
  if (sess == null) {
    console.warn(
      "Got null session in `mustSession`. Did the route forget `requireSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return sess;
}
