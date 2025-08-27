import type * as z from "zod";
import type { SearchQuerySchema } from "../schemas";

export interface PaginationProps {
  cursor: string | null;
  queries: z.output<typeof SearchQuerySchema>;
}

function objToQuery(
  param: Record<string, string | number | boolean | null>,
): string {
  const s = new URLSearchParams();

  for (const [key, value] of Object.entries(param)) {
    if (!value) {
      continue;
    }

    s.set(key, value.toString());
  }

  return "?" + s.toString();
}

export function Pagination(props: PaginationProps) {
  const firstUrl = objToQuery({
    ...props.queries,
    cursor: null,
  });
  const nextUrl = objToQuery({
    ...props.queries,
    cursor: props.cursor,
  });

  const nextFrag = (
    <>
      &nbsp; | &nbsp;
      <a href={nextUrl}>{"> Next page"}</a>
    </>
  );

  return (
    <span>
      <a href={firstUrl}>{"< First page"}</a>
      {props.cursor != null && nextFrag}
    </span>
  );
}
