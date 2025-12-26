import {
  queryOptions,
  useMutation,
  useQuery,
  useQueryClient,
} from "@tanstack/vue-query";
import { useExtLocalStorage } from "../storage";

const keys = {
  root: () => [{ scope: "storage.local" }] as const,
  config: () => [{ ...keys.root()[0], key: "config" }] as const,
};

const queries = {
  config: () =>
    queryOptions({
      queryKey: keys.config(),
      async queryFn() {
        return await storage.get();
      },
    }),
};

export interface ServerConfig {
  serverUrl: string;
}

const storage = useExtLocalStorage<ServerConfig>("config", () => ({
  serverUrl: "",
}));

export function useConfigQuery() {
  return useQuery(queries.config());
}

export function useConfigMutation() {
  const queryClient = useQueryClient();

  return useMutation({
    async mutationFn(newConfig: ServerConfig) {
      await storage.set(newConfig);
    },
    async onSuccess() {
      // Invalidate everything because server config is the foundation for other queries
      await queryClient.invalidateQueries();
    },
  });
}
