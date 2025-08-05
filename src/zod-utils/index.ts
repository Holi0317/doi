import * as z from "zod";

export const sqlBool = () => z.literal([0, 1]).transform((v) => !!v);

export const sqlDate = () =>
  z.number().transform((val) => new Date(val * 1000));
