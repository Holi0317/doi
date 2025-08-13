import { describe, it, expect } from "vitest";
import { createTestClient } from "./client";

describe("Test client", () => {
  it("should get authenticated successfully", async () => {
    const client = await createTestClient();

    const response = await client.auth.$get();

    expect(response.status).toEqual(200);
    expect(await response.text()).toEqual("Hello <testing user>!");
  });
});
