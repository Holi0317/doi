import { toUint8Array, uint8ArrayToHex } from "uint8array-extras";

/**
 * Generate session ID.
 *
 * This provides 128 bites (16 bytes) of entropy, which is considered secure
 * enough according to OWASP recommendation of 64 bits.
 * See https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html#session-id-entropy
 */
export function genSessionID() {
  return uint8ArrayToHex(crypto.getRandomValues(new Uint8Array(16)));
}

/**
 * Hash session ID.
 *
 * We only store hashed session ID in the kv, meanwhile client can hold the
 * session ID in cookie.
 *
 * Following recommendation from https://security.stackexchange.com/a/261773
 */
export async function hashSessionID(sessID: string) {
  const hash = await crypto.subtle.digest("SHA-256", Uint8Array.from(sessID));

  return uint8ArrayToHex(toUint8Array(hash));
}
