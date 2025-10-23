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
