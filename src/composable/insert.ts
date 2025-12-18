import type * as z from "zod";
import pLimit from "p-limit";
import { REQUEST_CONCURRENCY } from "../constants";
import type { InsertSchema, LinkInsertItem } from "../schemas";
import type { KyInstance } from "ky";
import { getHTMLTitle } from "./scraper";

/**
 * Process insert items to resolve their HTML titles
 *
 * Basically converts {@link InsertSchema} to {@link LinkInsertItem}
 */
export async function processInsert(
  ky: KyInstance,
  inserts: Array<z.output<typeof InsertSchema>>,
): Promise<LinkInsertItem[]> {
  const limit = pLimit(REQUEST_CONCURRENCY);

  return await limit.map(inserts, async (item) => {
    if (item.title) {
      return {
        title: item.title.substring(0, 512),
        url: item.url,
      };
    }

    const title = await getHTMLTitle(ky, item.url);

    return {
      title,
      url: item.url,
    };
  });
}
