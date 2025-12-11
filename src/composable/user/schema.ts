import * as z from "zod";
import * as zu from "../../zod-utils";

export const UserSchema = z.object({
  source: z.literal("github"),
  uid: z.string(),

  name: z.string(),
  login: z.string(),
  avatarUrl: z.string(),

  createdAt: zu.unixEpochMs(),
  lastLoginAt: zu.unixEpochMs(),
});

export const UserMetadataSchema = z.object({
  string: z.string(),
});

export type User = z.output<typeof UserSchema>;
