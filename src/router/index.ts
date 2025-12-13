import { Hono } from "hono";
import { clientInject } from "../middleware/client";
import { renderer } from "../middleware/renderer";
import { blockRequestLoop } from "../middleware/loop";
import apiRouter from "./api";
import authRouter from "./auth";
import basicRouter from "./basic";
import landingRouter from "./landing";
import adminRouter from "./admin";

const app = new Hono<Env>({ strict: false })
  .use(clientInject(apiRouter))
  .use(renderer())
  .use(blockRequestLoop())
  .route("/", landingRouter)
  .route("/auth", authRouter)
  .route("/api", apiRouter)
  .route("/basic", basicRouter)
  .route("/admin", adminRouter);

export default app;

export type AppType = typeof app;
