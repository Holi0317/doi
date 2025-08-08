/**
 * Env interface for hono Context
 */
interface Env {
  Bindings: CloudflareBindings;
  Variables: {
    session: z.output<typeof import("./src/composable/session").SessionSchema>;
  };
}
