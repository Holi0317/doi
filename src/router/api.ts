import { Hono } from "hono";
import * as z from "zod";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session";
import { getHTMLTitle } from "../composable/scraper";
import { useKy } from "../composable/http";
import { encodeCursor } from "../composable/cursor";

const app = new Hono<Env>()
  .use(requireSession("redirect"))

  .get(
    "/search",
    zv(
      "query",
      z.object({
        query: z.string().nullish(),
        cursor: z.string().nullish(),
        // FIXME: 'false' is coerced into true with zod. Figure out query param
        // semantics later
        archive: z.coerce.boolean().optional(),
        favorite: z.coerce.boolean().optional(),
        limit: z.coerce.number().min(1).max(300).default(30),
        order: z.literal(["id_asc", "id_desc"]).default("id_desc"),
      }),
    ),
    async (c) => {
      const stub = await getStorageStub(c);

      const q = c.req.valid("query");

      const search = await stub.search(q);

      const lastID = search.items.at(-1)?.id;
      const cursor = lastID == null ? null : encodeCursor(lastID);

      return c.json({
        ...search,
        cursor,
      });
    },
  )

  .post(
    "/insert",
    zv(
      "json",
      z.object({
        items: z
          .array(
            z.object({
              title: z.string().nullish(),
              url: z
                .url({
                  protocol: /^https?$/,
                  hostname: z.regexes.domain,
                  normalize: true,
                })
                .transform((val) => {
                  const url = new URL(val);

                  url.hash = "";
                  url.username = "";
                  url.password = "";

                  return url.toString();
                }),
            }),
          )
          .min(1, { error: "At least must have an item" })
          .max(100, { error: "At most 100 items per request" }),
      }),
    ),
    async (c) => {
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
    },
  );

export default app;
