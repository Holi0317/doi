import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import type { InferRequestType } from "hono/client";
import type { ClientType } from "./client";
import { createTestClient } from "./client";

describe("Link insert", () => {
  interface TestCase {
    insert: InferRequestType<
      ClientType["api"]["insert"]["$post"]
    >["json"]["items"];

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

  it("should remove tracking query", async () => {
    await testInsert({
      insert: [
        {
          title: "asdf",
          url: "https://google.com?utm_content=buffercf3b2&utm_medium=social&utm_source=snapchat.com&utm_campaign=buffer",
        },
      ],
      insertResponse: [
        {
          id: 1,
          title: "asdf",
          url: "https://google.com/",
        },
      ],
    });
  });
});

describe("HTML title scraping", () => {
  interface TestCase {
    title: string;
    expected: string;
  }

  async function testInsert(tc: TestCase) {
    fetchMock
      .get("https://google.com")
      .intercept({ path: "/", method: "get" })
      .reply(
        200,
        `<!doctype html><html><head><title>${tc.title}</title></head></html>`,
      );

    const client = await createTestClient();

    const insert = await client.api.insert.$post({
      json: {
        items: [{ title: "", url: "https://google.com" }],
      },
    });

    expect(insert.status).toEqual(201);
    expect(await insert.json()).toEqual([
      {
        id: 1,
        title: tc.expected,
        url: "https://google.com/",
      },
    ]);
  }

  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should fetch title from document", async () => {
    await testInsert({
      title: "My cute title",
      expected: "My cute title",
    });
  });

  it("should unescape html entity", async () => {
    await testInsert({
      title: "Hash &#35; and &amp; lt &lt; lt &#60;",
      expected: "Hash # and & lt < lt <",
    });
  });

  it("should trim excessive whitespace", async () => {
    await testInsert({
      title: `     


Hello


w

      

`,
      expected: "Hello\n\n\nw",
    });
  });
});
