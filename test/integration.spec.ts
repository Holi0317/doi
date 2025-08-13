import { SELF, fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import { createTestClient } from "./client";

describe("Integration test", () => {
  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("responds with not found and proper status for /404", async () => {
    const response = await SELF.fetch("http://example.com/404");
    expect(response.status).toBe(404);
    expect(await response.text()).toBe("404 Not Found");
  });

  it("should get authenticated successfully", async () => {
    const client = await createTestClient();

    const response = await client.auth.$get();

    expect(response.status).toEqual(200);
    expect(await response.text()).toEqual("Hello <testing user>!");
  });

  it("should insert link and store it", async () => {
    const client = await createTestClient();

    const insert = await client.api.insert.$post({
      json: {
        items: [{ title: "asdf", url: "https://google.com" }],
      },
    });

    expect(insert.status).toEqual(201);
    expect(await insert.json()).toEqual([{ id: 1 }]);

    const list = await client.api.list.$get();

    expect(list.status).toEqual(200);
    const items = await list.json();

    expect(Array.isArray(items)).toEqual(true);
    expect(items.length).toEqual(1);

    const item = items[0];
    expect(item).toEqual({
      archive: false,
      created_at: expect.any(Number),
      favorite: false,
      id: 1,
      title: "asdf",
      url: "https://google.com/",
    });
  });

  it("should fetch title from document", async () => {
    fetchMock
      .get("https://google.com")
      .intercept({ path: "/", method: "get" })
      .reply(
        200,
        `<!doctype html><html><head><title>My cute title</title></head></html>`,
      );

    const client = await createTestClient();

    const insert = await client.api.insert.$post({
      json: {
        items: [{ title: "", url: "https://google.com" }],
      },
    });

    expect(insert.status).toEqual(201);
    expect(await insert.json()).toEqual([{ id: 1 }]);

    const list = await client.api.list.$get();
    const items = await list.json();

    expect(items[0]).toEqual({
      archive: false,
      created_at: expect.any(Number),
      favorite: false,
      id: 1,
      title: "My cute title",
      url: "https://google.com/",
    });
  });

  it("should use document title when http response isn't ok", async () => {
    fetchMock
      .get("https://google.com")
      .intercept({ path: "/", method: "get" })
      .reply(
        404,
        `<!doctype html><html><head><title>You should still use this 404 title</title></head></html>`,
      );

    const client = await createTestClient();

    const insert = await client.api.insert.$post({
      json: {
        items: [{ title: "", url: "https://google.com" }],
      },
    });

    expect(insert.status).toEqual(201);
    expect(await insert.json()).toEqual([{ id: 1 }]);

    const list = await client.api.list.$get();
    const items = await list.json();

    expect(items[0]).toEqual({
      archive: false,
      created_at: expect.any(Number),
      favorite: false,
      id: 1,
      title: "You should still use this 404 title",
      url: "https://google.com/",
    });
  });

  it("should use url as title if document fetch failed", async () => {
    const client = await createTestClient();

    const insert = await client.api.insert.$post({
      json: {
        items: [{ title: "", url: "https://google.com" }],
      },
    });

    expect(insert.status).toEqual(201);
    expect(await insert.json()).toEqual([{ id: 1 }]);

    const list = await client.api.list.$get();
    const items = await list.json();

    expect(items[0]).toEqual({
      archive: false,
      created_at: expect.any(Number),
      favorite: false,
      id: 1,
      title: "https://google.com/",
      url: "https://google.com/",
    });
  });
});
