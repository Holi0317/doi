import { Hono } from "hono";
import { clientInject } from "../middleware/client";
import apiRouter from "./api";
import authRouter from "./auth";
import basicRouter from "./basic";

// TODO: Landing page
// TODO: Admin page
const app = new Hono<Env>({ strict: false })
  .use(clientInject(apiRouter))
  .route("/auth", authRouter)
  .route("/api", apiRouter)
  .route("/basic", basicRouter);

export default app;

export type AppType = typeof app;
