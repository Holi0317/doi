import { DurableObject } from "cloudflare:workers";

export class TokenRefreshDO extends DurableObject<CloudflareBindings> {}
