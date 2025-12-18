import type { Context } from "hono";
import { getImportStubAdmin } from "../composable/do";
import type { UserIdentifier } from "../composable/user/ident";
import { DateDisplay } from "./DateDisplay";

export interface AdminImportStatusProps {
  c: Context<Env>;
  uid: UserIdentifier;
}

export async function AdminImportStatus(props: AdminImportStatusProps) {
  const { c, uid } = props;

  const stub = getImportStubAdmin(c.env, uid);

  const importStatus = await stub.status();
  if (importStatus == null) {
    return <p>No import in progress.</p>;
  }

  const wf = await c.env.IMPORT_WORKFLOW.get(importStatus.workflowId);
  let wfStatus: string;
  try {
    const status = await wf.status();
    wfStatus = JSON.stringify(status, null, 2);
  } catch (error) {
    console.warn("Failed to get workflow status:", error);
    wfStatus = `Error retrieving workflow status: ${error}`;
  }

  return (
    <>
      <dl>
        <dt>Raw ID in KV</dt>
        <dd>{importStatus.rawId}</dd>
        <dt>Workflow ID</dt>
        <dd>{importStatus.workflowId}</dd>
        <dt>Started at</dt>
        <dd>
          <DateDisplay timestamp={importStatus.startedAt} />
        </dd>
        <dt>Completed</dt>
        <dd>
          <pre>{JSON.stringify(importStatus.completed, null, 2)}</pre>
        </dd>
      </dl>
      <h3>Workflow status</h3>
      <pre>{wfStatus}</pre>
    </>
  );
}
