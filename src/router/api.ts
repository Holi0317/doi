import { Hono } from "hono";
import pLimit from "p-limit";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session/middleware";
import {
  getHTMLTitle,
  getSocialImageUrl,
  getFaviconUrl,
} from "../composable/scraper";
import { useKy } from "../composable/http";
import { encodeCursor } from "../composable/cursor";
import {
  EditBodySchema,
  IDStringSchema,
  SearchQuerySchema,
  ImageQuerySchema,
} from "../schemas";
import { fetchImage, parseAcceptImageFormat } from "../composable/image";
import { useCache } from "../composable/cache";
import { getUser } from "../composable/user/getter";
import { REQUEST_CONCURRENCY } from "./constants";

const app = new Hono<Env>({ strict: false })
  /**
   * Version check / user info endpoint
   */
  .get("/", async (c) => {
    const user = await getUser(c);

    return c.json({
      // This name is used for client to probe and verify the correct API endpoint.
      name: "doi",
      version: c.env.CF_VERSION_METADATA,
      session:
        user == null
          ? null
          : {
              source: user.source,
              name: user.name,
              login: user.login,
              avatarUrl: user.avatarUrl,
            },
    });
  })
  .use(requireSession({ action: "throw" }))

  .get("/image", zv("query", ImageQuerySchema), async (c) => {
    const { url, type, dpr, width, height } = c.req.valid("query");
    const format = parseAcceptImageFormat(c);

    // Create a cache key based on the URL and parameters
    const cacheKey = new URL(url);

    // Override search params for cache key
    // Adding `x-` prefix to avoid (unlikely) collision with original URL params
    const override = {
      "x-type": type,
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

    // Abuse useCache for caching extracted image URL
    // Use different cache namespace for social vs favicon
    const cacheNamespace = type === "favicon" ? "favicon_url" : "image_url";
    const imageUrlResp = await useCache(
      cacheNamespace,
      new URL(url),
      async () => {
        // Fetch and extract image URL from the page based on type
        let imageUrl: URL | null = null;

        if (type === "favicon") {
          imageUrl = await getFaviconUrl(ky, url);
        } else {
          imageUrl = await getSocialImageUrl(ky, url);
        }

        const body = imageUrl == null ? "" : imageUrl.toString();

        return new Response(body, {
          status: 200,
          headers: {
            "content-type": "text/plain",
            // Cache for 24 hours. Maybe I should respect Cache-Control from origin instead?
            "cache-control": "public, max-age=86400",
          },
        });
      },
    );

    const imageUrl = await imageUrlResp.text();
    if (imageUrl === "") {
      console.info(`No ${type} image found for URL`, url);
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

  .post("/edit", zv("json", EditBodySchema), async (c) => {
    const body = c.req.valid("json");

    const stub = await getStorageStub(c);
    const ky = useKy(c);
    const limit = pLimit(REQUEST_CONCURRENCY);

    const inserts = body.op.filter((op) => op.op === "insert");
    const edits = body.op.filter((op) => op.op !== "insert");

    const resolved = await limit.map(inserts, async (item) => {
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

    // Apply edits before inserts. We don't want to allow user to edit newly inserted
    // items by predicting their IDs.
    if (edits.length) {
      await stub.edit(edits);
    }

    if (resolved.length) {
      await stub.insert(resolved);
    }

    return c.text("", 201);
  });

export default app;

export type APIAppType = typeof app;
