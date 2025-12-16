import type { Context } from "hono";
import { getSession } from "./session/getter";
import type { UserIdentifier } from "./user/ident";
import { uidToString } from "./user/ident";

/**
 * Get storage durable object stub for current session user.
 */
export async function getStorageStub(c: Context<Env>) {
  const uid = await getSession(c);
  return getStorageStubAdmin(c.env, uid);
}

/**
 * Get storage durable object stub for given user identifier. Should be used in admin context only.
 */
export function getStorageStubAdmin(
  env: CloudflareBindings,
  uid: UserIdentifier,
) {
  const name = uidToString(uid);

  console.log(`Getting durable object with name ${name}`);

  const id = env.STORAGE.idFromName(name);
  return env.STORAGE.get(id);
}

/**
 * Get durable object stub for token refresh worker.
 */
export function getRefreshStub(env: CloudflareBindings, sessHash: string) {
  const id = env.TOKEN_REFRESH.idFromName(sessHash);
  return env.TOKEN_REFRESH.get(id);
}
