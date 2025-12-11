import * as z from "zod";
import dayjs from "dayjs";
import { genSessionID } from "./session/id";
import { useKv } from "./kv";

/**
 * Valid redirect destinations after authentication, in zod schema.
 */
export const RedirectDestinationSchema = z.enum([
  "/",
  "/basic",
  "/admin",
  "doi:",
] as const);

export type RedirectDestination = z.output<typeof RedirectDestinationSchema>;

/**
 * OAuth state schema for KV storage.
 */
export const OauthStateSchema = z.object({
  redirect: RedirectDestinationSchema,
});

function useOauthStateStorage(env: CloudflareBindings) {
  return useKv(env.KV, "oauth_state", OauthStateSchema, z.undefined());
}

export function useOauthState(env: CloudflareBindings) {
  const { read, write, remove } = useOauthStateStorage(env);

  /**
   * Store OAuth state and redirect destination in KV.
   */
  const store = async (redirect: RedirectDestination) => {
    // Reuse session ID generator for state token
    const state = genSessionID();

    await write({
      key: state,
      content: { redirect },
      expire: dayjs().add(10, "minute"),
    });

    return state;
  };

  /**
   * Retrieve and delete OAuth state redirect destination from KV.
   * Returns null if state is invalid or expired.
   */
  const getAndDelete = async (state: string) => {
    const redirect = await read(state);

    if (!redirect) {
      return null;
    }

    // Delete the state after retrieval (one-time use)
    await remove(state);

    return redirect;
  };

  return {
    store,
    getAndDelete,
  };
}
