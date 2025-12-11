import type { Context } from "hono";
import { getSession } from "./session/getter";

/**
 * Get storage durable object stub for given session.
 */
export async function getStorageStub(c: Context<Env>) {
  const sess = await getSession(c);

  const name = `${sess.source}:${sess.uid}`;

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
