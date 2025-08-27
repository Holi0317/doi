import { createMiddleware } from "hono/factory";
import { hc } from "hono/client";
import type { AppType } from "../router";

/**
 * Inject `client` property to the request.
 *
 * That's a mostly functional hc client. Main usecase is to send "request" to
 * api side from html rendering side.
 */
export function clientInject(app: AppType) {
  return createMiddleware<Env>(async (c, next) => {
    c.set(
      "client",
      hc<AppType>("https://example.com", {
        async fetch(
          input: string | URL | globalThis.Request,
          init?: RequestInit,
        ): Promise<Response> {
          const req1 = new Request(input, init);

          const req = new Request(req1, {
            // Make sure we inherit headers from the actual request. This way we
            // can have cookies sent to the api properly
            headers: c.req.raw.headers,
          });

          return app.fetch(req, c.env, c.executionCtx);
        },
      }),
    );

    await next();
  });
}
