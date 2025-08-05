import { DurableObject } from "cloudflare:workers";
import * as z from "zod";
import * as zu from "../zod-utils";
import { DBMigration, useDBMigration } from "../composable/db_migration";
import { sql, useSql } from "../composable/sql";
import { base64ToString } from "uint8array-extras";

const migrations: DBMigration[] = [
  {
    name: "20250610-create-link",
    script: sql`
CREATE TABLE link (
  id integer PRIMARY KEY AUTOINCREMENT,
  title text NOT NULL,
  url text NOT NULL UNIQUE
    CHECK (url like 'http://%' OR url like 'https://%'),
  favorite integer NOT NULL
    CHECK (favorite = 0 OR favorite = 1)
    DEFAULT FALSE,
  archive integer NOT NULL
    CHECK (archive = 0 OR archive = 1)
    DEFAULT FALSE,
  created_at integer NOT NULL DEFAULT (unixepoch('now'))
);

CREATE INDEX idx_link_favorite ON link(favorite);
CREATE INDEX idx_link_archive ON link(archive);
`,
  },
];

const LinkItemSchema = z.object({
  id: z.number(),
  title: z.string(),
  url: z.string(),
  favorite: zu.sqlBool(),
  archive: zu.sqlBool(),
  created_at: zu.sqlDate(),
});

export const LinkInsertSchema = z.object({
  title: z.string(),
  url: z.url({
    protocol: /^https?$/,
    hostname: z.regexes.domain,
    normalize: true,
  }),
});

export type LinkInsert = z.input<typeof LinkInsertSchema>;

const IDSchema = z.object({
  id: z.number(),
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

  public insert(link: LinkInsert) {
    const parsed = LinkInsertSchema.parse(link);

    return this.conn.one(
      IDSchema,
      sql`INSERT INTO link (title, url) VALUES (${parsed.title}, ${parsed.url})
  ON CONFLICT (url) DO UPDATE
  SET archive = FALSE,
    created_at = excluded.created_at,
    title = excluded.title
  RETURNING id;`,
    );
  }

  public search(param: SearchParam) {
    const query = param.query || "";
    const queryLike = `%${query}%`;

    // Empty string in base64 is also empty string. So cursor will remain empty
    // in those case.
    const cursor = base64ToString(param.cursor || "");

    return this.conn.any(
      LinkItemSchema,
      sql`SELECT *
  FROM link
  WHERE 1=1
    AND (${query} = '' OR title like ${queryLike} OR url like ${queryLike})
    AND (${param.archive ?? null} IS NULL OR ${param.archive} = link.archive)
    AND (${param.favorite ?? null} IS NULL OR ${param.favorite} = link.favorite)
    AND (${cursor} = '' OR ${cursor} ${param.order === "id_asc" ? sql.raw("<") : sql.raw(">")} link.id)
  ORDER BY id ${param.order === "id_asc" ? sql.raw("asc") : sql.raw("desc")}
  LIMIT ${param.limit}
      `,
    );
  }
}
