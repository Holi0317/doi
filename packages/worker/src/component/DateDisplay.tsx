import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";

dayjs.extend(relativeTime);

export interface DateDisplayProps {
  timestamp: NonNullable<dayjs.ConfigType>;
}

export function DateDisplay(props: DateDisplayProps) {
  const timestamp = dayjs(props.timestamp);

  const iso = timestamp.toISOString();
  const rel = timestamp.fromNow();

  return (
    <>
      {iso} <small>({rel})</small>
    </>
  );
}
