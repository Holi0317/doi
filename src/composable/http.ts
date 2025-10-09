import type { Context } from "hono";
import ky from "ky";

export function useKy(c: Context<Env>) {
  const version = c.env.CF_VERSION_METADATA;

  return ky.create({
    headers: {
      "user-agent": `doi-app/${version.id || "unknown"}/${version.tag || "unknown"}`,
    },
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
