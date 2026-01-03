export function unwrap<T>(value: T | null | undefined): T {
  if (value == null) {
    throw new Error("Tried to unwrap nullish value");
  }

  return value;
}

export function checkResp(resp: Response) {
  if (!resp.ok) {
    throw new Error(`Response not ok: ${resp.status} ${resp.statusText}`);
  }

  return resp;
}
