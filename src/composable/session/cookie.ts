import type dayjs from "dayjs";
import type { Context } from "hono";
import { getCookie, setCookie } from "hono/cookie";
import { HTTPException } from "hono/http-exception";
import { useReqCache } from "../cache";
import { useSessionStorage } from "../kv";
import { COOKIE_NAME, cookieOpt } from "./constants";
import { genSessionID, hashSessionID } from "./id";
import type { SessionInput, Session } from "./schema";

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
}

/**
 * Delete cookie and session
 */
export async function deleteSession(c: Context<Env>) {
  const { remove } = useSessionStorage(c.env);

  const sessID = getCookie(c, COOKIE_NAME);
  if (sessID) {
    const sessHash = await hashSessionID(sessID);

    // TODO: Revoke token on github
    await remove(sessHash);
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
    const sessID = getCookie(c, COOKIE_NAME, cookieOpt.prefix);

    // Cookie doesn't exist. User is unauthenticated.
    if (!sessID) {
      await deleteSession(c);
      return null;
    }

    const { read } = useSessionStorage(c.env);

    const sessHash = await hashSessionID(sessID);
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
