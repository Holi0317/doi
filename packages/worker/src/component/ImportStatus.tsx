import type * as z from "zod";
import type { ImportStatusSchema } from "../schemas";
import { DateDisplay } from "./DateDisplay";
import { ButtonLink } from "./ButtonLink";

export function ImportStatus(props: {
  status: z.output<typeof ImportStatusSchema> | null;
}) {
  const { status } = props;

  if (status == null) {
    return <p>No import in progress.</p>;
  }

  if (status.completed == null) {
    return (
      <>
        <p>
          Import started at <DateDisplay timestamp={status.startedAt} />
        </p>
        <p>Import is still in progress...</p>

        <ButtonLink href="">Reload page</ButtonLink>
      </>
    );
  }

  return (
    <>
      <p>
        Import started at <DateDisplay timestamp={status.startedAt} />
      </p>

      <p>
        Import completed at{" "}
        <DateDisplay timestamp={status.completed.completedAt} />
      </p>
      <p>Processed rows: {status.completed.processed}</p>
      <p>Inserted rows: {status.completed.inserted}</p>

      {status.completed.errors.length > 0 && (
        <>
          <h3>Errors</h3>
          <ul>
            {status.completed.errors.map((err, idx) => (
              <li key={idx}>{err}</li>
            ))}
          </ul>
        </>
      )}
    </>
  );
}
