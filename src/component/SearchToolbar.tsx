import type * as z from "zod";
import { SearchQuerySchema } from "../schemas";

export interface SearchToolbarProps {
  query: z.output<typeof SearchQuerySchema>;
}

export function SearchToolbar(props: SearchToolbarProps) {
  const { query } = props;
  const shape = SearchQuerySchema.shape;

  const archive = shape.archive.encode(query.archive) || "";
  const favorite = shape.favorite.encode(query.favorite) || "";

  return (
    <form>
      <input
        type="input"
        name="query"
        value={query.query || ""}
        placeholder="Search"
      />

      <select name="archive">
        <option value="" selected={archive === ""}>
          Any
        </option>
        <option value="true" selected={archive === "true"}>
          Archived
        </option>
        <option value="false" selected={archive === "false"}>
          Saved
        </option>
      </select>

      <select name="favorite">
        <option value="" selected={favorite === ""}>
          Any
        </option>
        <option value="true" selected={favorite === "true"}>
          Favorite
        </option>
        <option value="false" selected={favorite === "false"}>
          Non-favorite
        </option>
      </select>

      <select name="order">
        <option
          value="created_at_asc"
          selected={query.order === "created_at_asc"}
        >
          Ascending (oldest first)
        </option>
        <option
          value="created_at_desc"
          selected={query.order === "created_at_desc"}
        >
          Descending (newest first)
        </option>
      </select>

      <input type="submit" />
    </form>
  );
}
