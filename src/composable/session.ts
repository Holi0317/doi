import type { Context } from "hono";
import { getSignedCookie, setSignedCookie, deleteCookie } from "hono/cookie";
import { createMiddleware } from "hono/factory";
import { HTTPException } from "hono/http-exception";
import * as z from "zod";
import * as zu from "../zod-utils";

const COOKIE_NAME = "poche-auth";

const cookieOpt = {
  path: "/",
  httpOnly: true,
  secure: true,
  prefix: "host",
} as const;

export const SessionSchema = z.object({
  expire: zu.unixEpochMs(),

  source: z.literal("github"),
  uid: z.string(),
  name: z.string(),
  avatar_url: z.string(),
});

export async function setSession(
  c: Context<Env>,
  content: z.input<typeof SessionSchema>,
) {
  await setSignedCookie(
    c,
    COOKIE_NAME,
    JSON.stringify(content),
    c.env.AUTH_SECRET,
    {
      ...cookieOpt,
      expires: new Date(content.expire),
    },
  );
}

export async function deleteSession(c: Context<Env>) {
  deleteCookie(c, COOKIE_NAME, cookieOpt);
}

/**
 * Get session from request.
 *
 * When this returns some value, the session has been validated.
 *
 * This function is cached/memorized.
 *
 * @see {requireSession} Middleware for requiring session
 * @see {mustSession} For getting session without handling null case
 */
export async function getSession(
  c: Context<Env>,
): Promise<z.output<typeof SessionSchema> | null> {
  const cached = c.get("session");
  if (cached != null) {
    return cached;
  }

  const cookie = await getSignedCookie(
    c,
    c.env.AUTH_SECRET,
    COOKIE_NAME,
    cookieOpt.prefix,
  );

  if (!cookie) {
    await deleteSession(c);
    return null;
  }

  const sess = SessionSchema.parse(JSON.parse(cookie));
  const now = Date.now();

  if (now > sess.expire) {
    console.log("Session expired. Deleting the session cookie.");
    await deleteSession(c);
    return null;
  }

  c.set("session", sess);

  return sess;
}

/**
 * Middleware for requiring session before continue.
 *
 * @param onMissing Handle strategy for missing session.
 * "throw": HTTP response with error 401 status
 * "redirect": Redirect to login url
 */
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

/**
 * Same as {@link getSession}, except when the return value is null this will
 * raise 401 error.
 */
export async function mustSession(c: Context<Env>) {
  const sess = await getSession(c);
  if (sess == null) {
    console.warn(
      "Got null session in `mustSession`. Did the route forget `requreSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return sess;
}
