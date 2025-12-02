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
 * Simple id coerce into a number schema.
 */
export const IDStringSchema = z.object({
  id: z.coerce.number(),
});

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
  archive: zu.queryBool().meta({
    description: `Archive filter. Undefined means disable filter. Boolean means the item must be archived or not archived.`,
  }),
  favorite: zu.queryBool().meta({
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
        url: zu.httpUrl(),
      }),
    )
    .min(1, { error: "At least must have an item" })
    // See https://developers.cloudflare.com/workers/platform/limits/
    // Free worker can only have at most 50 subrequests. This counts other
    // feature like session management before fetching title from url.
    // Choosing 30 here so we are not gonna blow through the subrequests limit.
    //
    // If you are using workers paid and needs to bump this limit, open an issue.
    // I'll figure out how to make this limit dynamic base on actual limit in runtime.
    .max(30, { error: "At most 30 items per request" }),
});

export const EditOpSchema = z.discriminatedUnion("op", [
  z.object({
    op: z.literal("set_bool"),
    id: z.number(),
    field: z.literal(["archive", "favorite"]),
    value: z.boolean(),
  }),
  z.object({
    op: z.literal("set_string"),
    id: z.number(),
    field: z.literal(["note"]),
    value: z.string(),
  }),
  z.object({ op: z.literal("delete"), id: z.number() }),
]);

/**
 * JSON body for editing stored links
 */
export const EditBodySchema = z.object({
  op: z.array(EditOpSchema).min(1).max(100),
});

/**
 * Query parameters for image preview endpoint
 */
export const ImageQuerySchema = z.object({
  url: zu.httpUrl(),
  type: z.enum(["social", "favicon"]).default("social").meta({
    description: `Type of image to fetch. 'social' fetches og:image/twitter:image, 'favicon' fetches site favicon.`,
  }),
  dpr: z.coerce.number().positive().optional(),
  width: z.coerce.number().positive().optional(),
  height: z.coerce.number().positive().optional(),
});
