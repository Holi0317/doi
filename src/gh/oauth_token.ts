import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import type { KyInstance } from "ky";
import * as z from "zod";

const AccessTokenSchema = z.union([
  // You guessed it, Github is returning error in 200 OK response. ky's `throwHttpErrors`
  // won't catch it.
  z.object({
    error: z.string(),
    error_description: z.string(),
    error_uri: z.string(),
  }),
  z.object({
    access_token: z.string(),
  }),
]);

/**
 * Exchange authorization access code with `ghu` access token
 *
 * @throws {HTTPException} access token exchange failed. Could be the code got
 * reused.
 */
export async function oauthToken(
  c: Context<Env>,
  ky: KyInstance,
  code: string,
) {
  const accessTokenResp = await ky
    .post("https://github.com/login/oauth/access_token", {
      json: {
        client_id: c.env.GH_CLIENT_ID,
        client_secret: c.env.GH_CLIENT_SECERT,
        code,
      },
    })
    .json();

  const parsed = AccessTokenSchema.parse(accessTokenResp);

  if ("error" in parsed) {
    throw new HTTPException(400, {
      message: `Failed to exchange github token from code.\n${parsed.error}: ${parsed.error_description}`,
    });
  }

  return parsed.access_token;
}
