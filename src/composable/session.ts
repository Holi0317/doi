import type { Context } from "hono";
import { deleteCookie, setCookie, getCookie } from "hono/cookie";
import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import * as z from "zod";
import { toUint8Array, uint8ArrayToHex } from "uint8array-extras";
import dayjs from "dayjs";
import type { KyInstance } from "ky";
import type { AccessTokenSchema } from "../gh/oauth_token";
import { exchangeToken } from "../gh/oauth_token";
import { getUser } from "../gh/user";
import { useKy } from "./http";

export const COOKIE_NAME = "doi-auth";

const cookieOpt = {
  path: "/",
  httpOnly: true,
  secure: true,
  prefix: "host",
} as const;

/**
 * Generate session ID
 */
function genSessionID() {
  return uint8ArrayToHex(crypto.getRandomValues(new Uint8Array(8)));
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

export const SessionSchema = z.object({
  source: z.literal("github"),
  uid: z.string(),
  name: z.string(),
  avatarUrl: z.string(),
  accessToken: z.string(),
  /**
   * Time for access token to expire, in milliseconds since epoch
   */
  accessTokenExpire: z.number(),
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

  const sess = await refreshSession(c, parsed.data);
  if (sess == null) {
    await deleteSession(c);
    return null;
  }

  // Update session expiration and content if changed.
  // No need to set cookie here, we didn't change the session ID
  // Relies on the fact that refreshSession returns the same object if not changed
  if (sess !== parsed.data) {
    await storeSession(c.env, sess, dayjs().add(7, "day"));
  }

  // Cache/memorize session for this request
  c.set("session", sess);

  return sess;
}

/**
 * Refresh session if expired.
 *
 * @param sess Current session
 * @returns Existing session (Object.is equal) if not changed/expired;
 * null if refresh failed;
 * new session object if refreshed.
 */
async function refreshSession(
  c: Context<Env>,
  sess: z.output<typeof SessionSchema>,
): Promise<z.output<typeof SessionSchema> | null> {
  if (sess.accessTokenExpire >= Date.now()) {
    // Not expired yet.
    return sess;
  }

  const ky = useKy(c);

  console.info("Session expired, trying to refresh", sess.uid);

  if (sess.refreshToken == null) {
    // FIXME: Try verify access token here, and extend session if valid
    // Assuming our github app got refresh token enabled for now.
    return null;
  }

  const tokens = await exchangeToken(c, ky, sess.refreshToken, "refresh");
  const newSess = await makeSessionContent(ky, tokens);

  return newSess;
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
