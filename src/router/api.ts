import { Hono } from "hono";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session";
import { getHTMLTitle, getHTMLImagePreview } from "../composable/scraper";
import { useKy } from "../composable/http";
import { encodeCursor } from "../composable/cursor";
import {
  EditBodySchema,
  IDStringSchema,
  InsertBodySchema,
  SearchQuerySchema,
} from "../schemas";
import * as z from "zod";

const app = new Hono<Env>({ strict: false })
  .get(
    "/image",
    zv("query", z.object({ url: z.string().url() })),
    async (c) => {
      const { url } = c.req.valid("query");

      // Create a cache key based on the URL
      const cacheKey = new URL(c.req.url);
      const cache = caches.default;

      // Try to get from cache first
      let response = await cache.match(cacheKey);
      if (response) {
        return response;
      }

      // Fetch and extract image URL from the page
      const ky = useKy(c);
      const imageUrl = await getHTMLImagePreview(ky, url);

      if (!imageUrl) {
        // No image found, return 404 with empty body
        response = new Response("", { status: 404 });
        // Cache 404 responses for a shorter duration (5 minutes)
        await cache.put(cacheKey, response.clone());
        return response;
      }

      // Fetch the actual image
      try {
        const imageResponse = await ky.get(imageUrl, {
          throwHttpErrors: false,
        });

        if (!imageResponse.ok) {
          response = new Response("", { status: 404 });
          await cache.put(cacheKey, response.clone());
          return response;
        }

        // Create response with the image
        response = new Response(imageResponse.body, {
          status: 200,
          headers: {
            "Content-Type":
              imageResponse.headers.get("Content-Type") || "image/jpeg",
            "Cache-Control": "public, max-age=86400", // Cache for 24 hours
          },
        });

        // Store in cache
        await cache.put(cacheKey, response.clone());

        return response;
      } catch (err) {
        console.warn(`Failed to fetch image from ${imageUrl}`, err);
        response = new Response("", { status: 404 });
        await cache.put(cacheKey, response.clone());
        return response;
      }
    },
  )

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
