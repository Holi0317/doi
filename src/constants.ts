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
