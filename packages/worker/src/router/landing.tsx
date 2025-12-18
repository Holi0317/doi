import { Hono } from "hono";

const app = new Hono<Env>({ strict: false }).get("/", async (c) => {
  return c.render(
    <>
      <p>Hi, welcome to haudoi (口袋)</p>

      <p>
        <a
          href="https://github.com/Holi0317/haudoi"
          rel="noopener noreferrer"
          target="_blank"
        >
          Why this looks so unstyled and ugly
        </a>
      </p>

      <p>
        <a href="/basic">Login to web</a>
      </p>
    </>,
  );
});

export default app;
