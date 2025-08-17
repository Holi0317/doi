import { DurableObject } from "cloudflare:workers";
import * as z from "zod";
import * as zu from "../zod-utils";
import type { DBMigration } from "../composable/db_migration";
import { useDBMigration } from "../composable/db_migration";
import { sql, useSql } from "../composable/sql";
import { decodeCursor } from "../composable/cursor";

const migrations: DBMigration[] = [
  {
    // FIXME: Limit text size
    name: "20250610-create-link",
    script: sql`
CREATE TABLE link (
  -- ID/PK of the link. This relates to created_at column.
  -- On conflict of URL, we will replace (delete and insert) the row and bump ID.
  id integer PRIMARY KEY AUTOINCREMENT,

  -- Title of the link's HTML page.
  -- If title wasn't available, this will be the URL itself.
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

export interface SearchParam {
  /**
   * Search query. This will search both title and url.
   *
   * null / undefined / empty string will all be treated as disable search filter.
   */
  query?: string | null;

  /**
   * Cursor for pagination.
   *
   * null / undefined / empty string will be treated as noop.
   *
   * Note the client must keep search parameter the same when paginating.
   */
  cursor?: string | null;

  /**
   * Archive filter.
   *
   * Undefined means disable filter. Boolean means the item must be archived
   * or not arvhived.
   */
  archive?: boolean;

  /**
   * Favorite filter.
   *
   * Undefined means disable filter. Boolean means the item must be favorited
   * or not favorited.
   */
  favorite?: boolean;

  /**
   * Limit items to return.
   */
  limit: number;

  /**
   * Order in result. Can only sort by id.
   *
   * id correlates to created_at timestamp, so this sorting is effectively link
   * insert time.
   */
  order: "id_asc" | "id_desc";
}

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

    return this.conn.many(
      InsertedSchema,
      sql`SELECT id, url, title
FROM link
WHERE id IN ${sql.in(inserted.map((r) => r.id))}
ORDER BY id ASC;
    `,
    );
  }

  public search(param: SearchParam) {
    const query = param.query || "";
    const queryLike = `%${query}%`;

    const cursor = decodeCursor(param.cursor);

    const frag = sql`
  FROM link
  WHERE 1=1
    AND (${query} = '' OR title like ${queryLike} OR url like ${queryLike})
    AND (${param.archive ?? null} IS NULL OR ${param.archive} = link.archive)
    AND (${param.favorite ?? null} IS NULL OR ${param.favorite} = link.favorite)
`;

    const { count } = this.conn.one(
      CountSchema,
      sql`SELECT COUNT(*) AS count ${frag}`,
    );

    const items = this.conn.any(
      LinkItemSchema,
      sql`SELECT *
  ${frag}
  AND (${cursor} IS NULL OR ${cursor} ${param.order === "id_asc" ? sql.raw("<") : sql.raw(">")} link.id)
ORDER BY id ${param.order === "id_asc" ? sql.raw("asc") : sql.raw("desc")}
LIMIT ${param.limit}`,
    );

    return {
      count,
      items,
    };
  }
}
