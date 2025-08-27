import { Hono } from "hono";
import { clientInject } from "../middleware/client";
import apiRouter from "./api";
import authRouter from "./auth";
import basicRouter from "./basic";

// Need to do two separate Hono instance. Otherwise typescript will fail to
// infer typeof `app` because it is self referral from `clientInject`.
const app1 = new Hono<Env>({ strict: false })
  .route("/auth", authRouter)
  .route("/api", apiRouter)
  .route("/basic", basicRouter);

const app = new Hono<Env>({ strict: false })
  .use(clientInject(app1))
  .route("/", app1);

export default app;

export type AppType = typeof app1;
