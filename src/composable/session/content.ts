import type { KyInstance } from "ky";
import type * as z from "zod";
import dayjs from "dayjs";
import type { AccessTokenSchema } from "../../gh/oauth_token";
import { getUser } from "../../gh/user";
import type { SessionSchema } from "./schema";
import { DEFAULT_TOKEN_EXPIRY_HOURS } from "./constants";

/**
 * Exchange access token info to session content.
 */
export async function makeSessionContent(
  ky: KyInstance,
  tokens: z.output<typeof AccessTokenSchema>,
): Promise<z.output<typeof SessionSchema>> {
  const now = dayjs();

  const userInfo = await getUser(ky, tokens.access_token);
  
  // Calculate token expiration based on GitHub's response or default
  const expiresIn = tokens.expires_in ?? DEFAULT_TOKEN_EXPIRY_HOURS * 3600;
  const tokenExpireTime = now.add(expiresIn, "second").valueOf();
  
  return {
    source: "github",
    uid: userInfo.id.toString(),
    name: userInfo.name || userInfo.login,
    login: userInfo.login,
    avatarUrl: userInfo.avatar_url,
    accessToken: tokens.access_token,
    accessTokenExpire: tokenExpireTime,
    refreshToken: tokens.refresh_token,
  };
}
