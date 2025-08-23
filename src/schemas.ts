/**
 * Zod / API schema for CRUD API.
 *
 * Both hono and DurableObject needs to use this. Not sure where else to put
 * them so throwing all of them here for now.
 *
 * @module
 */

import * as z from "zod";
import * as zu from "./zod-utils";

/**
 * Query on searching API
 */
export const SearchQuerySchema = z.object({
  query: z
    .string()
    .nullish()
    .meta({
      description: `Search query. This will search both title and url.
      null / undefined / empty string will all be treated as disable search filter.`,
    }),
  cursor: z
    .string()
    .nullish()
    .meta({
      description: `Cursor for pagination.
      null / undefined / empty string will be treated as noop.
      Note the client must keep other search parameters the same when paginating.`,
    }),
  archive: zu.queryBool().optional().meta({
    description: `Archive filter. Undefined means disable filter. Boolean means the item must be archived or not archived.`,
  }),
  favorite: zu
    .queryBool()
    .optional()
    .meta({
      description: `Favorite filter.
      Undefined means disable filter. Boolean means the item must be favorited or not favorited.`,
    }),
  limit: z.coerce.number().min(1).max(300).default(30).meta({
    description: `Limit items to return.`,
  }),
  order: z
    .literal(["id_asc", "id_desc"])
    .default("id_desc")
    .meta({
      description: `Order in result. Can only sort by id.
      id correlates to created_at timestamp, so this sorting is effectively link insert time.`,
    }),
});

/**
 * JSON body for inserting links
 */
export const InsertBodySchema = z.object({
  items: z
    .array(
      z.object({
        title: z.string().nullish(),
        url: z
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

            return url.toString();
          }),
      }),
    )
    .min(1, { error: "At least must have an item" })
    .max(100, { error: "At most 100 items per request" }),
});

export const EditOpSchema = z.discriminatedUnion("op", [
  z.object({
    op: z.literal("set"),
    id: z.number(),
    field: z.literal(["archive", "favorite"]),
    value: z.boolean(),
  }),
  z.object({ op: z.literal("delete"), id: z.number() }),
]);

/**
 * JSON body for editing stored links
 */
export const EditBodySchema = z.object({
  op: z.array(EditOpSchema).min(1).max(100),
});
