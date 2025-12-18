import * as z from "zod";

/**
 * Unix epoch in millisecond.
 *
 * The minimum representable date is around 2001-09-09. Our app is written in
 * 2025 so it should be fine.
 */
export const unixEpochMs = () =>
  z.number().int().positive().gt(1e12, {
    error:
      "Timestamp looks small. Did you pass in epoch in seconds instead of milliseconds?",
  });

/**
 * Unix epoch in second.
 *
 * The maximum representable date is around year 2286. Should not hit this limit anytime soon (literally).
 *
 * Transforms seconds to milliseconds as our JS and our app uses milliseconds internally.
 */
export const unixEpochSec = () =>
  z
    .number()
    .int()
    .positive()
    .lt(1e10, {
      error:
        "Timestamp looks large. Did you pass in epoch in milliseconds instead of seconds?",
    })
    .transform((sec) => sec * 1000);
