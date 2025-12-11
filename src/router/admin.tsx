import { Hono } from "hono";
import { requireSession } from "../composable/session/middleware";
import { Layout } from "../component/layout";
import { requireAdmin } from "../composable/user/admin";

const app = new Hono<Env>({ strict: false })
  .use(requireSession({ action: "throw" }))
  .use(requireAdmin())
  .get("/", async (c) => {
    return c.render(<Layout title="Admin console"></Layout>);
  });

export default app;
