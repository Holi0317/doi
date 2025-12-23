import { useQuery } from "@tanstack/vue-query";
import { useServerClientQuery } from "./config";
import { computed } from "vue";

const keys = {
  root: () => [{ scope: "server" }] as const,
  info: () => [{ ...keys.root()[0], key: "info" }] as const,
};

export function useServerInfoQuery() {
  const { data } = useServerClientQuery();
  const enabled = computed(() => data.value != null);

  return useQuery({
    queryKey: keys.info(),
    enabled,
    async queryFn() {
      const client = data.value;
      if (client == null) {
        throw new Error("Server URL is not configured");
      }

      const resp = await client.api.$get();
      return await resp.json();
    },
  });
}
