import { zValidator } from "@hono/zod-validator";
import type { ValidationTargets } from "hono";
import { HTTPException } from "hono/http-exception";
import * as z from "zod/v4/core";

export class ValidationError extends HTTPException {
  public readonly target: keyof ValidationTargets;
  public readonly cause: z.$ZodError;

  public constructor(target: keyof ValidationTargets, zodError: z.$ZodError) {
    const body = {
      message: `Failed to parse or validate ${target}`,
      error: {
        target,
        pretty: z.prettifyError(zodError),
        issues: zodError.issues,
      },
    };

    const res = new Response(JSON.stringify(body), {
      status: 400,
      headers: {
        "content-type": "application/json",
      },
    });

    super(400, {
      message: body.message,
      res,
      cause: zodError,
    });

    this.target = target;
    this.cause = zodError;
  }
}

/**
 * Custom zValidator with our error formatting.
 */
export const zv = <
  T extends z.$ZodType,
  Target extends keyof ValidationTargets,
>(
  target: Target,
  schema: T,
) =>
  zValidator(target, schema, (result) => {
    if (!result.success) {
      throw new ValidationError(target, result.error);
    }
  });
