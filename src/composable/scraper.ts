import type { KyInstance } from "ky";

/**
 * Get title of HTML from given URL.
 */
export async function getHTMLTitle(
  ky: KyInstance,
  url: string,
): Promise<string | null> {
  const resp = await ky.get(url, {
    throwHttpErrors: false,
    timeout: 5,
    retry: 0,
  });

  let title: string | null = null;

  const rewriter = new HTMLRewriter();
  rewriter.on("head.title", {
    text(text) {
      title = text.text;
    },
  });

  rewriter.transform(resp);

  return title;
}
