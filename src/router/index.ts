import { Hono } from "hono";
import apiRouter from "./api";

const app = new Hono<{ Bindings: CloudflareBindings }>();

app.route("/", apiRouter);

export default app;
