import type { Context } from "hono";
import { deleteCookie, setCookie, getCookie } from "hono/cookie";
import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import * as z from "zod";
import { toUint8Array, uint8ArrayToHex } from "uint8array-extras";
import type dayjs from "dayjs";

export const COOKIE_NAME = "poche-auth";

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
  avatar_url: z.string(),
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
 * This function is cached/memorized.
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

  c.set("session", parsed.data);

  return parsed.data;
}

/**
 * Middleware for requiring session before continue.
 *
 * @param onMissing Handle strategy for missing session.
 * "throw": HTTP response with error 401 status
 * "redirect": Redirect to login url
 */
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
      "Got null session in `mustSession`. Did the route forget `requreSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return sess;
}
