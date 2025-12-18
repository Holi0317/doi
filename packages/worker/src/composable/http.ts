import type { Context } from "hono";
import ky from "ky";

/**
 * Create a ky instance for the given hono context.
 */
export function useKy(c: Context<Env>) {
  return useBasicKy(c.env).extend({
    signal: c.req.raw.signal,
  });
}

/**
 * Create a ky instance when no hono context is available.
 */
export function useBasicKy(env: CloudflareBindings) {
  const version = env.CF_VERSION_METADATA;

  return ky.create({
    headers: {
      "user-agent": `haudoi-worker/${version.id || "unknown"}/${version.tag || "unknown"}`,
    },
  });
}
