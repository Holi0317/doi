import * as z from "zod";
import dayjs from "dayjs";
import { genSessionID } from "./session/id";
import { useOauthStateStorage } from "./kv";

/**
 * Valid redirect destinations after authentication, in zod schema.
 */
export const RedirectDestinationSchema = z.enum([
  "/",
  "/basic",
  "/admin",
] as const);

export type RedirectDestination = z.output<typeof RedirectDestinationSchema>;

/**
 * Store OAuth state and redirect destination in KV.
 */
export async function storeOAuthState(
  env: CloudflareBindings,
  redirect: RedirectDestination,
) {
  // Reuse session ID generator for state token
  const state = genSessionID();

  const { write } = useOauthStateStorage(env);

  await write(state, redirect, dayjs().add(10, "minute"));

  return state;
}

/**
 * Retrieve and delete OAuth state redirect destination from KV.
 * Returns null if state is invalid or expired.
 */
export async function getAndDeleteOAuthState(
  env: CloudflareBindings,
  state: string,
): Promise<RedirectDestination | null> {
  const { read, remove } = useOauthStateStorage(env);

  const redirect = await read(state);

  if (!redirect) {
    return null;
  }

  // Delete the state after retrieval (one-time use)
  await remove(state);

  return redirect;
}
