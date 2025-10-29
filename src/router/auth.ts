import { Hono } from "hono";
import dayjs from "dayjs";
import * as z from "zod";
import { zv } from "../composable/validator";
import { exchangeToken } from "../gh/oauth_token";
import { useKy } from "../composable/http";
import { getAuthorizeUrl } from "../gh/authorize";
import {
  deleteSession,
  getSession,
  setSession,
} from "../composable/session/cookie";
import {
  getAndDeleteOAuthState,
  RedirectDestinationSchema,
  storeOAuthState,
} from "../composable/oauth_state";
import { makeSessionContent } from "../composable/session/content";

const app = new Hono<Env>({ strict: false })
  .get("/", async (c) => {
    const sess = await getSession(c);
    return c.text(`Hello <${sess?.name}>!`);
  })
  .get("/logout", async (c) => {
    await deleteSession(c);
    return c.text("You have been successfully logged out!");
  })
  .get(
    "/github/login",
    zv(
      "query",
      z.object({
        redirect: RedirectDestinationSchema.default("/"),
      }),
    ),
    async (c) => {
      const { redirect } = c.req.valid("query");

      // Store redirect destination in KV and get state token
      const state = await storeOAuthState(c.env, redirect);
      const authUrl = getAuthorizeUrl(c, state);

      console.log(`Redirecting to login ${authUrl}`);

      return c.redirect(authUrl);
    },
  )
  .get(
    "/github/callback",
    zv("query", z.object({ code: z.string(), state: z.string() })),
    async (c) => {
      const { code, state } = c.req.valid("query");

      // Retrieve redirect destination from KV using state
      const stateData = await getAndDeleteOAuthState(c.env, state);
      if (stateData == null) {
        return c.text("Invalid or expired state parameter", 400);
      }

      const ky = useKy(c);

      const tokens = await exchangeToken(c, ky, code, "login");
      const now = dayjs();
      const expire = now.add(7, "day");

      const sess = await makeSessionContent(ky, tokens);

      await setSession(c, sess, expire);

      return c.redirect(stateData.redirect);
    },
  );

export default app;
