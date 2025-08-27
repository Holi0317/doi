import type { LinkItem } from "../do/storage";

export interface LinkItemProps {
  item: LinkItem;
}

export function LinkItem(props: LinkItemProps) {
  const { item } = props;

  const title = item.title || item.url;

  return (
    <li>
      <a href={item.url} target="_blank" rel="noopener noreferrer" alt={title}>
        {title}
      </a>
    </li>
  );
}
