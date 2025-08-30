import { Hono } from "hono";
import { jsxRenderer } from "hono/jsx-renderer";
import * as z from "zod";
import { requireSession } from "../composable/session";
import type { EditOpSchema } from "../schemas";
import { IDStringSchema, SearchQuerySchema } from "../schemas";
import { zv } from "../composable/validator";
import { Layout } from "../component/layout";
import { Pagination } from "../component/Pagination";
import { LinkItem } from "../component/LinkItem";
import { LinkItemForm } from "../component/LinkItemForm";
import * as zu from "../zod-utils";
import { InsertForm } from "../component/InsertForm";

const ItemEditSchema = z.object({
  archive: zu.queryBool().optional(),
  favorite: zu.queryBool().optional(),
});

/**
 * Basic views for the app
 */
const app = new Hono<Env>({ strict: false })
  .use(requireSession("redirect"))
  .use(
    jsxRenderer(
      ({ children }) => {
        return <>{children}</>;
      },
      { docType: true },
    ),
  )

  .get("/", zv("query", SearchQuerySchema), async (c) => {
    const queryRaw = c.req.queries();

    // Assume empty query means someone opens this page for the first time.
    // We wanna show unarchived items if that's the case.
    if (Object.keys(queryRaw).length === 0) {
      return c.redirect("?archive=false");
    }

    const resp = await c.get("client").search.$get({
      query: queryRaw,
    });
    const jason = await resp.json();

    return c.render(
      <Layout title="List">
        <InsertForm />

        <ul>
          {jason.items.map((item) => (
            <LinkItem item={item} />
          ))}
        </ul>

        <hr />

        <Pagination cursor={jason.cursor} queries={c.req.valid("query")} />
      </Layout>,
    );
  })
  .post("/insert", zv("form", z.object({ url: z.string() })), async (c) => {
    const { url } = c.req.valid("form");

    const resp = await c.get("client").insert.$post({
      json: {
        items: [
          {
            url,
          },
        ],
      },
    });

    if (resp.status >= 400) {
      return c.json(await resp.json(), resp.status);
    }

    return c.redirect("/basic?archive=false");
  })

  .post("/archive", zv("form", IDStringSchema), async (c) => {
    const { id } = c.req.valid("form");

    await c.get("client").edit.$post({
      json: {
        op: [{ op: "set", field: "archive", id, value: true }],
      },
    });

    return c.redirect("/basic?archive=false");
  })

  .get("/edit/:id", zv("param", IDStringSchema), async (c) => {
    const { id } = c.req.valid("param");

    const resp = await c.get("client").item[":id"].$get({
      param: {
        id: id.toString(),
      },
    });

    if (resp.status === 404) {
      return c.text("not found", 404);
    }

    const jason = await resp.json();

    return c.render(
      <Layout title="Edit">
        <a href="/basic">Back</a>
        <LinkItemForm item={jason} />

        <form method="post" action={`/basic/edit/${id}/delete`}>
          <input type="submit" value="Delete" />
        </form>
      </Layout>,
    );
  })

  .post(
    "/edit/:id",
    zv("param", IDStringSchema),
    zv("form", ItemEditSchema),
    async (c) => {
      const { id } = c.req.valid("param");
      const form = c.req.valid("form");

      const op: Array<z.input<typeof EditOpSchema>> = [];

      if (form.archive != null) {
        op.push({
          op: "set",
          field: "archive",
          id,
          value: form.archive,
        });
      }

      if (form.favorite != null) {
        op.push({
          op: "set",
          field: "favorite",
          id,
          value: form.favorite,
        });
      }

      await c.get("client").edit.$post({
        json: {
          op,
        },
      });

      return c.redirect(`/basic/edit/${id}`);
    },
  )

  .post("/edit/:id/delete", zv("param", IDStringSchema), async (c) => {
    const { id } = c.req.valid("param");

    await c.get("client").edit.$post({
      json: {
        op: [{ op: "delete", id }],
      },
    });

    return c.redirect(`/basic`);
  });

export default app;
