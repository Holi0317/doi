import type { Context } from "hono";
import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import { mustUser } from "./getter";

/**
 * Check if current session is an admin session.
 *
 * Uses {@link mustUser}. Make sure {@link requireSession} exist in the
 * middleware chain.
 */
export async function isAdmin(c: Context<Env>) {
  const { login } = await mustUser(c);

  // GitHub login is case insensitive
  const { compare } = new Intl.Collator(undefined, { sensitivity: "accent" });

  const admins = c.env.ADMIN_GH_LOGIN.split(";");

  for (const str of admins) {
    if (compare(str, login) === 0) {
      return true;
    }
  }

  return false;
}

/**
 * Middleware for requiring session to be admin before continue.
 *
 * {@link requireSession} must be placed before this middleware. Otherwise
 * unauthenticated session will get 500 error instead of 401 or redirect.
 */
export function requireAdmin() {
  return createMiddleware<Env>(async (c, next) => {
    const pass = await isAdmin(c);

    if (!pass) {
      throw new HTTPException(403, { message: "Forbidden" });
    }

    await next();
  });
}
