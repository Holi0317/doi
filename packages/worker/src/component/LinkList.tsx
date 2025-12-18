import type { LinkItem } from "../schemas";
import { LinkItem as LinkItemComp } from "./LinkItem";

export interface LinkListProps {
  items: LinkItem[];
}

/**
 * Rendering list of {@link LinkItem}
 *
 * Not array link list. I'm so bad at naming things.
 *
 * Basically a wrapper on {@link LinkItemComp} component.
 */
export function LinkList(props: LinkListProps) {
  const { items } = props;

  if (items.length === 0) {
    return <p>No item stored or nothing match query</p>;
  }

  return (
    <ul style={{ lineHeight: "2.5rem" }}>
      {items.map((item) => (
        <LinkItemComp item={item} />
      ))}
    </ul>
  );
}
