import { DurableObject } from "cloudflare:workers";
import dayjs from "dayjs";
import type { KyInstance } from "ky";
import * as z from "zod";
import { AccessTokenSchema } from "../gh/oauth_token";
import { useSessionStorage, type Session } from "../composable/session/schema";

const AccessTokenSchemaWithError = z.union([
  z.object({
    error: z.string(),
    error_description: z.string(),
    error_uri: z.string(),
  }),
  AccessTokenSchema,
]);

/**
 * Durable Object for handling GitHub token refresh with concurrency control.
 * 
 * This object provides a locking mechanism to ensure only one refresh operation
 * happens at a time for a given session. It does not persist any state in storage.
 * 
 * Each session has an associated TokenRefreshDO instance identified by session hash.
 */
export class TokenRefreshDO extends DurableObject<CloudflareBindings> {
  private refreshPromise: Promise<boolean> | null = null;
  
  /**
   * Refresh the GitHub access token if it has expired.
   * 
   * This method provides concurrency control - if a refresh is already in progress,
   * it will wait for it to complete. If the token isn't expired, it returns immediately.
   * 
   * @param sessionHash The hash of the session ID
   * @param ky KyInstance for making HTTP requests
   * @returns true if token was refreshed, false if it was not needed
   */
  public async refreshIfNeeded(sessionHash: string, ky: KyInstance): Promise<boolean> {
    // If a refresh is already in progress, wait for it and return its result
    if (this.refreshPromise !== null) {
      return await this.refreshPromise;
    }
    
    // Start the refresh and store the promise
    this.refreshPromise = this.doRefresh(sessionHash, ky);
    
    try {
      return await this.refreshPromise;
    } finally {
      // Clear the promise when done
      this.refreshPromise = null;
    }
  }
  
  /**
   * Internal method that performs the actual token refresh.
   */
  private async doRefresh(sessionHash: string, ky: KyInstance): Promise<boolean> {
    const { read, write } = useSessionStorage(this.env);
    
    // Read the current session
    const session = await read(sessionHash);
    
    if (session == null) {
      // Session doesn't exist or has expired
      return false;
    }
    
    const now = dayjs();
    
    // Check if token is expired
    if (now.isBefore(dayjs(session.accessTokenExpire))) {
      // Token is still valid, no refresh needed
      return false;
    }
    
    // Check if we have a refresh token
    if (!session.refreshToken) {
      // No refresh token available, cannot refresh
      return false;
    }
    
    // Exchange refresh token for new access token
    const tokens = await this.exchangeRefreshToken(ky, session.refreshToken);
    
    // Update the session with new tokens while preserving user info
    const updatedSession: Session = {
      ...session,
      accessToken: tokens.access_token,
      accessTokenExpire: now.add(8, "hour").valueOf(),
      refreshToken: tokens.refresh_token,
    };
    
    // Calculate expiration time (7 days from now)
    const expire = now.add(7, "day");
    
    // Write the updated session back to KV
    await write(sessionHash, updatedSession, expire);
    
    return true;
  }
  
  /**
   * Exchange a refresh token for a new access token.
   * This is a simplified version of exchangeToken from oauth_token.ts
   * that doesn't require a Context object.
   */
  private async exchangeRefreshToken(
    ky: KyInstance,
    refreshToken: string
  ): Promise<z.output<typeof AccessTokenSchema>> {
    const accessTokenResp = await ky
      .post("https://github.com/login/oauth/access_token", {
        headers: {
          accept: "application/json",
        },
        searchParams: {
          client_id: this.env.GH_CLIENT_ID,
          client_secret: this.env.GH_CLIENT_SECRET,
          grant_type: "refresh_token",
          refresh_token: refreshToken,
        },
      })
      .json();

    const parsed = AccessTokenSchemaWithError.parse(accessTokenResp);
    
    if ("error" in parsed) {
      throw new Error(
        `Failed to exchange github token from refresh token.\n${parsed.error}: ${parsed.error_description}`
      );
    }
    
    return parsed;
  }
}
