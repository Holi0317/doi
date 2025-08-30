/* eslint-disable */

/**
 * Env interface for hono Context
 */
interface Env {
  Bindings: CloudflareBindings;
  Variables: {
    // Cached session. Do not use this directly. Instead call `getSession`
    // function.
    // This is here for typing purpose only.
    session: z.output<typeof import("./src/composable/session").SessionSchema>;

    // From `middleware/client`. A semi functional hc client for requesting api
    // from html views
    client: ReturnType<
      typeof import("hono/client").hc<import("./src/router/api").APIAppType>
    >;
  };
}
