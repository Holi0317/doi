import { Hono } from "hono";
import pLimit from "p-limit";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { getSession, requireSession } from "../composable/session";
import { getHTMLTitle, getSocialImageUrl } from "../composable/scraper";
import { useKy } from "../composable/http";
import { encodeCursor } from "../composable/cursor";
import {
  EditBodySchema,
  IDStringSchema,
  InsertBodySchema,
  SearchQuerySchema,
  ImageQuerySchema,
} from "../schemas";
import { fetchImage, parseAcceptImageFormat } from "../composable/image";
import { useCache } from "../composable/cache";
import { REQUEST_CONCURRENCY } from "./constants";

const app = new Hono<Env>({ strict: false })
  /**
   * Version check / user info endpoint
   */
  .get("/", async (c) => {
    const sess = await getSession(c);

    return c.json({
      // This name is used for client to probe and verify the correct API endpoint.
      name: "doi",
      version: c.env.CF_VERSION_METADATA,
      session:
        sess == null
          ? null
          : {
              source: sess.source,
              name: sess.name,
              login: sess.login,
              avatarUrl: sess.avatarUrl,
            },
    });
  })
  .use(requireSession("throw"))

  .get("/image", zv("query", ImageQuerySchema), async (c) => {
    const { url, dpr, width, height } = c.req.valid("query");
    const format = parseAcceptImageFormat(c);

    // Create a cache key based on the URL and parameters
    const cacheKey = new URL(url);

    // Override search params for cache key
    // Adding `x-` prefix to avoid (unlikely) collision with original URL params
    const override = {
      "x-dpr": dpr?.toString() || "",
      "x-width": width?.toString() || "",
      "x-height": height?.toString() || "",
      "x-format": format,
    };

    for (const [key, value] of Object.entries(override)) {
      if (value) {
        cacheKey.searchParams.append(key, value);
      }
    }

    const ky = useKy(c);

    // Abuse useCache for caching extracted social image URL
    const imageUrlResp = await useCache("image_url", new URL(url), async () => {
      // Fetch and extract image URL from the page
      const imageUrl = await getSocialImageUrl(ky, url);
      const body = imageUrl == null ? "" : imageUrl.toString();

      return new Response(body, {
        status: 200,
        headers: {
          "content-type": "text/plain",
          // Cache for 24 hours. Maybe I should respect Cache-Control from origin instead?
          "cache-control": "public, max-age=86400",
        },
      });
    });

    const imageUrl = await imageUrlResp.text();
    if (imageUrl === "") {
      console.info("No social image found for URL", url);
      return c.text("", 404);
    }

    return await fetchImage(ky, new URL(imageUrl), {
      dpr,
      width,
      height,
      format,
    });
  })

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

    const limit = pLimit(REQUEST_CONCURRENCY);

    const resolved = await limit.map(body.items, async (item) => {
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
    });

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
