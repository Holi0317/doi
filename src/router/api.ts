import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { LinkInsertSchema } from "../do/storage";

const app = new Hono<{ Bindings: CloudflareBindings }>();

app.get("/api/list", async (c) => {
  const id = c.env.STORAGE.idFromName("0");
  const stub = c.env.STORAGE.get(id);

  const links = await stub.search({
    limit: 30,
    order: "id_desc",
  });

  return c.json(links);
});

app.post("/api/insert", zValidator("json", LinkInsertSchema), async (c) => {
  const id = c.env.STORAGE.idFromName("0");
  const stub = c.env.STORAGE.get(id);

  const body = c.req.valid("json");

  const inserted = await stub.insert(body);

  return c.json(inserted);
});

export default app;
