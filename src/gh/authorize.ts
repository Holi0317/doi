import { Context } from "hono";

/**
 * Get authorization url (login URL) for GitHub app.
 *
 * @see https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
 */
export function getAuthorizeUrl(c: Context<Env>) {
  const redirectUri = new URL(c.req.url);
  redirectUri.hash = "";
  redirectUri.pathname = "/auth/github/callback";
  redirectUri.search = "";
  redirectUri.password = "";

  // See https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
  const param = new URLSearchParams([
    ["client_id", c.env.GH_CLIENT_ID],
    ["redirect_uri", redirectUri.toString()],
  ]);

  return `https://github.com/login/oauth/authorize?${param.toString()}`;
}
