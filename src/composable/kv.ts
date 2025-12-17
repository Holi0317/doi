import * as z from "zod";
import type dayjs from "dayjs";

export interface KVWriteOptions<T extends z.ZodType, M extends z.ZodType> {
  key: string;
  content: z.input<T>;
  // FIXME: Metadata is only optional if M allows undefined. Not sure how to express that in TS yet.
  metadata?: z.input<M>;
  expire?: dayjs.Dayjs;
}

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
 * @param metadataSchema Zod schema to validate the metadata. Use `z.undefined()` if no metadata will be written.
 *        Currently metadata is only used for listing keys.
 */
export function useKv<T extends z.ZodType, M extends z.ZodType>(
  ns: KVNamespace<string>,
  prefix: string,
  schema: T,
  metadataSchema: M,
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

  const d = (k: string) =>
    k.startsWith(prefix + ":") ? k.slice(prefix.length + 1) : k;

  /**
   * Store data in KV storage.
   */
  const write = async (options: KVWriteOptions<T, M>) => {
    await ns.put(p(options.key), JSON.stringify(options.content), {
      metadata: options.metadata,
      expiration: options.expire?.unix(),
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

  /**
   * List all keys in this storage.
   *
   * WARNING: This could hit subrequest limits if there are too many keys.
   *
   * @param prefix_ Optional prefix to filter keys. This is added after the main prefix.
   *        Default to empty string.
   */
  const listAll = async (prefix_: string = "") => {
    const result: Array<KVNamespaceListKey<unknown, string>> = [];

    let p = `${prefix}:`;
    if (prefix_) {
      p += prefix_;
    }

    const options: KVNamespaceListOptions = {
      prefix: p,
    };

    while (true) {
      const page = await ns.list(options);

      result.push(...page.keys);

      if (page.list_complete) {
        break;
      }

      options.cursor = page.cursor;
    }

    return result.map(({ name, metadata, ...rest }) => ({
      name: d(name),
      metadata: metadataSchema.parse(metadata),
      ...rest,
    }));
  };

  return {
    write,
    read,
    remove,
    listAll,
  };
}
