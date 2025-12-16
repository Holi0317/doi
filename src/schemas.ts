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
 * Schema for insert object from client.
 *
 * Client actually ships this inside EditOpSchema. However in worker code
 * we handle insert separately and having a separate type makes it easier for
 * reference.
 */
export const InsertSchema = z.object({
  title: z.string().nullish(),
  url: zu.httpUrl(),
});

/**
 * Link to be inserted.
 *
 * This is basically InsertSchema. However the title needs to be resolved and present.
 * Use `processInsert` to convert from InsertSchema to this type.
 */
export type LinkInsertItem = Omit<z.output<typeof InsertSchema>, "title"> & {
  title: string;
};

/**
 * A single edit operation for stored links.
 */
export const EditOpSchema = z.discriminatedUnion("op", [
  z.object({
    op: z.literal("insert"),
    ...InsertSchema.shape,
  }),
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
 * Maximum number of edit operations allowed in a single edit request.
 *
 * Free worker can only have at most 50 subrequests. This counts other
 * feature like session management before fetching title from url.
 *
 * This affects only insert operations where we might need to fetch (subrequest)
 * the title from the URL. Other operations are just simple DB edits and only
 * contribute to +1 subrequest limits.
 *
 * Choosing 30 here so we are not gonna blow through the subrequests limit.
 * See https://developers.cloudflare.com/workers/platform/limits/
 *
 * If you are using workers paid and needs to bump this limit, open an issue.
 * I'll figure out how to make this limit dynamic base on actual limit in runtime.
 */
export const MAX_EDIT_OPS = 30;

/**
 * JSON body for editing stored links or inserting new items
 */
export const EditBodySchema = z.object({
  op: z
    .array(EditOpSchema)
    .min(1, { error: "At least must at lease one operation" })
    .max(MAX_EDIT_OPS, {
      error: `At most ${MAX_EDIT_OPS} operations per request`,
    }),
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
