/* eslint-disable */

/**
 * Env interface for hono Context
 */
interface Env {
  Bindings: CloudflareBindings;
  Variables: {
    session: z.output<typeof import("./src/composable/session").SessionSchema>;
    client: ReturnType<
      typeof import("hono/client").hc<import("./src/router").AppType>
    >;
  };
}
