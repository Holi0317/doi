import { Hono } from "hono";
import * as z from "zod";
import { requireSession } from "../composable/session/middleware";
import { Layout } from "../component/layout";
import { requireAdmin } from "../composable/user/admin";
import { useUserRegistry } from "../composable/user/registry";
import { zv } from "../composable/validator";
import {
  uidToString,
  UserIdentifierStringSchema,
} from "../composable/user/ident";
import { getStorageStub } from "../composable/do";
import { DateDisplay } from "../component/DateDisplay";
import { ButtonLink } from "../component/ButtonLink";

function formatBytes(bytes: number): string {
  if (bytes === 0) {return "0 Bytes";}

  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return (
    new Intl.NumberFormat("en-US", {
      maximumFractionDigits: 2,
    }).format(bytes / Math.pow(k, i)) +
    " " +
    sizes[i]
  );
}

const app = new Hono<Env>({ strict: false })
  .use(requireSession({ action: "throw" }))
  .use(requireAdmin())
  .get("/", async (c) => {
    const { list: listUsers } = useUserRegistry(c.env);

    const users = await listUsers();

    return c.render(
      <Layout title="Admin console">
        <h1>Admin console</h1>

        <h2>Registered users</h2>
        <ul>
          {users.map((user) => (
            <li>
              <a href={`/admin/${user.name}`}>{user.metadata.string}</a>
            </li>
          ))}
        </ul>
      </Layout>,
    );
  })
  .get(
    "/:uid",
    zv("param", z.object({ uid: UserIdentifierStringSchema })),
    async (c) => {
      const { uid } = c.req.valid("param");

      const uidStr = uidToString(uid);

      const { read } = useUserRegistry(c.env);
      const user = await read(uid);

      if (user == null) {
        return c.text("User not found", 404);
      }

      const storage = await getStorageStub(c, uid);
      const stat = await storage.stat();

      return c.render(
        <Layout title={`Admin - ${user.name}`}>
          <a href="/admin">Back</a>
          <h2>User details</h2>
          <dl>
            <dt>Name</dt>
            <dd>{user.name}</dd>
            <dt>Login</dt>
            <dd>{user.login}</dd>
            <dt>UID</dt>
            <dd>{uid.uid}</dd>
            <dt>Source</dt>
            <dd>{uid.source}</dd>
            <dt>Created At</dt>
            <dd>
              <DateDisplay timestamp={user.createdAt} />
            </dd>
            <dt>Last Login</dt>
            <dd>
              <DateDisplay timestamp={user.lastLoginAt} />
            </dd>
          </dl>

          <h2>Storage Statistics</h2>
          <dl>
            <dt>Database Size</dt>
            <dd title={stat.dbSize.toString()}>{formatBytes(stat.dbSize)}</dd>
            <dt>Entry Count</dt>
            <dd>{stat.count}</dd>
            <dt>Max ID</dt>
            <dd>{stat.maxID}</dd>
            <dt>Colo</dt>
            <dd>{stat.colo}</dd>
          </dl>

          <h2>Actions</h2>
          <form method="post" action={`/admin/${uidStr}/vacuum`}>
            <button type="submit">Vacuum Database</button>
          </form>
          <ButtonLink href={`/admin/${uidStr}/delete`}>Delete user</ButtonLink>
        </Layout>,
      );
    },
  )
  .post(
    "/:uid/vacuum",
    zv("param", z.object({ uid: UserIdentifierStringSchema })),
    async (c) => {
      const { uid } = c.req.valid("param");

      const uidStr = uidToString(uid);

      const { read } = useUserRegistry(c.env);
      const user = await read(uid);

      if (user == null) {
        return c.text("User not found", 404);
      }

      const storage = await getStorageStub(c, uid);
      await storage.vacuum();

      return c.render(
        <Layout title={`Admin - ${user.name} - Vacuum`}>
          <h2>Vacuum completed</h2>
          <p>Database vacuum operation has been completed.</p>
          <a href={`/admin/${uidStr}`}>Back to user details</a>
        </Layout>,
      );
    },
  )
  .get(
    "/:uid/delete",
    zv("param", z.object({ uid: UserIdentifierStringSchema })),
    async (c) => {
      const { uid } = c.req.valid("param");

      const uidStr = uidToString(uid);

      const { read } = useUserRegistry(c.env);
      const user = await read(uid);

      if (user == null) {
        return c.text("User not found", 404);
      }

      return c.render(
        <Layout title={`Admin - ${user.name} - Confirm delete`}>
          <h2>Confirm user deletion</h2>
          <p>
            Are you sure you want to delete user{" "}
            <strong>
              {uidStr} / {user.login}
            </strong>
            ? This action is irreversible.
          </p>
          <form method="post">
            <button type="submit">Yes, delete user</button>
          </form>
        </Layout>,
      );
    },
  )
  .post(
    "/:uid/delete",
    zv("param", z.object({ uid: UserIdentifierStringSchema })),
    async (c) => {
      const { uid } = c.req.valid("param");

      const uidStr = uidToString(uid);

      const { read, remove } = useUserRegistry(c.env);
      const user = await read(uid);

      if (user == null) {
        return c.text("User not found", 404);
      }

      const storage = await getStorageStub(c, uid);
      await storage.deallocate();

      await remove(uid);

      // FIXME: Remove session

      return c.render(
        <Layout title={`Admin - ${user.name} - Delete completed`}>
          <h2>Delete completed</h2>
          <p>
            Deleted user {user.name} ({uidStr})
          </p>
          <a href={`/admin`}>Back to user list</a>
        </Layout>,
      );
    },
  );

export default app;
