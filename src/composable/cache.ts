import type { Context } from "hono";

/**
 * Use Cloudflare Cache API to cache responses
 *
 * @param name Name of the cache (passed into caches.open)
 * @param key Cache key
 * @param callback Callback to generate the response if cache miss
 */
export async function useCache(
  name: string,
  key: URL,
  callback: () => Promise<Response>,
) {
  const cache = await caches.open(name);

  // Try to get from cache first
  console.debug("Checking cache item", key.toString());
  const response = await cache.match(key);
  if (response) {
    console.info("Cache hit", key.toString());
    return response;
  }

  console.info("Cache miss, generating item", key.toString());

  const value = await callback();

  // Store in cache
  await cache.put(key, value.clone());
  console.info("Cache stored", key.toString());

  return value;
}

/**
 * In-memory cache for the request lifecycle.
 *
 * WARNING: Caller must make sure `key` is unique. The returned type is not checked.
 *
 * @param c
 * @param key Cache key
 * @param callback Callback to generate the value if cache miss
 */
export async function useReqCache<T>(
  c: Context<Env>,
  key: string,
  callback: () => Promise<T>,
): Promise<T> {
  let map = c.get("cache");
  if (map == null) {
    map = new Map<string, unknown>();
    c.set("cache", map);
  }

  if (map.has(key)) {
    return map.get(key) as T;
  }

  const value = await callback();
  map.set(key, value);
  return value;
}
