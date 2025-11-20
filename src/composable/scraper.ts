import type { KyInstance } from "ky";
import { unescape } from "@std/html/entities";

/**
 * Global timeout for scraping requests, in ms.
 */
const TIMEOUT = 5000;

/**
 * Fetch HTML from URL and process it with {@link HTMLRewriter}.
 */
async function processHTML(
  ky: KyInstance,
  url: string,
  rewriter: HTMLRewriter,
): Promise<void> {
  // ky's response object is actually subclass of Response
  let resp: Response;

  // Set end-to-end (including reading header and body) timeout with this signal.
  const signal = AbortSignal.timeout(TIMEOUT);

  try {
    resp = await ky.get(url, {
      throwHttpErrors: false,
      retry: 0,
      signal,
    });
  } catch (err) {
    console.warn(`Failed to fetch url ${url}`, err);
    return;
  }

  // FIXME: Validate content-type is html. If not, do a resp.body.cancel

  // Kickstart the transform, then consume the body to /dev/null.
  // Consuming the body is necessary to make sure HTMLRewriter callbacks got
  // called.
  try {
    await rewriter.transform(resp)?.body?.pipeTo(new WritableStream(), {
      signal,
    });
  } catch (err) {
    // No need to return anything special on error. The caller should handle
    // the result based on what they collected in their HTMLRewriter handlers.

    if (err instanceof DOMException && err.name === "AbortError") {
      console.warn(`Body read timeout for url ${url}`);
    } else {
      console.warn(`Error when reading url body from ${url}`, err);
    }
  }
}

/**
 * Get title of HTML from given URL.
 *
 * If the we cannot fetch the page because of network error, or the page does
 * not have a title element, this will return empty string.
 *
 * This will still parse HTML document that contains error (>= 400) HTTP status
 * code.
 */
export async function getHTMLTitle(
  ky: KyInstance,
  url: string,
): Promise<string> {
  let title: string[] = [];

  // omg HTMLRewriter is pure magic
  const rewriter = new HTMLRewriter();
  rewriter.on("head>title", {
    element() {
      // Reset title buffer in case the page got multiple titles. We always use
      // the text from the last title tag.
      title = [];
    },
    text(text) {
      // Push text fragment to buffer, because HTMLRewriter pipes text in stream
      // to us. See https://developers.cloudflare.com/workers/runtime-apis/html-rewriter/#text-chunks
      title.push(text.text);
    },
  });

  await processHTML(ky, url, rewriter);

  return unescape(title.join("").trim());
}

/**
 * Get image preview URL from HTML meta tags.
 *
 * This function scrapes the given URL as HTML and tries to extract image preview
 * URLs from meta tags. It supports:
 * - Open Graph Protocol (og:image): https://ogp.me/
 * - Twitter Cards (twitter:image): https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/markup
 *
 * When more than one matching tags exists, this will return the last parsed
 * tags, regardless of which meta tags format used.
 *
 * If the we cannot fetch the page because of network error, or the page does
 * not have any image meta tags, this will return null.
 *
 * This will still parse HTML document that contains error (>= 400) HTTP status
 * code.
 */
export async function getSocialImageUrl(
  ky: KyInstance,
  url: string,
): Promise<URL | null> {
  let imageUrl: string | null = null;

  const rewriter = new HTMLRewriter();
  rewriter.on("head>meta", {
    element(element) {
      // Check for og:image. Like <meta property="og:image" content="img_link">
      const property = element.getAttribute("property");
      if (property === "og:image") {
        const content = element.getAttribute("content");
        if (content != null) {
          imageUrl = content;
        }
      }

      // Check for twitter:image. Like <meta name="twitter:image" content="img_link">
      const name = element.getAttribute("name");
      if (name === "twitter:image") {
        const content = element.getAttribute("content");
        if (content != null) {
          imageUrl = content;
        }
      }
    },
  });

  await processHTML(ky, url, rewriter);

  if (imageUrl == null) {
    return null;
  }

  try {
    // FIXME: Validate schema and regex?
    return new URL(imageUrl, url);
  } catch {
    console.warn("Cannot parse image tag as URL", imageUrl);
    return null;
  }
}

/**
 * Get favicon URL from HTML link tags or fallback to /favicon.ico.
 *
 * This function scrapes the given URL as HTML and tries to extract favicon
 * URLs from link tags. It supports:
 * - <link rel="icon" href="...">
 * - <link rel="shortcut icon" href="...">
 * - <link rel="apple-touch-icon" href="...">
 *
 * When more than one matching tags exists, this will return the last parsed
 * tag with preference to "icon" rel values.
 *
 * If no favicon link tags are found, this will fallback to /favicon.ico
 * at the origin of the URL.
 *
 * If the we cannot fetch the page because of network error, this will
 * return the fallback /favicon.ico URL.
 *
 * This will still parse HTML document that contains error (>= 400) HTTP status
 * code.
 */
export async function getFaviconUrl(
  ky: KyInstance,
  url: string,
): Promise<URL> {
  let faviconUrl: string | null = null;

  const rewriter = new HTMLRewriter();
  rewriter.on("head>link", {
    element(element) {
      const rel = element.getAttribute("rel");
      if (rel == null) {
        return;
      }

      // Check for various favicon rel attributes
      const isIcon =
        rel === "icon" ||
        rel === "shortcut icon" ||
        rel === "apple-touch-icon";

      if (isIcon) {
        const href = element.getAttribute("href");
        if (href != null) {
          faviconUrl = href;
        }
      }
    },
  });

  await processHTML(ky, url, rewriter);

  // If we found a favicon URL in the HTML, use it
  if (faviconUrl != null) {
    try {
      return new URL(faviconUrl, url);
    } catch {
      console.warn("Cannot parse favicon tag as URL", faviconUrl);
    }
  }

  // Fallback to /favicon.ico at the origin
  const parsedUrl = new URL(url);
  return new URL("/favicon.ico", parsedUrl.origin);
}
