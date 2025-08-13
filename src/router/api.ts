import { Hono } from "hono";
import * as z from "zod";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session";
import { getHTMLTitle } from "../composable/scraper";
import { useKy } from "../composable/http";

const app = new Hono<Env>()
  .use(requireSession("redirect"))

  .get("/list", async (c) => {
    const stub = await getStorageStub(c);

    const links = await stub.search({
      limit: 30,
      order: "id_desc",
    });

    return c.json(links);
  })

  .post(
    "/insert",
    zv(
      "json",
      z.object({
        items: z
          .array(
            z.object({
              title: z.string().nullish(),
              // FIXME: Remove id from URL
              url: z.url({
                protocol: /^https?$/,
                hostname: z.regexes.domain,
                normalize: true,
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

          const title = (await getHTMLTitle(ky, item.url)) || item.url;

          return {
            title,
            url: item.url,
          };
        }),
      );

      const inserted = await stub.insert(resolved);

      return c.json(inserted, 201);
    },
  );

export default app;
