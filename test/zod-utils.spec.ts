import { describe, expect, it } from "vitest";
import * as zu from "../src/zod-utils";

describe("queryBool", () => {
  it("should parse simple values", () => {
    const schema = zu.queryBool();

    const truthy = ["true", "on", "ON", "TRUE"];
    const falsy = ["false", "off", "OFF"];

    for (const t of truthy) {
      expect(schema.safeDecode(t)).toEqual({
        success: true,
        data: true,
      });
    }

    for (const f of falsy) {
      expect(schema.safeDecode(f)).toEqual({
        success: true,
        data: false,
      });
    }
  });

  it("should treat empty string as undefined", () => {
    const schema = zu.queryBool();

    expect(schema.safeDecode("")).toEqual({
      success: true,
      data: undefined,
    });
  });
});
