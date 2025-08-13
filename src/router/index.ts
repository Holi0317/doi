import { Hono } from "hono";
import apiRouter from "./api";
import authRouter from "./auth";

const app = new Hono<Env>().route("/auth", authRouter).route("/api", apiRouter);

export default app;

export type AppType = typeof app;
