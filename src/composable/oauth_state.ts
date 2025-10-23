import * as z from "zod";
import { genSessionID } from "./session/id";

/**
 * Valid redirect destinations after authentication.
 */
export const REDIRECT_DESTINATIONS = ["/", "/basic", "/admin"] as const;

export type REDIRECT_DESTINATIONS = (typeof REDIRECT_DESTINATIONS)[number];

/**
 * Zod schema for {@link REDIRECT_DESTINATIONS}.
 */
export const redirectDestinationSchema = z.enum(REDIRECT_DESTINATIONS);

/**
 * Store OAuth state and redirect destination in KV.
 */
export async function storeOAuthState(
  env: CloudflareBindings,
  redirect: REDIRECT_DESTINATIONS,
) {
  // Reuse session ID generator for state token
  const state = genSessionID();

  await env.OAUTH_STATE.put(state, redirect, {
    expirationTtl: 600, // 10 minutes
  });

  return state;
}

/**
 * Retrieve and delete OAuth state redirect destination from KV.
 * Returns null if state is invalid or expired.
 */
export async function getAndDeleteOAuthState(
  env: CloudflareBindings,
  state: string,
): Promise<REDIRECT_DESTINATIONS | null> {
  const redirect = await env.OAUTH_STATE.get(state);

  if (!redirect) {
    return null;
  }

  // Delete the state after retrieval (one-time use)
  await env.OAUTH_STATE.delete(state);

  // Validate the redirect is in our whitelist using Zod
  const validationResult = redirectDestinationSchema.safeParse(redirect);
  if (!validationResult.success) {
    return null;
  }

  return validationResult.data;
}
