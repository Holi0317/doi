import dayjs from "dayjs";
import { useKv } from "../kv";
import type { Session } from "../session/schema";
import type { User } from "./schema";
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
    const existing = await storage.read(`${user.source}:${user.uid}`);

    const now = dayjs().valueOf();

    await storage.write({
      key: `${user.source}:${user.uid}`,
      content: {
        ...user,
        createdAt: existing?.createdAt ?? now,
        lastLoginAt: now,
      },
      metadata: { string: `${user.source} @${user.login}` },
    });
  };

  const read = async (sess: Session) => {
    return await storage.read(`${sess.source}:${sess.uid}`);
  };

  const list = async () => {
    return await storage.listAll();
  };

  return {
    list,
    read,
    write,
  };
}
