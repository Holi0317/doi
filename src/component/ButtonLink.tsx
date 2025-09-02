import type { PropsWithChildren } from "hono/jsx";

export type ButtonLinkProps = PropsWithChildren<{
  href: string;
}>;

export function ButtonLink(props: ButtonLinkProps) {
  return (
    <button>
      <a style={{ all: "unset" }} href={props.href}>
        {props.children}
      </a>
    </button>
  );
}
