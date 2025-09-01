import type { Context } from "hono";
import ky from "ky";

export function useKy(c: Context<Env>) {
  const version = c.env.CF_VERSION_METADATA;

  return ky.create({
    headers: {
      "user-agent": `doi-app/${version.id || "unknown"}/${version.tag || "unknown"}`,
    },
  });
}
