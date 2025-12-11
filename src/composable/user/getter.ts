import type { Context } from "hono";
import { HTTPException } from "hono/http-exception";
import { useReqCache } from "../cache";
import { getSession } from "../session/cookie";
import { useUserRegistry } from "./registry";

export async function getUser(c: Context<Env>) {
  const registry = useUserRegistry(c.env);

  const session = await getSession(c);
  if (session == null) {
    return null;
  }

  return useReqCache(c, "user", async () => {
    const user = await registry.read(session);
    return user;
  });
}

export async function mustUser(c: Context<Env>) {
  const user = await getUser(c);
  if (user == null) {
    console.warn(
      "Got null user in `mustUser`. Did the route forget `requireSession` middleware?",
    );

    throw new HTTPException(401, { message: "Unauthenticated" });
  }

  return user;
}
