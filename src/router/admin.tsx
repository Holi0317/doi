import { Hono } from "hono";
import { requireAdmin, requireSession } from "../composable/session/middleware";
import { Layout } from "../component/layout";

const app = new Hono<Env>({ strict: false })
  .use(requireSession({ action: "throw" }))
  .use(requireAdmin())
  .get("/", async (c) => {
    return c.render(<Layout title="Admin console"></Layout>);
  });

export default app;
