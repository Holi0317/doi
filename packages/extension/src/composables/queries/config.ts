import { useMutation, useQuery, useQueryClient } from "@tanstack/vue-query";
import { createClient } from "@haudoi/worker/client";
import { useExtLocalStorage } from "../storage";

const keys = {
  root: () => [{ scope: "storage.local" }] as const,
  config: () => [{ ...keys.root()[0], key: "config" }] as const,
};

export interface ServerConfig {
  serverUrl: string;
}

const storage = useExtLocalStorage<ServerConfig>("config", () => ({
  serverUrl: "",
}));

export function useConfigQuery() {
  return useQuery({
    queryKey: keys.config(),
    async queryFn() {
      return await storage.get();
    },
  });
}

export function useServerClientQuery() {
  return useQuery({
    queryKey: keys.config(),
    async queryFn() {
      return await storage.get();
    },
    select(config) {
      if (!config.serverUrl) {
        return null;
      }

      return createClient(config.serverUrl, {
        init: { credentials: "include" },
      });
    },
  });
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
