/**
 * Cursor encoding and decoding.
 *
 * We only have a single type of cursor. So hard-coding the schema (id + created_at) here.
 *
 * @module
 */

import { base64ToString, stringToBase64 } from "uint8array-extras";
import * as z from "zod";
import * as zu from "../zod-utils";
import type { LinkItem } from "../schemas";

const CursorSchema = z.object({
  id: z.number().nonnegative(),
  created_at: zu.unixEpochMs(),
});

/**
 * Payload inside cursor.
 *
 * {@link LinkItem} should satisfies this interface. Creating a separate interface
 * just to make testing easier.
 */
export type CursorPayload = z.infer<typeof CursorSchema>;

/**
 * Encode given {@link CursorPayload} or {@link LinkItem} into cursor.
 *
 * This should be the plus one item after the last item in previous page.
 * Next page should start from this item (inclusive).
 */
export function encodeCursor(link: CursorPayload | LinkItem): string {
  const payload: CursorPayload = {
    id: link.id,
    created_at: link.created_at,
  };

  return stringToBase64(JSON.stringify(payload));
}

/**
 * Decode given cursor back to ID.
 *
 * If the cursor is falsy, this will return null.
 * If the cursor isn't a number, this will return null
 *
 * @returns Decoded cursor object, or null if input is null or malformed
 */
export function decodeCursor(
  cursor: string | null | undefined,
): CursorPayload | null {
  // Empty string in base64 is also empty string. We can handle all falsy cases
  // with a single fallback value.
  const str = base64ToString(cursor || "");

  if (!str) {
    return null;
  }

  try {
    return CursorSchema.parse(JSON.parse(str));
  } catch {
    console.warn(`Malformed cursor ${cursor}, decoding got ${str}`);

    return null;
  }
}
