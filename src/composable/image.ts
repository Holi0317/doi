import type { KyInstance } from "ky";

export async function fetchImage(
  ky: KyInstance,
  url: URL | null,
): Promise<Response> {
  const notFound = new Response("", { status: 404 });

  if (url == null) {
    return notFound;
  }

  const resp = await ky.get(url, { throwHttpErrors: false });
  if (!resp.ok) {
    await resp.body?.cancel();
    return notFound;
  }

  const mime = resp.headers.get("content-type");
  if (mime == null || !mime.startsWith("image/")) {
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
