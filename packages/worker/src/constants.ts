/**
 * Maximum number of edit operations allowed in a single edit request.
 *
 * Free worker can only have at most 50 subrequests. This counts other
 * feature like session management before fetching title from url.
 *
 * This affects only insert operations where we might need to fetch (subrequest)
 * the title from the URL. Other operations are just simple DB edits and only
 * contribute to +1 subrequest limits.
 *
 * Choosing 30 here so we are not gonna blow through the subrequests limit.
 * See https://developers.cloudflare.com/workers/platform/limits/
 *
 * If you are using workers paid and needs to bump this limit, open an issue.
 * I'll figure out how to make this limit dynamic base on actual limit in runtime.
 */
export const MAX_EDIT_OPS = 30;

/**
 * Limit on simultaneous open connections.
 *
 * See https://developers.cloudflare.com/workers/platform/limits/
 *
 * While worker runtime will do concurrency limit for us, limiting on
 * application side should be more efficient.
 *
 * Most likely to pass this number into p-limit.
 */
export const REQUEST_CONCURRENCY = 6;

/**
 * Maximum body size for incoming request. Unit is in bytes.
 *
 * Worker limits requests to maximum 100MB size for free plan.
 * See https://developers.cloudflare.com/workers/platform/limits/#request-limits
 *
 * Most endpoints won't hit this limit (or rather, would ran out of CPU time before hitting this limit).
 * Main concern is for import endpoints where we write the request body into KV storage.
 *
 * Size limit for KV is 25MB.
 * See https://developers.cloudflare.com/kv/platform/limits/
 *
 * Setting this to 20MB which should be enough for most imports.
 */
export const MAX_BODY_SIZE = 20 * 1024 * 1024;
