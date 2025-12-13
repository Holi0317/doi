import type { Context } from "hono";
import { getSession } from "./session/getter";
import type { UserIdentifier } from "./user/ident";
import { uidToString } from "./user/ident";

/**
 * Get storage durable object stub.
 *
 * If `uid` is not provided (default), get the stub for current session user.
 *
 * If `uid` is provided, get the stub for the provided user identifier.
 * Should be used in admin context only.
 *
 * @param c Hono context
 * @param uid Optional user identifier
 */
export async function getStorageStub(c: Context<Env>, uid?: UserIdentifier) {
  if (uid == null) {
    uid = await getSession(c);
  }

  const name = uidToString(uid);

  console.log(`Getting durable object with name ${name}`);

  const id = c.env.STORAGE.idFromName(name);
  return c.env.STORAGE.get(id);
}

/**
 * Get durable object stub for token refresh worker.
 */
export function getRefreshStub(env: CloudflareBindings, sessHash: string) {
  const id = env.TOKEN_REFRESH.idFromName(sessHash);
  return env.TOKEN_REFRESH.get(id);
}
