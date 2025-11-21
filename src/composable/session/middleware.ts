import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import dayjs from "dayjs";
import { getCookie } from "hono/cookie";
import { getSession } from "./cookie";
import { COOKIE_NAME, cookieOpt } from "./constants";
import { getTokenRefreshStub } from "../token_refresh";
import { useKy } from "../http";

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
    if (sess == null) {
      if (onMissing === "throw") {
        throw new HTTPException(401, { message: "Unauthenticated" });
      }
      return c.redirect("/auth/github/login");
    }

    // Check if access token has expired
    const now = dayjs();
    if (now.isAfter(dayjs(sess.accessTokenExpire)) && sess.refreshToken) {
      // Token has expired, trigger refresh through the durable object
      const sessID = getCookie(c, COOKIE_NAME, cookieOpt.prefix);
      
      if (sessID) {
        const stub = await getTokenRefreshStub(c, sessID);
        const ky = useKy(c);
        
        // Import hashSessionID to get the session hash
        const { hashSessionID } = await import("./id");
        const sessHash = await hashSessionID(sessID);
        
        try {
          // Attempt to refresh the token through the durable object
          await stub.refreshIfNeeded(sessHash, ky);
        } catch (err) {
          console.error("Token refresh failed:", err);
          // If refresh fails, let the session continue with the expired token
          // The actual API calls will fail and trigger re-authentication
        }
      }
    }

    await next();
  });
}

