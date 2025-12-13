import type { KyInstance } from "ky";
import type * as z from "zod";
import dayjs from "dayjs";
import type { AccessTokenSchema } from "../../gh/oauth_token";
import { getUser } from "../../gh/user";
import type { UserWriteInput } from "../user/registry";
import type { Session } from "./schema";

/**
 * Exchange access token info to session and user content.
 */
export async function makeSessionContent(
  ky: KyInstance,
  tokens: z.output<typeof AccessTokenSchema>,
) {
  const now = dayjs();

  const userInfo = await getUser(ky, tokens.access_token);

  const session: Session = {
    source: "github",
    uid: userInfo.id.toString(),
    accessToken: tokens.access_token,

    // Refresh after 8 hours, even if the GitHub app turned off token expiration.
    accessTokenExpire: now.add(8, "hour").valueOf(),
    refreshToken: tokens.refresh_token,
  };

  const user: UserWriteInput = {
    source: "github",
    uid: userInfo.id.toString(),
    name: userInfo.name || userInfo.login,
    login: userInfo.login,
    avatarUrl: userInfo.avatar_url,
  };

  return {
    session,
    user,
  };
}
