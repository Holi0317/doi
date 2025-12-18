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
import { MAX_EDIT_OPS } from "./constants";

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
  archive: z.boolean().default(false),
  favorite: z.boolean().default(false),
  note: z.string().max(4096).default(""),
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
 * JSON body for editing stored links or inserting new items
 */
export const EditBodySchema = z.object({
  op: z
    .array(EditOpSchema)
    .min(1, { error: "At least one operation is required" })
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

/**
 * Schema for link item stored in database.
 */
export const LinkItemSchema = z.strictObject({
  id: z.number(),
  title: z.string(),
  url: z.string(),
  favorite: zu.sqlBool(),
  archive: zu.sqlBool(),
  created_at: zu.unixEpochMs(),
  note: z.string(),
});

/**
 * Type for link item stored in database.
 */
export type LinkItem = z.output<typeof LinkItemSchema>;
