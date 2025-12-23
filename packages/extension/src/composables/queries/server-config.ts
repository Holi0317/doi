import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { browser } from "#imports";

const keys = {
  root: () => [{ scope: "storage.local" }] as const,
  serverConfig: () => [{ ...keys.root()[0], key: "serverConfig" }] as const,
};

export interface ServerConfig {
  serverUrl: string;
}

const STORAGE_KEY = "serverConfig";

export function useConfigQuery() {
  return useQuery({
    queryKey: keys.serverConfig(),
    async queryFn() {
      const result = await browser.storage.local.get(STORAGE_KEY);
      return (result[STORAGE_KEY] ?? {
        serverUrl: "",
      }) as unknown as ServerConfig;
    },
  });
}

export function useConfigMutation() {
  const queryClient = useQueryClient();

  return useMutation({
    async mutationFn(newConfig: ServerConfig) {
      await browser.storage.local.set({
        [STORAGE_KEY]: newConfig,
      });
    },
    async onSuccess() {
      // Invalidate everything because server config is the foundation for other queries
      await queryClient.invalidateQueries();
    },
  });
}
