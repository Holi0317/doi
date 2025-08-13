import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import { createTestClient } from "./client";

interface TestCase {
  insert: Array<{
    title: string;
    url: string;
  }>;

  insertResponse: Array<{
    id: number;
    title: string;
    url: string;
  }>;
}

async function testInsert(tc: TestCase) {
  const client = await createTestClient();

  const insert = await client.api.insert.$post({
    json: {
      items: tc.insert,
    },
  });

  expect(insert.status).toEqual(201);
  expect(await insert.json()).toEqual(tc.insertResponse);
}

describe("Link insert", () => {
  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should insert link and store it", async () => {
    await testInsert({
      insert: [{ title: "asdf", url: "https://google.com" }],
      insertResponse: [{ id: 1, title: "asdf", url: "https://google.com/" }],
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

    await testInsert({
      insert: [{ title: "", url: "https://google.com" }],
      insertResponse: [
        {
          id: 1,
          title: "My cute title",
          url: "https://google.com/",
        },
      ],
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

    await testInsert({
      insert: [{ title: "", url: "https://google.com" }],
      insertResponse: [
        {
          id: 1,
          title: "You should still use this 404 title",
          url: "https://google.com/",
        },
      ],
    });
  });

  it("should use empty string as title if document fetch failed", async () => {
    await testInsert({
      insert: [{ title: "", url: "https://google.com" }],
      insertResponse: [
        {
          id: 1,
          title: "",
          url: "https://google.com/",
        },
      ],
    });
  });

  it("should deduplicate same URL in different request", async () => {
    await testInsert({
      insert: [{ title: "first", url: "https://google.com" }],
      insertResponse: [
        {
          id: 1,
          title: "first",
          url: "https://google.com/",
        },
      ],
    });

    await testInsert({
      insert: [{ title: "second", url: "https://google.com" }],
      insertResponse: [
        {
          id: 2,
          title: "second",
          url: "https://google.com/",
        },
      ],
    });
  });

  it("should deduplicate same URL in same request", async () => {
    await testInsert({
      insert: [
        // Also testing dedupe is after cleaning the url
        { title: "first", url: "https://google.com#123" },
        { title: "second", url: "https://google.com#456" },
      ],
      insertResponse: [
        {
          id: 2,
          title: "second",
          url: "https://google.com/",
        },
      ],
    });
  });

  it("should remove hash, username and password from URL", async () => {
    await testInsert({
      insert: [
        {
          title: "asdf",
          url: "https://username:password@google.com?query=123&query=456#hash",
        },
      ],
      insertResponse: [
        {
          id: 1,
          title: "asdf",
          url: "https://google.com/?query=123&query=456",
        },
      ],
    });
  });
});
