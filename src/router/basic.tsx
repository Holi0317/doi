import { Hono } from "hono";
import * as z from "zod";
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
    const queryRaw = c.req.queries();

    // Assume empty query means someone opens this page for the first time.
    // We wanna show unarchived items if that's the case.
    if (Object.keys(queryRaw).length === 0) {
      return c.redirect("?archive=false");
    }

    const resp = await c.get("client").api.search.$get({
      query: queryRaw,
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
  })
  .post(
    "/archive",
    zv("form", z.object({ id: z.coerce.number() })),
    async (c) => {
      const { id } = c.req.valid("form");

      await c.get("client").api.edit.$post({
        json: {
          op: [{ op: "set", field: "archive", id, value: true }],
        },
      });

      return c.redirect("/basic?archive=false");
    },
  );

export default app;
