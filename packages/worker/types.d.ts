/* eslint-disable */

/**
 * Env interface for hono Context
 */
interface Env {
  Bindings: CloudflareBindings;
  Variables: {
    /**
     * In-memory cache for the request lifecycle.
     *
     * See `useReqCache` for usage.
     */
    cache: Map<string, unknown>;

    // From `middleware/client`. A semi functional hc client for requesting api
    // from html views
    client: ReturnType<
      typeof import("hono/client").hc<import("./src/router/api").APIAppType>
    >;
  };
}
