// FIXME: Token expiration and refresh

import * as z from "zod";
import type dayjs from "dayjs";
import type { Context } from "hono";
import { deleteCookie, getCookie, setCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { useReqCache } from "../cache";
import { COOKIE_NAME, cookieOpt } from "./constants";
import { genSessionID, hashSessionID } from "./id";
import { SessionSchema } from "./schema";

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
  return useReqCache(c, "session", async () => {
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

    return parsed.data;
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
