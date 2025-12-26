import { useMutation, useQuery } from "@tanstack/vue-query";
import { computed } from "vue";
import { useServerClient } from "../server";

const keys = {
  root: () => [{ scope: "server" }] as const,
  info: () => [{ ...keys.root()[0], key: "info" }] as const,
};

export function useServerInfoQuery() {
  const client = useServerClient();
  const enabled = computed(() => client.value != null);

  return useQuery({
    queryKey: keys.info(),
    enabled,
    async queryFn() {
      if (client.value == null) {
        throw new Error("Server URL is not configured");
      }

      const resp = await client.value.api.$get();
      return await resp.json();
    },
  });
}

export function useSaveMutation() {
  const client = useServerClient();

  return useMutation({
    async mutationFn(payload: { url: string; title?: string }) {
      if (client.value == null) {
        throw new Error("Server URL is not configured");
      }

      await client.value.api.edit.$post({
        json: {
          op: [{ op: "insert", url: payload.url, title: payload.title }],
        },
      });
    },
  });
}
