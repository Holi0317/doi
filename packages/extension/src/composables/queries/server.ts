import { useQuery } from "@tanstack/vue-query";
import { useConfigQuery } from "./server-config";
import { computed } from "vue";

const keys = {
  root: () => [{ scope: "server" }] as const,
  info: () => [{ ...keys.root()[0], key: "info" }] as const,
};

export function useServerInfoQuery() {
  const { data } = useConfigQuery();
  const enabled = computed(() => !!data.value?.serverUrl);

  return useQuery({
    queryKey: keys.info(),
    enabled,
    async queryFn() {
      const serverUrl = data.value?.serverUrl;
      if (!serverUrl) {
        throw new Error("Server URL is not configured");
      }

      const response = await fetch(`${serverUrl}/api`, {
        method: "GET",
        credentials: "include",
      });

      if (!response.ok) {
        throw new Error(`Server returned ${response.status}`);
      }

      return await response.json();
    },
  });
}
