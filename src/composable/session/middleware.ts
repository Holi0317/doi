import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import { getSession } from "./cookie";

/**
 * Middleware for requiring session before continue.
 *
 * @param onMissing Handle strategy for missing session.
 * "throw": HTTP response with error 401 status
 * "redirect": Redirect to login url
 */
// FIXME: redirect can redirect to some url after login
export function requireSession(onMissing: "redirect" | "throw" = "throw") {
  return createMiddleware<Env>(async (c, next) => {
    const sess = await getSession(c);
    if (sess != null) {
      await next();
      return;
    }

    if (onMissing === "throw") {
      throw new HTTPException(401, { message: "Unauthenticated" });
    }

    return c.redirect("/auth/github/login");
  });
}
