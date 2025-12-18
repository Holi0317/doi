import * as z from "zod";

export const sqlBool = () => z.literal([0, 1]).transform((v) => !!v);
