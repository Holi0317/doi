import { Hono } from "hono";
import dayjs from "dayjs";
import * as z from "zod";
import {
  deleteSession,
  getSession,
  makeSessionContent,
  setSession,
} from "../composable/session";
import { zv } from "../composable/validator";
import { exchangeToken } from "../gh/oauth_token";
import { useKy } from "../composable/http";
import { getAuthorizeUrl } from "../gh/authorize";

const app = new Hono<Env>({ strict: false })
  .get("/", async (c) => {
    const sess = await getSession(c);
    return c.text(`Hello <${sess?.name}>!`);
  })
  .get("/logout", async (c) => {
    await deleteSession(c);
    return c.text("You have been successfully logged out!");
  })
  .get("/github/login", async (c) => {
    const authUrl = getAuthorizeUrl(c);

    console.log(`Redirecting to login ${authUrl}`);

    return c.redirect(authUrl);
  })
  .get(
    "/github/callback",
    zv("query", z.object({ code: z.string() })),
    async (c) => {
      const { code } = c.req.valid("query");

      const ky = useKy(c);

      const tokens = await exchangeToken(c, ky, code, "login");
      const now = dayjs();
      const expire = now.add(7, "day");

      const sess = await makeSessionContent(ky, tokens);

      await setSession(c, sess, expire);

      return c.redirect("/");
    },
  );

export default app;
