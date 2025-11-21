/**
 * Name of the cookie to store session ID.
 *
 * Note that the actual cookie name is prefixed with `__Host-` to enforce
 * secure cookie rules.
 * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#cookie_prefixes
 */
export const COOKIE_NAME = "doi-auth";

export const cookieOpt = {
  path: "/",
  httpOnly: true,
  secure: true,
  prefix: "host",
} as const;

/**
 * Default token expiration time in hours.
 * Used when GitHub token doesn't specify an expiration time.
 */
export const DEFAULT_TOKEN_EXPIRY_HOURS = 8;
