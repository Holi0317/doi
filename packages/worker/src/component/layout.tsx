import { css, Style } from "hono/css";
import type { PropsWithChildren } from "hono/jsx";

export type LayoutProps = PropsWithChildren<{
  title?: string;
}>;

export function Layout(props: LayoutProps) {
  const title = props.title ? `${props.title} | HauDoi` : "HauDoi";

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>{title}</title>
        <Style>{css`
          html {
            box-sizing: border-box;
          }

          *,
          *:before,
          *:after {
            box-sizing: inherit;
          }

          body {
            line-height: 1.6;
            font-size: 18px;
            color: #444;
          }
          h1,
          h2,
          h3 {
            line-height: 1.2;
          }

          dl {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 0.5rem 1rem;
            margin: 1rem 0;
          }

          dt {
            font-weight: 600;
            color: #333;
          }

          dd {
            margin: 0;
            word-break: break-word;
          }
        `}</Style>
      </head>
      <body>{props.children}</body>
    </html>
  );
}
