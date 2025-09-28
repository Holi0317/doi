import { Hono } from "hono";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session";
import { getHTMLTitle } from "../composable/scraper";
import { useKy } from "../composable/http";
import { encodeCursor } from "../composable/cursor";
import {
  EditBodySchema,
  IDStringSchema,
  InsertBodySchema,
  SearchQuerySchema,
} from "../schemas";

const app = new Hono<Env>({ strict: false })
  .use(requireSession("throw"))

  .get("/item/:id", zv("param", IDStringSchema), async (c) => {
    const stub = await getStorageStub(c);
    const { id } = c.req.valid("param");

    const item = await stub.get(id);

    if (item == null) {
      return c.json(
        {
          message: "not found",
        },
        404,
      );
    }

    return c.json(item);
  })

  .get("/search", zv("query", SearchQuerySchema), async (c) => {
    const stub = await getStorageStub(c);

    const q = c.req.valid("query");

    const search = await stub.search(q);

    const lastID = search.items.at(-1)?.id;
    const cursor =
      lastID == null || !search.hasMore ? null : encodeCursor(lastID);

    return c.json({
      ...search,
      cursor,
    });
  })

  .post("/insert", zv("json", InsertBodySchema), async (c) => {
    const stub = await getStorageStub(c);

    const ky = useKy(c);

    const body = c.req.valid("json");

    const resolved = await Promise.all(
      body.items.map(async (item) => {
        if (item.title) {
          return {
            title: item.title,
            url: item.url,
          };
        }

        const title = await getHTMLTitle(ky, item.url);

        return {
          title: title.substring(0, 512),
          url: item.url,
        };
      }),
    );

    const inserted = await stub.insert(resolved);

    return c.json(inserted, 201);
  })
  .post("/edit", zv("json", EditBodySchema), async (c) => {
    const stub = await getStorageStub(c);

    const body = c.req.valid("json");
    await stub.edit(body);

    return c.text("", 201);
  });

export default app;

export type APIAppType = typeof app;
