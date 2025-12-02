import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import { createTestClient } from "./client";

describe("Link insert via edit", () => {
  interface TestCase {
    insert: Array<{
      title?: string | null;
      url: string;
    }>;

    expectedSearchResult: Array<{
      id: number;
      title: string;
      url: string;
    }>;
  }

  async function testInsert(tc: TestCase) {
    const client = await createTestClient();

    const editResp = await client.api.edit.$post({
      json: {
        op: tc.insert.map((item) => ({
          op: "insert" as const,
          title: item.title,
          url: item.url,
        })),
      },
    });

    expect(editResp.status).toEqual(201);
    expect(await editResp.text()).toEqual("");

    // Verify inserts via search
    const search = await client.api.search.$get({
      query: { order: "id_asc" },
    });
    const items = (await search.json()).items;

    expect(items).toEqual(
      tc.expectedSearchResult.map((expected) => ({
        ...expected,
        archive: false,
        created_at: expect.any(Number),
        favorite: false,
      })),
    );
  }

  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should insert link and store it", async () => {
    await testInsert({
      insert: [{ title: "asdf", url: "https://google.com" }],
      expectedSearchResult: [
        { id: 1, title: "asdf", url: "https://google.com/" },
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
      expectedSearchResult: [
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
      expectedSearchResult: [
        {
          id: 1,
          title: "",
          url: "https://google.com/",
        },
      ],
    });
  });

  it("should deduplicate same URL in different request", async () => {
    const client = await createTestClient();

    // First insert
    await client.api.edit.$post({
      json: {
        op: [{ op: "insert", title: "first", url: "https://google.com" }],
      },
    });

    // Second insert with same URL
    await client.api.edit.$post({
      json: {
        op: [{ op: "insert", title: "second", url: "https://google.com" }],
      },
    });

    // Verify via search
    const search = await client.api.search.$get({
      query: { order: "id_asc" },
    });
    const items = (await search.json()).items;

    // Last insert wins, URL is deduplicated
    expect(items).toEqual([
      {
        id: 2,
        title: "second",
        url: "https://google.com/",
        archive: false,
        created_at: expect.any(Number),
        favorite: false,
      },
    ]);
  });

  it("should deduplicate same URL in same request", async () => {
    await testInsert({
      insert: [
        // Also testing dedupe is after cleaning the url
        { title: "first", url: "https://google.com#123" },
        { title: "second", url: "https://google.com#456" },
      ],
      expectedSearchResult: [
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
      expectedSearchResult: [
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
      expectedSearchResult: [
        {
          id: 1,
          title: "asdf",
          url: "https://google.com/",
        },
      ],
    });
  });
});

describe("HTML title scraping via edit insert", () => {
  interface TestCase {
    title: string;
    document?: string;
    expected: string;
  }

  async function testInsert(tc: TestCase) {
    const doc =
      tc.document ??
      `<!doctype html><html><head><title>${tc.title}</title></head></html>`;

    fetchMock
      .get("https://google.com")
      .intercept({ path: "/", method: "get" })
      .reply(200, doc);

    const client = await createTestClient();

    const editResp = await client.api.edit.$post({
      json: {
        op: [{ op: "insert", title: "", url: "https://google.com" }],
      },
    });

    expect(editResp.status).toEqual(201);

    // Verify via search
    const search = await client.api.search.$get({
      query: { order: "id_asc" },
    });
    const items = (await search.json()).items;

    expect(items).toEqual([
      {
        id: 1,
        title: tc.expected,
        url: "https://google.com/",
        archive: false,
        created_at: expect.any(Number),
        favorite: false,
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

  it("should only use title in head", async () => {
    await testInsert({
      title: "",
      document: `<!doctype html><html><head><title>true title</title></head><body><title>No</title></body></html>`,
      expected: "true title",
    });
  });
});
