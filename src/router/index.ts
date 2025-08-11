import { Hono } from "hono";
import apiRouter from "./api";
import authRouter from "./auth";

const app = new Hono<Env>();

app.route("/auth", authRouter);
app.route("/api", apiRouter);

export default app;
