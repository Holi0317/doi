import { useMutation } from "@tanstack/vue-query";
import { useConfigMutation, useServerClientQuery } from "./queries/config";
import { createClient } from "@haudoi/worker/client";
import { browser } from "#imports";

export function useServerSetup() {
  const config = useConfigMutation();

  return useMutation({
    async mutationFn(url: string) {
      const parsedUrl = new URL(url);
      const normalizedUrl = parsedUrl.origin;

      console.info("Requesting permission for origin:", normalizedUrl);

      // Request permission for this origin
      const granted = await browser.permissions.request({
        origins: [`${normalizedUrl}/*`],
        permissions: ["cookies"],
      });

      if (!granted) {
        console.warn("Permission denied for origin:", normalizedUrl);
        throw new Error("Permission denied for this server");
      }

      // Check if the server is valid, reachable and has been authenticated before saving
      console.info(
        "Permission granted for origin. Validating server:",
        normalizedUrl,
      );

      const client = createClient(normalizedUrl, {
        init: { credentials: "include" },
      });

      const response = await client.api.$get();

      if (!response.ok) {
        throw new Error(
          `Server validation failed with status ${response.status}: ${await response.text()}`,
        );
      }

      const info = await response.json();

      if (info.name !== "haudoi") {
        throw new Error("The server is not a valid haudoi server");
      }

      await config.mutateAsync({ serverUrl: normalizedUrl });

      return {
        authenticated: info.session != null,
      };
    },
  });
}

export function useServerLogin() {
  const { data } = useServerClientQuery();

  const login = () => {
    if (data.value == null) {
      throw new Error("Server URL is not configured");
    }

    const loginUrl = data.value.auth.github.login.$url();

    browser.tabs.create({
      url: loginUrl.toString(),
    });

    // Close popup - user will come back after login
    window.close();
  };

  return {
    login,
  };
}
