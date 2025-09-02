import { jsxRenderer } from "hono/jsx-renderer";

export const renderer = () =>
  jsxRenderer(
    ({ children }) => {
      return <>{children}</>;
    },
    { docType: true },
  );
