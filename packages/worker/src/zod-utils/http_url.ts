import * as z from "zod";

const trackingParams = new Set([
  // UTM / Google Analytics
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_term",
  "utm_content",
  // Youtube
  "si",
  // Instagram
  "igshid",
]);

const collator = new Intl.Collator(undefined, {
  numeric: true,
  sensitivity: "base",
});

/**
 * URL validation that only allows http or https protocols.
 *
 * This also does some cleaning on the URL. Namely:
 * - Normalize the URL using `URL` constructor (something like adding tailing slash)
 * - Remove URL hash (`#` part)
 * - Remove authentication info (username / password)
 * - Remove known tracking parameters from the URL search params
 * - Sort the remaining search parameters alphabetically by key
 */
export function httpUrl() {
  return z
    .url({
      protocol: /^https?$/,
      hostname: z.regexes.domain,
      normalize: true,
    })
    .transform((val) => {
      const url = new URL(val);

      url.hash = "";
      url.username = "";
      url.password = "";

      const params = new URLSearchParams(
        Iterator.from(url.searchParams)
          .filter(([key]) => !trackingParams.has(key))
          .toArray()
          .sort(([a], [b]) => {
            return collator.compare(a, b);
          }),
      );
      url.search = params.toString();

      return url.toString();
    });
}
