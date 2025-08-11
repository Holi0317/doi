import { Hono } from "hono";
import dayjs from "dayjs";
import * as z from "zod";
import { deleteSession, getSession, setSession } from "../composable/session";
import { zv } from "../composable/validator";
import { getUser } from "../gh/user";
import { oauthToken } from "../gh/oauth_token";
import { useKy } from "../composable/http";
import { getAuthorizeUrl } from "../gh/authorize";

const app = new Hono<Env>();

app.get("/", async (c) => {
  const sess = await getSession(c);
  return c.text(`Hello <${sess?.name}>!`);
});

app.get("/logout", async (c) => {
  await deleteSession(c);
  return c.text("You have been successfully logged out!");
});

app.get("/github/login", async (c) => {
  const authUrl = getAuthorizeUrl(c);

  console.log(`Redirecting to login ${authUrl}`);

  return c.redirect(authUrl);
});

app.get(
  "/github/callback",
  zv("query", z.object({ code: z.string() })),
  async (c) => {
    const { code } = c.req.valid("query");

    const ky = useKy(c);

    const access_token = await oauthToken(c, ky, code);
    const userInfo = await getUser(ky, access_token);

    const expire = dayjs().add(7, "days");

    await setSession(
      c,
      {
        source: "github",
        uid: userInfo.id.toString(),
        name: userInfo.name || userInfo.login,
        avatar_url: userInfo.avatar_url,
      },
      expire,
    );

    return c.redirect("/");
  },
);

export default app;
