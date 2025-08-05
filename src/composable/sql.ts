import * as z from "zod";
import { sql as _sql, SqlQuery } from "@truto/sqlite-builder";

export const sql = _sql;

export function useSql(ctx: DurableObjectState) {
  /**
   * Return result rows
   */
  const any = <T extends z.ZodObject>(schema: T, query: SqlQuery) => {
    const cursor = ctx.storage.sql.exec(query.text, ...query.values);

    return Iterator.from(cursor)
      .map((item) => schema.parse(item))
      .toArray();
  };

  /**
   * Returns result rows.
   *
   * @throws {NotFoundError} if query returns no rows
   */
  const many = <T extends z.ZodObject>(schema: T, query: SqlQuery) => {
    const items = any(schema, query);
    if (items.length === 0) {
      throw new NotFoundError("Query returned no rows.", query);
    }

    return items;
  };

  /**
   * Selects the first row from the result.
   *
   * @returns null if row is not found, or the result record
   * @throws {DataIntegrityError} if query returns multiple rows
   */
  const maybeOne = <T extends z.ZodObject>(schema: T, query: SqlQuery) => {
    const cursor = ctx.storage.sql.exec(query.text, ...query.values);

    const first = cursor.next();
    if (first.value == null) {
      return null;
    }

    const second = cursor.next();
    if (second.value != null) {
      throw new DataIntegrityError("Query returned multiple rows.", query);
    }

    return schema.parse(first.value);
  };

  /**
   * Selects the first row from the result.
   *
   * @throws {NotFoundError} if query returns no rows
   * @throws {DataIntegrityError} if query returns multiple rows
   */
  const one = <T extends z.ZodObject>(schema: T, query: SqlQuery) => {
    const record = maybeOne(schema, query);
    if (record == null) {
      throw new NotFoundError("Query returned no rows.", query);
    }

    return record;
  };

  /**
   * Execute statement and expect no rows. For non-SELECT statements.
   *
   * @throws {DataIntegrityError} if query returns some row
   */
  const void_ = (query: SqlQuery) => {
    const cursor = ctx.storage.sql.exec(query.text, ...query.values);

    const first = cursor.next();

    if (!first.done) {
      throw new DataIntegrityError("Query returned some rows.", query);
    }

    return;
  };

  // To make sure `this` is bound correctly here.
  const transaction = <T>(closure: () => T): T => {
    return ctx.storage.transactionSync(closure);
  };

  return {
    any,
    many,
    maybeOne,
    one,
    void_,
    transaction,
  };
}

export class SqlError extends Error {}

export class DataIntegrityError extends SqlError {
  readonly text: string;
  readonly values: readonly unknown[];

  public constructor(message: string, query: SqlQuery) {
    super(message);

    this.text = query.text;
    this.values = query.values;
  }
}

export class NotFoundError extends SqlError {
  readonly text: string;
  readonly values: readonly unknown[];

  public constructor(message: string, query: SqlQuery) {
    super(message);

    this.text = query.text;
    this.values = query.values;
  }
}
