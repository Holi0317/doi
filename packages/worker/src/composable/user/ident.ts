import * as z from "zod";

/**
 * Identifier for a user.
 *
 * Both {@link User} and {@link Session} satisfies this interface.
 * This is used to read user data from registry.
 *
 * Use {@link uidToString} to convert this to string key.
 */
export interface UserIdentifier {
  source: "github";
  uid: string;
}

/**
 * Convert user identifier object to string key.
 */
export function uidToString(uid: UserIdentifier): string {
  return `${uid.source}:${uid.uid}`;
}

export const UserIdentifierStringSchema = z
  .string()
  .regex(/^[^:]+:.+$/, "Must be in format 'source:uid'")
  .transform((value, ctx) => {
    const [source, ...uidParts] = value.split(":");
    const uid = uidParts.join(":");

    if (source !== "github") {
      ctx.addIssue({
        code: "custom",
        message: "source must be 'github'",
      });

      return z.NEVER;
    }

    return {
      source: "github" as const,
      uid,
    } satisfies UserIdentifier;
  });
