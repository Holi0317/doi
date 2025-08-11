import type { KyInstance } from "ky";
import * as z from "zod";

const UserInfoSchema = z.object({
  id: z.number(),
  login: z.string(),
  name: z.string().nullable(),
  avatar_url: z.string(),
});

/**
 * Get authorized user's information from github.
 */
export async function getUser(ky: KyInstance, access_token: string) {
  const userInfoResp = await ky
    .get("https://api.github.com/user", {
      headers: {
        authorization: `Bearer ${access_token}`,
        accept: "application/json",
      },
    })
    .json();

  return UserInfoSchema.parse(userInfoResp);
}
