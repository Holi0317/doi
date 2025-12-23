import type { ClientRequestOptions } from "hono/client";
import { hc } from "hono/client";
import type { AppType } from "../router";

/**
 * Typescript type for the worker app router.
 */
export type { AppType };

/**
 * Type for hono client. For type inference with InferRequestType and InferResponseType.
 */
export type ClientType = ReturnType<typeof createClient>;

/**
 * Create a Hono client for the worker app.
 *
 * Basically a wrapper around {@link hc} from `hono/client`.
 */
export function createClient<Prefix extends string = string>(
  baseUrl: Prefix,
  options?: ClientRequestOptions,
) {
  return hc<AppType>(baseUrl, options);
}
