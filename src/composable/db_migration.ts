import * as z from "zod";
import { sql, useSql } from "./sql";
import type { SqlQuery } from "@truto/sqlite-builder";

const MigrationNameSchema = z.object({
  name: z.string(),
});

export interface DBMigration {
  name: string;
  script: SqlQuery;
}

export function useDBMigration(ctx: DurableObjectState) {
  const conn = useSql(ctx);

  const init = () => {
    console.log("Creating schema_migration table if not exist");

    conn.void_(sql`CREATE TABLE IF NOT EXISTS schema_migration (
  name text PRIMARY KEY,
  created_at integer NOT NULL DEFAULT (unixepoch('now'))
);`);
  };

  const listMigrations = () => {
    const migrations = conn.any(
      MigrationNameSchema,
      sql`SELECT name FROM schema_migration;`,
    );

    const set = new Set(migrations.map((m) => m.name));

    console.log("Ran migrations", set);

    return set;
  };

  /**
   * Run given database migrations.
   *
   * Migrations will run in order. Place newer migrations to the end of the
   * array.
   *
   * Each migration script will run in their own transaction. However because we
   * are using `blockConcurrencyWhile` in the migration run part, any failed
   * migration will actually rollback the whole Durable object state.
   *
   * Name is for book keeping purpose and should be unique.
   *
   * We don't check for deleted migration in the provided array. Just don't
   * shoot yourself in the foot?
   *
   * @param migrations Array of migrations, old to new, to run on the durable
   * object SQLite store.
   * @returns Promise for running the migration. It's actually safe to ignore the
   * promise and call this function in durable object constructor.
   * See https://developers.cloudflare.com/durable-objects/api/state/#blockconcurrencywhile
   */
  const run = async (migrations: DBMigration[]) => {
    const migrationMap = new Map(migrations.map((m) => [m.name, m.script]));
    if (migrationMap.size !== migrations.length) {
      throw new Error("Duplicate name in DBMigration");
    }

    await ctx.blockConcurrencyWhile(async () => {
      init();

      const ran = listMigrations();

      for (const migration of migrations) {
        if (ran.has(migration.name)) {
          continue;
        }

        conn.transaction(() => {
          console.log(`Running migration ${migration.name}`);

          conn.void_(migration.script);

          conn.void_(
            sql`INSERT INTO schema_migration(name) VALUES (${migration.name})`,
          );

          console.log(`Migration ${migration.name} complete`);
        });
      }
    });
  };

  return {
    run,
  };
}
