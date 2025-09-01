import { DurableObject } from "cloudflare:workers";
import * as z from "zod";
import * as zu from "../zod-utils";
import type { DBMigration } from "../composable/db_migration";
import { useDBMigration } from "../composable/db_migration";
import { sql, useSql } from "../composable/sql";
import { decodeCursor } from "../composable/cursor";
import type { EditBodySchema, SearchQuerySchema } from "../schemas";

const migrations: DBMigration[] = [
  {
    name: "20250610-create-link",
    script: sql`
CREATE TABLE link (
  -- ID/PK of the link. This relates to created_at column.
  -- On conflict of URL, we will replace (delete and insert) the row and bump ID.
  id integer PRIMARY KEY AUTOINCREMENT,

  -- Title of the link's HTML page.
  -- If title wasn't available, this will empty string.
  -- WARNING: Title can be used for XSS. Remember to escape before rendering
  title text NOT NULL CHECK (length(title) < 100),
  -- URL of the link.
  url text NOT NULL UNIQUE
    CHECK (url like 'http://%' OR url like 'https://%')
    CHECK (length(url) < 512),
  -- Boolean. Favorite or not.
  favorite integer NOT NULL
    CHECK (favorite = 0 OR favorite = 1)
    DEFAULT FALSE,
  -- Boolean. Archived or not.
  archive integer NOT NULL
    CHECK (archive = 0 OR archive = 1)
    DEFAULT FALSE,
  -- Insert timestamp in epoch milliseconds.
  created_at integer NOT NULL DEFAULT (unixepoch('now', 'subsec') * 1000)
);

CREATE INDEX idx_link_favorite ON link(favorite);
CREATE INDEX idx_link_archive ON link(archive);
`,
  },
];

const LinkItemSchema = z.strictObject({
  id: z.number(),
  title: z.string(),
  url: z.string(),
  favorite: zu.sqlBool(),
  archive: zu.sqlBool(),
  created_at: zu.unixEpochMs(),
});

export type LinkItem = z.output<typeof LinkItemSchema>;

export interface LinkInsertItem {
  title: string;
  url: string;
}

const IDSchema = z.strictObject({
  id: z.number(),
});

const CountSchema = z.strictObject({
  count: z.number(),
});

const InsertedSchema = z.strictObject({
  id: z.number(),
  url: z.string(),
  title: z.string(),
});

export class StorageDO extends DurableObject<CloudflareBindings> {
  private readonly conn: ReturnType<typeof useSql>;

  public constructor(ctx: DurableObjectState, env: CloudflareBindings) {
    super(ctx, env);
    this.conn = useSql(ctx);

    const { run } = useDBMigration(ctx);
    run(migrations);
  }

  /**
   * Insert given links to database
   */
  public insert(links: LinkInsertItem[]) {
    const inserted: Array<z.infer<typeof IDSchema>> = [];

    for (const link of links) {
      const item = this.conn.one(
        IDSchema,
        sql`INSERT OR REPLACE INTO link (title, url) VALUES (${link.title}, ${link.url})
  RETURNING id;`,
      );

      inserted.push(item);
    }

    // If user is trying to insert the same URL in the same transaction, some ID
    // will get replaced.
    //
    // The only reliable way to purge invalid ID in the same transaction is to
    // use query inserted entities.

    // FIXME: Return per-url insert result back to client. Need some way to
    // indicate there was a duplication/replacement on insert process.

    return this.conn.many(
      InsertedSchema,
      sql`SELECT id, url, title
FROM link
WHERE id IN ${sql.in(inserted.map((r) => r.id))}
ORDER BY id ASC;
    `,
    );
  }

  public edit(param: z.output<typeof EditBodySchema>) {
    for (const op of param.op) {
      switch (op.op) {
        case "set": {
          const column =
            op.field === "archive"
              ? sql.ident("archive")
              : sql.ident("favorite");
          this.conn.void_(
            sql`UPDATE link SET ${column} = ${Number(op.value)} WHERE id = ${op.id}`,
          );
          break;
        }
        case "delete":
          this.conn.void_(sql`DELETE FROM link WHERE id = ${op.id}`);
          break;
      }
    }
  }

  public get(id: number) {
    return this.conn.maybeOne(
      LinkItemSchema,
      sql`SELECT * FROM link WHERE id = ${id}`,
    );
  }

  public search(param: z.output<typeof SearchQuerySchema>) {
    const query = param.query || "";
    const queryLike = `%${query}%`;

    const cursor = decodeCursor(param.cursor);

    const frag = sql`
  FROM link
  WHERE 1=1
    AND (${query} = '' OR title like ${queryLike} OR url like ${queryLike})
    AND (${param.archive ?? null} IS NULL OR ${Number(param.archive)} = link.archive)
    AND (${param.favorite ?? null} IS NULL OR ${Number(param.favorite)} = link.favorite)
`;

    const { count } = this.conn.one(
      CountSchema,
      sql`SELECT COUNT(*) AS count ${frag}`,
    );

    const itemsPlus = this.conn.any(
      LinkItemSchema,
      sql`SELECT *
  ${frag}
  AND (${cursor} IS NULL OR ${cursor} ${param.order === "id_asc" ? sql.raw("<") : sql.raw(">")} link.id)
ORDER BY id ${param.order === "id_asc" ? sql.raw("asc") : sql.raw("desc")}
LIMIT ${param.limit + 1}`,
    );

    const items = itemsPlus.slice(0, param.limit);
    const hasMore = itemsPlus.length > param.limit;

    return {
      /**
       * Total number of items satisfying the filter, exclude pagination.
       */
      count,
      /**
       * Paginated items matching the filter. Length of this array will be <=
       * limit parameter.
       */
      items,
      /**
       * If true, this query can continue paginate.
       */
      hasMore,
    };
  }
}
