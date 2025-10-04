import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import { createTestClient } from "./client";

describe("Image preview API", () => {
  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should return image when og:image meta tag is present", async () => {
    const client = await createTestClient();

    // Mock the HTML page with og:image
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/page", method: "get" })
      .reply(
        200,
        `<!doctype html>
        <html>
          <head>
            <meta property="og:image" content="https://example.com/image.jpg" />
          </head>
        </html>`,
      );

    // Mock the image fetch
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/image.jpg", method: "get" })
      .reply(200, "fake-image-data", {
        headers: { "Content-Type": "image/jpeg" },
      });

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/page" },
    });

    expect(resp.status).toEqual(200);
    expect(resp.headers.get("Content-Type")).toEqual("image/jpeg");
    expect(await resp.text()).toEqual("fake-image-data");
  });

  it("should return image when twitter:image meta tag is present", async () => {
    const client = await createTestClient();

    // Mock the HTML page with twitter:image
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/page", method: "get" })
      .reply(
        200,
        `<!doctype html>
        <html>
          <head>
            <meta name="twitter:image" content="https://example.com/twitter-image.png" />
          </head>
        </html>`,
      );

    // Mock the image fetch
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/twitter-image.png", method: "get" })
      .reply(200, "fake-twitter-image", {
        headers: { "Content-Type": "image/png" },
      });

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/page" },
    });

    expect(resp.status).toEqual(200);
    expect(resp.headers.get("Content-Type")).toEqual("image/png");
    expect(await resp.text()).toEqual("fake-twitter-image");
  });

  it("should prefer the last image tag", async () => {
    const client = await createTestClient();

    // Mock the HTML page with both meta tags
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/page", method: "get" })
      .reply(
        200,
        `<!doctype html>
        <html>
          <head>
            <meta property="og:image" content="https://example.com/og-image.jpg" />
            <meta name="twitter:image" content="https://example.com/twitter-image.png" />
          </head>
        </html>`,
      );

    // Mock the image fetch
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/twitter-image.png", method: "get" })
      .reply(200, "twitter-image-data", {
        headers: { "Content-Type": "image/png" },
      });

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/page" },
    });

    expect(resp.status).toEqual(200);
    expect(resp.headers.get("Content-Type")).toEqual("image/png");
    expect(await resp.text()).toEqual("twitter-image-data");
  });

  it("should return 404 when no image meta tags are present", async () => {
    const client = await createTestClient();

    // Mock the HTML page without image meta tags
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/no-image", method: "get" })
      .reply(
        200,
        `<!doctype html>
        <html>
          <head>
            <title>Page without image</title>
          </head>
        </html>`,
      );

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/no-image" },
    });

    expect(resp.status).toEqual(404);
    expect(await resp.text()).toEqual("");
  });

  it("should return 404 when the page cannot be fetched", async () => {
    const client = await createTestClient();

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/nonexistent" },
    });

    expect(resp.status).toEqual(404);
    expect(await resp.text()).toEqual("");
  });

  async function testReturn404() {
    const client = await createTestClient();

    // Mock the HTML page with og:image
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/page", method: "get" })
      .reply(
        200,
        `<!doctype html>
        <html>
          <head>
            <meta property="og:image" content="https://example.com/broken-image.jpg" />
          </head>
        </html>`,
      );

    const resp = await client.api.image.$get({
      query: { url: "https://example.com/page" },
    });

    expect(resp.status).toEqual(404);
    expect(await resp.text()).toEqual("");
  }

  it("should return 404 when the image URL returns 500", async () => {
    // Image fetch fails
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/broken-image.jpg", method: "get" })
      .reply(500, "xxx", {
        headers: { "Content-Type": "image/png" },
      });

    await testReturn404();
  });

  it("should return 404 when the image URL returns non image/* content-type", async () => {
    // Image fetch fails
    fetchMock
      .get("https://example.com")
      .intercept({ path: "/broken-image.jpg", method: "get" })
      .reply(200, "xxx", {
        headers: { "Content-Type": "application/zip" },
      });

    await testReturn404();
  });
});
