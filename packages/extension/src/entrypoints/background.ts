import type {
  ExtensionMessage,
  SaveLinkResponse,
  CheckAuthResponse,
} from "@/types/messages";
import { browser, defineBackground } from "#imports";

const STORAGE_KEY = "serverConfig";

interface ServerConfig {
  serverUrl: string;
  isConfigured: boolean;
}

async function getServerUrl(): Promise<string | null> {
  const result = await browser.storage.local.get(STORAGE_KEY);
  const config = result[STORAGE_KEY] as ServerConfig | undefined;
  return config?.serverUrl ?? null;
}

/**
 * Check if user is authenticated by calling the /api/search endpoint
 */
async function checkAuth(serverUrl: string): Promise<CheckAuthResponse> {
  try {
    const response = await fetch(`${serverUrl}/api/search`, {
      method: "GET",
      credentials: "include",
    });

    if (response.ok) {
      return { authenticated: true };
    }

    if (response.status === 401 || response.status === 403) {
      return { authenticated: false };
    }

    return {
      authenticated: false,
      error: `Server returned ${response.status}`,
    };
  } catch (error) {
    return {
      authenticated: false,
      error: error instanceof Error ? error.message : "Network error",
    };
  }
}

/**
 * Save a link to the server
 */
async function saveLink(
  serverUrl: string,
  url: string,
  title?: string,
): Promise<SaveLinkResponse> {
  try {
    const response = await fetch(`${serverUrl}/api/edit`, {
      method: "POST",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        op: [
          {
            op: "insert",
            url,
            title: title ?? null,
          },
        ],
      }),
    });

    if (response.ok || response.status === 201) {
      return { success: true };
    }

    if (response.status === 401 || response.status === 403) {
      return { success: false, error: "Not authenticated. Please log in." };
    }

    const errorText = await response.text();
    return {
      success: false,
      error: `Failed to save: ${response.status} ${errorText}`,
    };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : "Network error",
    };
  }
}

export default defineBackground(() => {
  console.log("Haudoi extension background started", {
    id: browser.runtime.id,
  });

  // Handle messages from popup
  browser.runtime.onMessage.addListener(
    (message: ExtensionMessage, _sender, sendResponse) => {
      (async () => {
        const serverUrl = await getServerUrl();

        if (!serverUrl) {
          sendResponse({ success: false, error: "Server not configured" });
          return;
        }

        switch (message.type) {
          case "CHECK_AUTH": {
            const result = await checkAuth(serverUrl);
            sendResponse(result);
            break;
          }
          case "SAVE_LINK": {
            const result = await saveLink(
              serverUrl,
              message.url,
              message.title,
            );
            sendResponse(result);
            break;
          }
          default:
            sendResponse({ success: false, error: "Unknown message type" });
        }
      })();

      // Return true to indicate we'll respond asynchronously
      return true;
    },
  );
});
