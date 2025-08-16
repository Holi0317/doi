import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import type { InferRequestType, InferResponseType } from "hono/client";
import { encodeCursor } from "../src/composable/cursor";
import type { ClientType } from "./client";
import { createTestClient } from "./client";

interface TestCase {
  insert: InferRequestType<
    ClientType["api"]["insert"]["$post"]
  >["json"]["items"];

  search: InferRequestType<ClientType["api"]["search"]["$get"]>["query"];

  resp: InferResponseType<ClientType["api"]["search"]["$get"]>;
}

async function testInsert(tc: TestCase) {
  const client = await createTestClient();

  if (tc.insert.length > 0) {
    const insert = await client.api.insert.$post({
      json: {
        items: tc.insert,
      },
    });

    expect(insert.status).toEqual(201);
  }

  const search = await client.api.search.$get({
    query: tc.search,
  });

  expect(search.status).toEqual(200);
  expect(await search.json()).toEqual(tc.resp);
}

describe("Link search", () => {
  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should return nothing on empty db", async () => {
    await testInsert({
      insert: [],
      search: {},
      resp: {
        count: 0,
        cursor: null,
        items: [],
      },
    });
  });

  it("should list result", async () => {
    await testInsert({
      insert: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
      search: {},
      resp: {
        count: 3,
        cursor: encodeCursor(1),
        items: [
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 3,
            title: "3",
            url: "http://3.com/",
          },
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 2,
            title: "2",
            url: "http://2.com/",
          },
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 1,
            title: "1",
            url: "http://1.com/",
          },
        ],
      },
    });
  });

  it("should return empty if search query doesn't match anything", async () => {
    await testInsert({
      insert: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
      search: {
        query: "foo",
      },
      resp: {
        count: 0,
        cursor: null,
        items: [],
      },
    });
  });

  it("sorting should work", async () => {
    await testInsert({
      insert: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
      search: {
        order: "id_asc",
      },
      resp: {
        count: 3,
        cursor: encodeCursor(3),
        items: [
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 1,
            title: "1",
            url: "http://1.com/",
          },
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 2,
            title: "2",
            url: "http://2.com/",
          },
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 3,
            title: "3",
            url: "http://3.com/",
          },
        ],
      },
    });
  });

  it("limit and cursor should work", async () => {
    await testInsert({
      insert: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
      search: {
        limit: "1",
        cursor: encodeCursor(1),
        order: "id_asc",
      },
      resp: {
        count: 3,
        cursor: encodeCursor(2),
        items: [
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 2,
            title: "2",
            url: "http://2.com/",
          },
        ],
      },
    });
  });

  it("should ignore cursor if it's invalid", async () => {
    await testInsert({
      insert: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
      search: {
        limit: "1",
        cursor: "asdf",
      },
      resp: {
        count: 3,
        cursor: encodeCursor(3),
        items: [
          {
            archive: false,
            created_at: expect.any(Number),
            favorite: false,
            id: 3,
            title: "3",
            url: "http://3.com/",
          },
        ],
      },
    });
  });
});
