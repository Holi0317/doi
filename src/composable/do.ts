import type { Context } from "hono";
import { mustSession } from "./session/cookie";

/**
 * Get storage durable object stub for given session.
 */
export async function getStorageStub(c: Context<Env>) {
  const sess = await mustSession(c);

  const name = `${sess.source}:${sess.uid}`;

  console.log(`Getting durable object with name ${name}`);

  const id = c.env.STORAGE.idFromName(name);
  return c.env.STORAGE.get(id);
}
