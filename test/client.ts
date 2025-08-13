import { hc } from "hono/client";
import { env, SELF } from "cloudflare:test";
import dayjs from "dayjs";
import { COOKIE_NAME, storeSession } from "../src/composable/session";
import type { AppType } from "../src/router";

export async function createTestClient() {
  const sessID = await storeSession(
    env,
    {
      avatar_url: "",
      name: "testing user",
      source: "github",
      uid: "1",
    },
    dayjs().add(1, "day"),
  );

  return hc<AppType>("http://example.com", {
    fetch: SELF.fetch.bind(SELF),
    headers: {
      cookie: `__Host-${COOKIE_NAME}=${sessID}`,
      accept: "application/json",
    },
  });
}
