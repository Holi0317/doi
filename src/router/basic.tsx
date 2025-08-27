import { Hono } from "hono";
import { requireSession } from "../composable/session";
import { SearchQuerySchema } from "../schemas";
import { zv } from "../composable/validator";
import { Layout } from "../component/layout";
import { Pagination } from "../component/Pagination";
import { LinkItem } from "../component/LinkItem";

/**
 * Basic views for the app
 */
const app = new Hono<Env>({ strict: false })
  .use(requireSession("redirect"))

  .get("/", zv("query", SearchQuerySchema), async (c) => {
    const queries = c.req.queries();

    const resp = await c.get("client").api.search.$get({
      query: queries,
    });
    const jason = await resp.json();

    return c.html(
      <Layout title="List">
        {jason.items.map((item) => (
          <LinkItem item={item} />
        ))}

        <hr />

        <Pagination cursor={jason.cursor} queries={c.req.valid("query")} />
      </Layout>,
    );
  });

export default app;
