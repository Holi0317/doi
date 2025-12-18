import type { Context } from "hono";
import { accepts } from "hono/accepts";
import type { KyInstance } from "ky";

export interface FetchImageOptions {
  dpr?: number;
  width?: number;
  height?: number;
  format?: RequestInitCfPropertiesImage["format"];
}

/**
 * Parse Accept header for image formats to cloudflare image compression.
 *
 * Defaults to jpeg.
 */
export function parseAcceptImageFormat(
  c: Context,
): "webp" | "png" | "jpeg" | "avif" {
  const header = accepts(c, {
    header: "Accept",
    supports: ["image/webp", "image/png", "image/jpeg", "image/avif"],
    default: "image/jpeg",
  });

  switch (header) {
    case "image/webp":
      return "webp";
    case "image/png":
      return "png";
    case "image/avif":
      return "avif";
    case "image/jpeg":
    default:
      return "jpeg";
  }
}

/**
 * Fetch image from given URL, and transform via Cloudflare Image resizing.
 *
 * In case of failure (non-ok response, non-image response), returns 404 Response with empty body.
 */
export async function fetchImage(
  ky: KyInstance,
  url: URL,
  options?: FetchImageOptions,
): Promise<Response> {
  const notFound = new Response("", { status: 404 });

  console.info("Fetching image from URL", url.toString());

  // Build the cf image options, only including provided parameters
  const resp = await ky.get(url, {
    throwHttpErrors: false,
    headers: {
      // Has to pass in proper accept header, in addition to `cf.image.format`
      // to make format transformation to kick in.
      accept:
        options?.format == null ? "image/jpeg" : `image/${options?.format}`,
    },
    cf: {
      // Not including transform options in cache key.
      // See https://developers.cloudflare.com/images/transform-images/transform-via-workers/#warning-about-cachekey
      cacheKey: url.toString(),
      // Transform image base on provided options
      // See https://developers.cloudflare.com/images/transform-images/transform-via-workers/#fetch-options
      image: {
        anim: false,
        fit: "scale-down",
        // From documentation above. "1 is a recommended value for downscaled images."
        sharpen: 1,
        ...options,
      },
    },
  });
  if (!resp.ok) {
    console.warn(
      "Image fetch responded with non-ok status code",
      resp.status,
      // FIXME: Limit size of text? And handle non-text response?
      await resp.text(),
    );

    return notFound;
  }

  // I don't think we'll ever get non-image here, but just in case.
  const mime = resp.headers.get("content-type");
  if (mime == null || !mime.startsWith("image/")) {
    console.warn("Image fetch responded with non-image body", mime);

    await resp.body?.cancel();
    return notFound;
  }

  return new Response(resp.body, {
    status: 200,
    headers: {
      "content-type": mime,
      "cache-control": "public, max-age=86400", // Cache for 24 hours
    },
  });
}
