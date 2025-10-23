import { hc } from "hono/client";
import { env, SELF } from "cloudflare:test";
import dayjs from "dayjs";
import { COOKIE_NAME, storeSession } from "../src/composable/session";
import type { AppType } from "../src/router";

export type ClientType = ReturnType<typeof hc<AppType>>;

export async function createTestClient() {
  const expire = dayjs().add(1, "day");

  const sessID = await storeSession(
    env,
    {
      avatarUrl: "",
      name: "testing user",
      login: "testing",
      source: "github",
      uid: "1",
      accessToken: "gho_test_token",
      accessTokenExpire: expire.valueOf(),
      refreshToken: "ghr_test_token",
    },
    expire,
  );

  return hc<AppType>("http://example.com", {
    fetch: SELF.fetch.bind(SELF),
    headers: {
      cookie: `__Host-${COOKIE_NAME}=${sessID}`,
      accept: "application/json",
    },
  });
}
