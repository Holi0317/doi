import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import type { RedirectDestination } from "../oauth_state";
import { getSession } from "./cookie";

export type RequireSessionOption =
  | {
      /**
       * If user is not authenticated, throw HTTP 401 error.
       */
      action: "throw";
    }
  | {
      /**
       * If user is not authenticated, redirect to `destination` property
       */
      action: "redirect";
      /**
       * Redirect destination URL after authentication.
       */
      destination: RedirectDestination;
    };

/**
 * Middleware for requiring session before continue.
 *
 * @param option Handle strategy for missing session.
 * "throw": HTTP response with error 401 status
 * "redirect": Redirect to login url. After login, user will be redirected back to the original url.
 */
export function requireSession(option: RequireSessionOption) {
  return createMiddleware<Env>(async (c, next) => {
    const sess = await getSession(c);
    if (sess != null) {
      await next();
      return;
    }

    if (option.action === "throw") {
      throw new HTTPException(401, { message: "Unauthenticated" });
    }

    return c.redirect(`/auth/github/login?redirect=${option.destination}`);
  });
}
