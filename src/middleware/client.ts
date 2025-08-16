import { createMiddleware } from "hono/factory";
import { hc } from "hono/client";
import type { AppType } from "../router";

export function clientInject(app: AppType) {
  return createMiddleware<Env>(async (c, next) => {
    c.set(
      "client",
      hc<AppType>("https://example.com", {
        // FIXME: Inject execution context into there.
        fetch: app.request,
      }),
    );

    await next();
  });
}
