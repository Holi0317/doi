import { Style } from "hono/css";
import type { PropsWithChildren } from "hono/jsx";

export type LayoutProps = PropsWithChildren<{
  title?: string;
}>;

export function Layout(props: LayoutProps) {
  const title = props.title ? `${props.title} | Poche` : "Poche";

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>{title}</title>
        <Style />
      </head>
      <body>{props.children}</body>
    </html>
  );
}
