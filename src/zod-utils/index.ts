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

export const queryBool = () =>
  z
    .literal(["", "1", "0", "true", "false"])
    .transform((val) => !(val === "false" || val === "0"));
