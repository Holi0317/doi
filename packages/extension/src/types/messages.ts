/**
 * Message types for communication between popup and background script
 */

export interface SaveLinkMessage {
  type: "SAVE_LINK";
  url: string;
  title?: string;
}

export interface CheckAuthMessage {
  type: "CHECK_AUTH";
}

export interface SaveLinkResponse {
  success: boolean;
  error?: string;
}

export interface CheckAuthResponse {
  authenticated: boolean;
  error?: string;
}

export type ExtensionMessage = SaveLinkMessage | CheckAuthMessage;
export type ExtensionResponse = SaveLinkResponse | CheckAuthResponse;
