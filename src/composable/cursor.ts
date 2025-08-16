import { base64ToString, stringToBase64 } from "uint8array-extras";

/**
 * Encode given ID into cursor
 */
export function encodeCursor(id: number): string {
  return stringToBase64(id.toString());
}

/**
 * Decode given cursor back to ID.
 *
 * If the cursor is falsy, this will return null.
 * If the cursor isn't a number, this will return null
 */
export function decodeCursor(cursor: string | null | undefined): number | null {
  // Empty string in base64 is also empty string. We can handle all falsy cases
  // with a single fallback value.
  const str = base64ToString(cursor || "");

  if (!str) {
    return null;
  }

  try {
    return parseInt(str, 10);
  } catch {
    console.warn(`Malformed cursor ${cursor}, decoding got ${str}`);

    return null;
  }
}
