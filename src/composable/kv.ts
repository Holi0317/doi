import * as z from "zod";
import type dayjs from "dayjs";

/**
 * Wrapper for Cloudflare KV storage.
 *
 * This expects the value to be JSON serializable, validated by zod.
 *
 * @param ns KV namespace object. Probably from env binding like `env.MY_KV`.
 * @param schema Zod schema to validate the data. If validation fails, read will return null and write a warning.
 * @param name Name of the data type, used in warning messages.
 */
export function useKv<T extends z.ZodType>(
  ns: KVNamespace<string>,
  schema: T,
  name: string,
) {
  /**
   * Store data in KV storage.
   */
  const write = async (
    key: string,
    content: z.input<T>,
    expire: dayjs.Dayjs,
  ) => {
    await ns.put(key, JSON.stringify(content), {
      expiration: expire.unix(),
    });
  };

  /**
   * Read data from KV storage.
   *
   * @returns The validated data, or null if not found or validation failed
   */
  const read = async (key: string) => {
    const data = await ns.get(key, "json");
    if (data == null) {
      return null;
    }

    const parsed = schema.safeParse(data);

    if (!parsed.success) {
      console.warn(
        `Failed to parse data type ${name} from kv: ${z.prettifyError(parsed.error)}`,
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
    await ns.delete(key);
  };

  return {
    write,
    read,
    remove,
  };
}
