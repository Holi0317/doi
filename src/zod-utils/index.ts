import * as z from "zod";

export const sqlBool = () => z.literal([0, 1]).transform((v) => !!v);

/**
 * Unix epoch in millisecond.
 *
 * The minimum representable date is around 2001-09-09. Our app is written in
 * 2025 so it should be fine.
 */
export const unixEpochMs = () =>
  z.number().gt(1e12, {
    error:
      "Timestamp looks small. Did you pass in epoch in seconds instead of milliseconds?",
  });

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

/**
 * Type for boolean in query parameter. Input data type has to be a string or
 * undefined.
 *
 * Input matching is case insensitive.
 *
 * `true`, `1`, `on` (for input checkbox) will be considered as true
 * `false`, `0`, `off` will be considered as false
 * empty string will get undefined. This is meant for `<select>` element where
 * it will use empty string for empty value.
 */
export function queryBool() {
  const truthy = new Set(["true", "1", "on"]);
  const falsy = new Set(["false", "0", "off"]);

  // Writing our own codec instead of z.stringbool because we need to support
  // empty string as optional case.
  return z.codec(z.string().optional(), z.boolean().optional(), {
    decode(value, payload) {
      if (value == null) {
        return value;
      }

      value = value.toLowerCase();

      if (value === "") {
        return undefined;
      }

      if (truthy.has(value)) {
        return true;
      }

      if (falsy.has(value)) {
        return false;
      }

      payload.issues.push({
        code: "invalid_value",
        expected: "stringbool",
        values: [...truthy, ...falsy],
        input: payload.value,
        continue: false,
      });

      return {} as never;
    },
    encode(value) {
      if (value === true) {
        return "true";
      }
      if (value === false) {
        return "false";
      }
    },
  });
}
