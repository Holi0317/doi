import { createMiddleware } from "hono/factory";

/**
 * Block requests that are likely to cause request loops via image resizing.
 *
 * See https://developers.cloudflare.com/images/transform-images/transform-via-workers/#prevent-request-loops
 */
export function blockRequestLoop() {
  return createMiddleware(async (c, next) => {
    const via = c.req.header("Via");
    if (via?.toLowerCase().includes("image-resizing")) {
      return c.text("Request loop detected", 508);
    }

    await next();
  });
}
