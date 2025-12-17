import type { WorkflowEvent, WorkflowStep } from "cloudflare:workers";
import { WorkflowEntrypoint } from "cloudflare:workers";
import { uidToString, type UserIdentifier } from "../composable/user/ident";
import { useImportStore } from "../composable/import";
import { getImportStubAdmin, getStorageStubAdmin } from "../composable/do";
import { useBasicKy } from "../composable/http";
import { processInsert } from "../composable/insert";

export interface ImportWorkflowParams {
  uid: UserIdentifier;
  rawId: string;
}

export class ImportWorkflow extends WorkflowEntrypoint<
  CloudflareBindings,
  ImportWorkflowParams
> {
  public async run(
    event: WorkflowEvent<ImportWorkflowParams>,
    step: WorkflowStep,
  ) {
    const { uid, rawId } = event.payload;
    const uidStr = uidToString(uid);

    console.log("Starting import workflow", { uid, rawId });

    const parts = await step.do("Partition raw import file", async () => {
      const { partition } = useImportStore(this.env);
      return await partition(uid, rawId);
    });

    for (const partId of parts) {
      await step.do(`Import part ${partId}`, async () => {
        console.log(`Importing chunk for user ${uidStr}: ${partId}`);

        const { readPart } = useImportStore(this.env);
        const stub = getStorageStubAdmin(this.env, uid);
        const ky = useBasicKy(this.env);

        const part = await readPart(uid, partId);

        console.log("Resolving insert items titles");
        const inserts = await processInsert(ky, part.items);

        console.log("Writing insert items into storage");
        await stub.insert(inserts);
      });
    }

    console.log("Import workflow completed. Marking on durable object", {
      uid,
      rawId,
    });

    await step.do("Mark import as complete", async () => {
      const stub = getImportStubAdmin(this.env, uid);
      await stub.complete({
        completedAt: Date.now(),
        count: 0,
        errors: [],
      });
    });
  }
}
