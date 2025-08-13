import type { KyInstance } from "ky";

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

  try {
    resp = await ky.get(url, {
      throwHttpErrors: false,
      timeout: 5,
      retry: 0,
    });
  } catch (err) {
    console.warn(`Failed to fetch url ${url}`, err);
    return "";
  }

  let title: string[] = [];

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
    },
  });

  // Kickstart the transform, then consume the body to /dev/null.
  // Consuming the body is necessary to make sure HTMLRewriter callbacks got
  // called.
  await rewriter.transform(resp)?.body?.pipeTo(new WritableStream());

  return title.join("");
}
