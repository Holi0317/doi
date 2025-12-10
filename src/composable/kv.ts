import * as z from "zod";
import type dayjs from "dayjs";

/**
 * Wrapper for Cloudflare KV storage.
 *
 * This expects the value to be JSON serializable, validated by zod.
 *
 * @param ns KV namespace object. Probably from env binding like `env.MY_KV`.
 * @param prefix Prefix to use for keys in this storage. Like "user" or "session".
 *        Make sure the prefix is unique to avoid key collisions.
 *        We add a `:` separator after the prefix automatically here.
 * @param schema Zod schema to validate the data. If validation fails, read will return null and write a warning.
 */
export function useKv<T extends z.ZodType>(
  ns: KVNamespace<string>,
  prefix: string,
  schema: T,
) {
  if (prefix.endsWith(":")) {
    throw new Error(
      "Prefix should not end with ':'. useKv will add it automatically.",
    );
  }

  /**
   * Add prefix to the key.
   */
  const p = (k: string) => `${prefix}:${k}`;
  /**
   * De-prefix (remove prefix) for the key.
   */
  // eslint-disable-next-line @typescript-eslint/no-unused-vars -- Only used when we need to list keys. Not yet implemented yet.
  const d = (k: string) =>
    k.startsWith(prefix + ":") ? k.slice(prefix.length + 1) : k;

  /**
   * Store data in KV storage.
   */
  const write = async (
    key: string,
    content: z.input<T>,
    expire: dayjs.Dayjs,
  ) => {
    await ns.put(p(key), JSON.stringify(content), {
      expiration: expire.unix(),
    });
  };

  /**
   * Read data from KV storage.
   *
   * @returns The validated data, or null if not found or validation failed
   */
  const read = async (key: string) => {
    const data = await ns.get(p(key), "json");
    if (data == null) {
      return null;
    }

    const parsed = schema.safeParse(data);

    if (!parsed.success) {
      console.warn(
        `Failed to parse data type ${prefix} from kv: ${z.prettifyError(parsed.error)}`,
        parsed.error,
      );

      return null;
    }

    return parsed.data;
  };

  /**
   * Delete data from KV storage.
   */
  const remove = async (key: string) => {
    await ns.delete(p(key));
  };

  return {
    write,
    read,
    remove,
  };
}
