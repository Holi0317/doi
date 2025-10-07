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
