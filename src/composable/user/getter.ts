import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import { useReqCache } from "../cache";
import { getSession } from "../session/cookie";
import type { User } from "./schema";
import { useUserRegistry } from "./registry";

async function _get(c: Context<Env>) {
  const registry = useUserRegistry(c.env);

  const session = await getSession(c);
  if (session == null) {
    return null;
  }

  return useReqCache(c, "user", async () => {
    const user = await registry.read(session);
    return user;
  });
}

/**
 * Get current user from context.
 *
 * The user object is cached per-request. It's cheap to call it multiple times.
 *
 * `must` is true or omitted in this overload. This will throw 401 error if session is missing or user is not found.
 * Routers should add `requireSession` middleware in the chain to ensure session exists.
 */
export function getUser(c: Context<Env>, must?: true): Promise<User>;

/**
 * Get current user from context.
 *
 * The user object is cached per-request. It's cheap to call it multiple times.
 *
 * `must` is false in this overload. This will return null instead of raising error if user is not found.
 */
export function getUser(c: Context<Env>, must: false): Promise<User | null>;

export async function getUser(c: Context<Env>, must: boolean = true) {
  const user = await _get(c);

  if (must && user == null) {
    console.warn(
      "Got null user in `getUser` with must=true. Did the route forget `requireSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return user;
}
