import { Hono } from "hono";
import { LinkInsertSchema } from "../do/storage";
import { zv } from "../composable/validator";
import { getStorageStub } from "../composable/do";
import { requireSession } from "../composable/session";

const app = new Hono<Env>();
app.use(requireSession("redirect"));

app.get("/api/list", async (c) => {
  const stub = await getStorageStub(c);

  const links = await stub.search({
    limit: 30,
    order: "id_desc",
  });

  return c.json(links);
});

app.post("/api/insert", zv("json", LinkInsertSchema), async (c) => {
  const stub = await getStorageStub(c);

  const body = c.req.valid("json");

  const inserted = await stub.insert(body);

  return c.json(inserted);
});

export default app;
