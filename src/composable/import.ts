import * as z from "zod";
import { parse } from "@std/csv";
import { useKv } from "./kv";
import { uidToString, type UserIdentifier } from "./user/ident";
import { InsertSchema } from "../schemas";
import { MAX_EDIT_OPS } from "../constants";
import { genSessionID } from "./session/id";
import dayjs from "dayjs";
import { chunk } from "es-toolkit/array";

const RawMetaSchema = z.object({
  uid: z.string(),
});

function useRawStore(env: CloudflareBindings) {
  return useKv(env.KV, "import:raw", z.string(), RawMetaSchema);
}

export const PartSchema = z.object({
  items: z.array(InsertSchema),
});

function usePartStore(env: CloudflareBindings) {
  return useKv(env.KV, "import:part", PartSchema, z.undefined());
}

export function useImportStore(env: CloudflareBindings) {
  const raw = useRawStore(env);
  const part = usePartStore(env);

  /**
   * Write raw import content (string/file) to KV store
   *
   * @returns ID for the raw content
   */
  const writeRaw = async (uid: UserIdentifier, content: string) => {
    const id = genSessionID();

    await raw.write({
      key: id,
      content,
      expire: dayjs().add(1, "day"),
      metadata: {
        uid: uidToString(uid),
      },
    });

    return id;
  };

  // TODO: Add different file parsers
  const parseFile = (body: string) => {
    const csv = parse(body, {
      skipFirstRow: true,
    });

    const result: Array<z.output<typeof InsertSchema>> = [];

    for (const row of csv) {
      const parsed = InsertSchema.safeParse(row);
      if (!parsed.success) {
        console.warn(
          `Skipping invalid row in import file: ${z.prettifyError(parsed.error)}`,
        );
        continue;
      }

      result.push(parsed.data);
    }

    return result;
  };

  /**
   * Parse and partition the import file into parts.
   * Each part should contain up to 30 items, aligning with edit API limit.
   *
   * @return list of part identifiers (number ID)
   */
  const partition = async (uid: UserIdentifier, rawId: string) => {
    const uidStr = uidToString(uid);

    const body = await raw.read(rawId);
    if (body == null) {
      throw new Error(`Raw import data ${rawId} not found`);
    }

    // Parse file content
    const items = parseFile(body);

    // Partition items into chunks of MAX_EDIT_OPS
    const parts: number[] = [];
    let partId = 0;

    for (const c of chunk(items, MAX_EDIT_OPS)) {
      await part.write({
        key: `${uidStr}:${partId}`,
        content: {
          items: c,
        },
      });

      parts.push(partId);
      partId++;
    }

    return parts;
  };

  /**
   * Read a specific part of import data for given user
   */
  const readPart = async (uid: UserIdentifier, partId: number) => {
    const uidStr = uidToString(uid);
    const data = await part.read(`${uidStr}:${partId}`);
    if (data == null) {
      throw new Error(`Import part ${partId} not found`);
    }

    return data;
  };

  /**
   * Delete raw import data from KV store
   *
   * @param id ID of the raw import data
   */
  const clearRaw = async (id: string) => {
    await raw.remove(id);
  };

  /**
   * Delete import data in part store for given user
   */
  const clearPart = async (uid: UserIdentifier) => {
    const uidStr = uidToString(uid);

    // Delete all parts
    const allKeys = await part.listAll(`${uidStr}:`);

    await Promise.all(allKeys.map((key) => part.remove(key.name)));
  };

  return {
    writeRaw,
    partition,
    readPart,
    clearRaw,
    clearPart,
  };
}
