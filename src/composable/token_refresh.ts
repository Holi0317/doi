import type { Context } from "hono";
import { hashSessionID } from "./session/id";

/**
 * Get TokenRefreshDO stub for a given session ID.
 * 
 * Each session has its own TokenRefreshDO instance, identified by the hashed session ID.
 * 
 * @returns Object containing the stub and the computed session hash
 */
export async function getTokenRefreshStub(c: Context<Env>, sessID: string) {
  const sessHash = await hashSessionID(sessID);
  
  const id = c.env.TOKEN_REFRESH.idFromName(sessHash);
  const stub = c.env.TOKEN_REFRESH.get(id);
  
  return { stub, sessHash };
}
