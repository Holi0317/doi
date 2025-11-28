import type dayjs from "dayjs";
import type { Context } from "hono";
import { deleteCookie, setCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { useReqCache } from "../cache";
import { revokeToken } from "../../gh/revoke";
import { useKy } from "../http";
import { COOKIE_NAME, cookieOpt } from "./constants";
import { genSessionID, getSessHash, hashSessionID } from "./id";
import { type SessionInput, type Session, useSessionStorage } from "./schema";

/**
 * Store session data to KV.
 *
 * This isn't exported. You should use {@link setSession} instead.
 */
async function storeSession(
  env: CloudflareBindings,
  content: SessionInput,
  expire: dayjs.Dayjs,
) {
  const sessID = genSessionID();
  const sessHash = await hashSessionID(sessID);

  const { write } = useSessionStorage(env);

  await write(sessHash, content, expire);

  return sessID;
}

/**
 * For testing use only. See {@link storeSession}.
 */
export const __test__storeSession = storeSession;

/**
 * Set session for current request (both cookie and kv).
 */
export async function setSession(
  c: Context<Env>,
  content: SessionInput,
  expire: dayjs.Dayjs,
) {
  const sessID = await storeSession(c.env, content, expire);

  setCookie(c, COOKIE_NAME, sessID, cookieOpt);

  return sessID;
}

/**
 * Delete cookie and session
 */
export async function deleteSession(c: Context<Env>) {
  const { remove, read } = useSessionStorage(c.env);

  // WARNING: Do **NOT** use `getSession` here. It'll cause recursive call.

  // Delete cookie regardless of whether session exists
  deleteCookie(c, COOKIE_NAME, cookieOpt);

  const sessHash = await getSessHash(c);
  if (sessHash == null) {
    return;
  }

  const sess = await read(sessHash);

  await remove(sessHash);

  if (sess != null) {
    try {
      await revokeToken(c, useKy(c), sess.accessToken);
    } catch (err) {
      console.warn("Failed to revoke token on session delete.", err);
    }
  }
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
export async function getSession(c: Context<Env>): Promise<Session | null> {
  return useReqCache(c, "session", async () => {
    const { read } = useSessionStorage(c.env);

    const sessHash = await getSessHash(c);
    // Cookie doesn't exist. User is unauthenticated.
    if (!sessHash) {
      await deleteSession(c);
      return null;
    }

    const sess = await read(sessHash);

    // Session does not exist, or expired
    if (sess == null) {
      await deleteSession(c);
      return null;
    }

    return sess;
  });
}

/**
 * Same as {@link getSession}, except when the return value is null this will
 * raise 401 error.
 */
export async function mustSession(c: Context<Env>): Promise<Session> {
  const sess = await getSession(c);
  if (sess == null) {
    console.warn(
      "Got null session in `mustSession`. Did the route forget `requireSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return sess;
}

/**
 * Try to refresh session in the background.
 */
export async function refreshSession(c: Context<Env>) {
  const sessHash = await getSessHash(c);
  if (sessHash == null) {
    return;
  }

  const id = c.env.TOKEN_REFRESH.idFromName(sessHash);
  const stub = c.env.TOKEN_REFRESH.get(id);

  // Trigger token refresh in the background. Don't wait for it to finish in request-response cycle.
  c.executionCtx.waitUntil(stub.refresh(sessHash));
}
