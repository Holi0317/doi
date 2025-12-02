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
 * Edit operations that only modify existing links (no insert).
 * Used internally by the storage layer.
 */
export const ModifyOpSchema = z.discriminatedUnion("op", [
  z.object({
    op: z.literal("set"),
    id: z.number(),
    field: z.literal(["archive", "favorite"]),
    value: z.boolean(),
  }),
  z.object({ op: z.literal("delete"), id: z.number() }),
]);

export const EditOpSchema = z.discriminatedUnion("op", [
  z.object({
    op: z.literal("set"),
    id: z.number(),
    field: z.literal(["archive", "favorite"]),
    value: z.boolean(),
  }),
  z.object({ op: z.literal("delete"), id: z.number() }),
  z.object({
    op: z.literal("insert"),
    title: z.string().nullish(),
    url: zu.httpUrl(),
  }),
]);

/**
 * JSON body for editing stored links.
 *
 * Note the limit is 30 to keep it compatible with Cloudflare Workers free tier
 * subrequest limit. Insert operations may trigger title fetching which counts
 * as subrequests.
 *
 * @see https://developers.cloudflare.com/workers/platform/limits/
 */
export const EditBodySchema = z.object({
  op: z.array(EditOpSchema).min(1).max(30),
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
