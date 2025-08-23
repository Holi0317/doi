import { fetchMock } from "cloudflare:test";
import { describe, it, expect, beforeAll, afterEach } from "vitest";
import type { InferRequestType, InferResponseType } from "hono/client";
import type { ClientType } from "./client";
import { createTestClient } from "./client";

interface TestCase {
  edit: InferRequestType<ClientType["api"]["edit"]["$post"]>["json"]["op"];

  query: InferRequestType<ClientType["api"]["search"]["$get"]>["query"];

  search: InferResponseType<ClientType["api"]["search"]["$get"]>["items"];
}

async function testEdit(tc: TestCase) {
  const client = await createTestClient();

  const insert = await client.api.insert.$post({
    json: {
      items: [
        { url: "http://1.com", title: "1" },
        { url: "http://2.com", title: "2" },
        { url: "http://3.com", title: "3" },
      ],
    },
  });

  expect(insert.status).toEqual(201);

  const edit = await client.api.edit.$post({
    json: {
      op: tc.edit,
    },
  });

  expect(edit.status).toEqual(201);
  expect(await edit.text()).toEqual("");

  const search = await client.api.search.$get({
    query: tc.query,
  });

  expect(search.status).toEqual(200);
  const body = await search.json();
  expect(body.items).toEqual(tc.search);
}

describe("Link edit", () => {
  beforeAll(() => {
    fetchMock.activate();
    fetchMock.disableNetConnect();
  });

  afterEach(() => fetchMock.assertNoPendingInterceptors());

  it("should edit link properly", async () => {
    const client = await createTestClient();

    await testEdit({
      edit: [
        { op: "set", field: "archive", value: true, id: 1 },
        { op: "delete", id: 2 },
        { op: "set", field: "archive", value: true, id: 2 },
        { op: "set", field: "favorite", value: true, id: 1 },
      ],
      query: {
        order: "id_asc",
      },
      search: [
        {
          archive: true,
          created_at: expect.any(Number),
          favorite: true,
          id: 1,
          title: "1",
          url: "http://1.com/",
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
    });

    const search1 = await client.api.search.$get({
      query: {
        order: "id_asc",
        archive: "true",
      },
    });

    expect((await search1.json()).items).toEqual([
      {
        archive: true,
        created_at: expect.any(Number),
        favorite: true,
        id: 1,
        title: "1",
        url: "http://1.com/",
      },
    ]);

    const search2 = await client.api.search.$get({
      query: {
        order: "id_asc",
        archive: "false",
      },
    });

    expect((await search2.json()).items).toEqual([
      {
        archive: false,
        created_at: expect.any(Number),
        favorite: false,
        id: 3,
        title: "3",
        url: "http://3.com/",
      },
    ]);
  });

  it("should apply edit in sequence", async () => {
    await testEdit({
      edit: [
        { op: "set", field: "archive", value: true, id: 1 },
        { op: "set", field: "archive", value: true, id: 2 },
        { op: "set", field: "archive", value: false, id: 2 },
      ],
      query: {
        order: "id_asc",
      },
      search: [
        {
          archive: true,
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
    });
  });

  it("should not raise error for non-existing id", async () => {
    await testEdit({
      edit: [{ op: "set", field: "archive", value: true, id: 100 }],
      query: {
        order: "id_asc",
      },
      search: [
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
    });
  });
});
