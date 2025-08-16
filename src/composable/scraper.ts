import type { KyInstance } from "ky";

const TIMEOUT = 5000;

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
    return "";
  }

  let title: string[] = [];

  // omg HTMLRewriter is pure magic
  const rewriter = new HTMLRewriter();
  rewriter.on("title", {
    element() {
      // Reset title buffer in case the page got multiple titles. We always use
      // the text from the last title tag.
      title = [];
    },
    text(text) {
      // Push text fragment to buffer, because HTMLRewriter pipes text in stream
      // to us. See https://developers.cloudflare.com/workers/runtime-apis/html-rewriter/#text-chunks
      title.push(text.text);

      // Actually we can abort the controller (body read) when `text.lastInTextNode`
      // is true. Maybe we should do that later if it's cheaper.
    },
  });

  // Kickstart the transform, then consume the body to /dev/null.
  // Consuming the body is necessary to make sure HTMLRewriter callbacks got
  // called.
  try {
    await rewriter.transform(resp)?.body?.pipeTo(new WritableStream(), {
      signal,
    });
  } catch (err) {
    // No need to check on `title` or return anything special on error. Just return
    // whatever we've got in the buffer afterwards.

    if (err instanceof DOMException && err.name === "AbortError") {
      console.warn(`Body read timeout for url ${url}`);
    } else {
      console.warn(`Error when reading url body from ${url}`, err);
    }
  }

  return title.join("");
}
