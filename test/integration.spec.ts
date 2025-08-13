import { SELF, fetchMock } from "cloudflare:test";
import { describe, it, expect, vi } from "vitest";
import dayjs from "dayjs";
import { createTestClient } from "./client";

describe("Integration test", () => {
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
    fetchMock.disableNetConnect();

    const client = await createTestClient();

    const date = dayjs.unix(1318781876);
    vi.setSystemTime(date.toDate());

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
});
