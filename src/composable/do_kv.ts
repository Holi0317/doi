import type * as z from "zod";

/**
 * Use a single-key KV storage in durable object.
 *
 * @param schema Schema for the stored data. Should be structured clonable object.
 * See https://developers.cloudflare.com/durable-objects/api/sqlite-storage-api/#synchronous-kv-api
 * Schema should not be nullish (null / undefined). We return `null` in `get` when no value is stored.
 */
export function useSingleKV<T extends z.ZodObject>(
  ctx: DurableObjectState,
  key: string,
  schema: T,
) {
  const kv = ctx.storage.kv;

  const get = () => {
    const value = kv.get(key);
    if (value == null) {
      return null;
    }

    const parsed = schema.safeParse(value);
    if (parsed.success) {
      return parsed.data;
    }

    console.warn(
      `Stored value for key ${key} failed schema validation. Pretending value doesn't exist`,
      {
        error: parsed.error,
        value,
      },
    );

    return null;
  };

  const put = (value: z.output<T>) => {
    kv.put(key, value);
  };

  const delete_ = () => {
    return kv.delete(key);
  };

  return {
    get,
    put,
    delete_,
  };
}
