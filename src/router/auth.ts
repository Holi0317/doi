import { Hono } from "hono";
import dayjs from "dayjs";
import * as z from "zod";
import ky from "ky";
import { deleteSession, getSession, setSession } from "../composable/session";
import { zv } from "../composable/validator";
import { oauthAccessToken } from "../composable/github";

const app = new Hono<Env>();

app.get("/auth/logout", async (c) => {
  await deleteSession(c);
  return c.text("You have been successfully logged out!");
});

app.get("/auth/github/login", async (c) => {
  const redirectUri = new URL(c.req.url);
  redirectUri.hash = "";
  redirectUri.pathname = "/auth/github/callback";
  redirectUri.search = "";
  redirectUri.password = "";

  // See https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#1-request-a-users-github-identity
  const param = new URLSearchParams([
    ["client_id", c.env.GH_CLIENT_ID],
    ["redirect_uri", redirectUri.toString()],
  ]);

  return c.redirect(
    `https://github.com/login/oauth/authorize?${param.toString()}`,
  );
});

const UserInfoSchema = z.object({
  id: z.number(),
  login: z.string(),
  name: z.string().nullable(),
  avatar_url: z.string(),
});

app.get(
  "/auth/github/callback",
  zv("query", z.object({ code: z.string() })),
  async (c) => {
    const { code } = c.req.valid("query");

    const access_token = await oauthAccessToken(c, code);

    const userInfoResp = await ky
      .get("https://api.github.com/user", {
        headers: {
          authorization: `Bearer ${access_token}`,
          accept: "application/json",
          "user-agent": `poche-app/0.0.0`,
        },
      })
      .json();

    const userInfo = UserInfoSchema.parse(userInfoResp);

    const expire = dayjs().add(7, "days").valueOf();

    await setSession(c, {
      expire,
      source: "github",
      uid: userInfo.id.toString(),
      name: userInfo.name || userInfo.login,
      avatar_url: userInfo.avatar_url,
    });

    return c.redirect("/");
  },
);

app.get("/auth", async (c) => {
  const sess = await getSession(c);
  return c.text(`Hello <${sess?.name}>!`);
});

export default app;
