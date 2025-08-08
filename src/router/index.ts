import { Hono } from "hono";
import apiRouter from "./api";
import authRouter from "./auth";

const app = new Hono<Env>();

app.route("/", apiRouter);
app.route("/", authRouter);

export default app;
