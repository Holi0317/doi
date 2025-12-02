import dayjs from "dayjs";
import type { LinkItem } from "../do/storage";

export interface LinkItemFormProps {
  item: LinkItem;
}

export function LinkItemForm(props: LinkItemFormProps) {
  const { item } = props;

  return (
    <form method="post">
      <div>
        <label>
          ID
          <input name="id" disabled={true} value={item.id} />
        </label>
      </div>

      <div>
        <label>
          Title
          <input name="title" disabled={true} value={item.title} />
        </label>
      </div>

      <div>
        <label>
          URL
          <input name="url" disabled={true} value={item.url} />
        </label>
      </div>

      <div>
        <label>
          Archive
          <input name="archive" type="checkbox" checked={item.archive} />
        </label>
      </div>

      <div>
        <label>
          Favorite
          <input name="favorite" type="checkbox" checked={item.favorite} />
        </label>
      </div>

      <div>
        <label>
          Note
          <textarea name="note" maxLength={4096}>
            {item.note}
          </textarea>
        </label>
      </div>

      <div>
        <label>Created at {dayjs(item.created_at).toISOString()}</label>
      </div>

      <input type="submit" value="submit" />
    </form>
  );
}
