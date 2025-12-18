import type { Context } from "hono";
import type { KyInstance } from "ky";

/**
 * Revoke GitHub user access token (ghu_ token).
 *
 * The associated refresh token (ghr_ token) will also be revoked implicitly when calling this API.
 *
 * Uses https://docs.github.com/en/rest/apps/oauth-applications?apiVersion=2022-11-28#delete-an-app-authorization
 */
export async function revokeToken(
  c: Context<Env>,
  ky: KyInstance,
  token: string,
) {
  const authorization = `Basic ${btoa(
    `${c.env.GH_CLIENT_ID}:${c.env.GH_CLIENT_SECRET}`,
  )}`;

  await ky.delete(
    `https://api.github.com/applications/${c.env.GH_CLIENT_ID}/grant`,
    {
      headers: {
        authorization,
      },
      json: {
        access_token: token,
      },
    },
  );
}
