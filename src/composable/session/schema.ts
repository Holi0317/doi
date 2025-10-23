import * as z from "zod";
import * as zu from "../../zod-utils";

/**
 * Schema for session data stored in KV.
 */
export const SessionSchema = z.object({
  /**
   * Source of the user / IdP provider. Currently this is always "github".
   *
   * In the future we may support other providers and use this field as discriminator.
   */
  source: z.literal("github"),
  uid: z.string(),
  name: z.string(),
  login: z.string(),
  avatarUrl: z.string(),
  accessToken: z.string(),
  /**
   * Time for access token to expire, in milliseconds since epoch
   */
  accessTokenExpire: zu.unixEpochMs(),
  refreshToken: z.string().optional(),
});
