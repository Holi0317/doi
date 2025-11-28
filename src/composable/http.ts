import type { Context } from "hono";
import ky from "ky";

/**
 * Create a ky instance for the given hono context.
 */
export function useKy(c: Context<Env>) {
  return useBasicKy(c.env).extend({
    hooks: {
      beforeRequest: [
        (request) => {
          return new Request(request, {
            // Cancel request when client disconnects
            // ky's merge logic is broken if we specify the signal in `.create` parameter
            // Plus this hook allows us to race/combine signals if caller also specifies one
            signal: AbortSignal.any(
              [request.signal, c.req.raw.signal].filter(
                (signal) => signal !== null,
              ),
            ),
          });
        },
      ],
    },
  });
}

/**
 * Create a ky instance when no hono context is available.
 */
export function useBasicKy(env: CloudflareBindings) {
  const version = env.CF_VERSION_METADATA;

  return ky.create({
    headers: {
      "user-agent": `doi-app/${version.id || "unknown"}/${version.tag || "unknown"}`,
    },
  });
}
