import * as z from "zod";

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
