import { Hono } from "hono";
import { clientInject } from "../middleware/client";
import apiRouter from "./api";
import authRouter from "./auth";

const app = new Hono<Env>().route("/auth", authRouter).route("/api", apiRouter);

app.use(clientInject(app));

export default app;

export type AppType = typeof app;
