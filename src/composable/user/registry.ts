import dayjs from "dayjs";
import { useKv } from "../kv";
import type { User } from "./schema";
import { uidToString, type UserIdentifier } from "./ident";
import { UserMetadataSchema, UserSchema } from "./schema";

/**
 * Input type for writing user data. See `useUserRegistry` `write` method.
 */
export type UserWriteInput = Omit<User, "createdAt" | "lastLoginAt">;

function useUserStorage(env: CloudflareBindings) {
  return useKv(env.KV, "user", UserSchema, UserMetadataSchema);
}

/**
 * User registry for reading and writing user data.
 */
export function useUserRegistry(env: CloudflareBindings) {
  const storage = useUserStorage(env);

  /**
   * Write user data to KV storage.
   *
   * If user doesn't exist, this will create a new user.
   * Note that because of KV consistency model, new user case might not be reliable
   * and createdAt timestamp is just a best-effort reference.
   *
   * This also updates `lastLoginAt` to current time.
   */
  const write = async (user: UserWriteInput) => {
    const key = uidToString(user);

    const existing = await storage.read(key);

    const now = dayjs().valueOf();

    await storage.write({
      key,
      content: {
        ...user,
        createdAt: existing?.createdAt ?? now,
        lastLoginAt: now,
      },
      metadata: { string: `${user.source} @${user.login}` },
    });
  };

  /**
   * Read user data from KV storage.
   *
   * @param uid User identifier. You can pass in session object or user object here.
   * @returns
   */
  const read = async (uid: UserIdentifier) => {
    return await storage.read(uidToString(uid));
  };

  const list = async () => {
    return await storage.listAll();
  };

  /**
   * Delete user data from KV storage.
   */
  const remove = async (uid: UserIdentifier) => {
    return await storage.remove(uidToString(uid));
  };

  return {
    list,
    read,
    write,
    remove,
  };
}
