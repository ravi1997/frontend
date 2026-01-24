# Issue: API Failed to Fetch due to Redirect (308)

## Symptoms

- `TypeError: Failed to fetch` in browser console.
- Occurs when calling `API_ENDPOINTS.FORMS.LIST` or other collection endpoints.
- Backend logs show `308 PERMANENT REDIRECT`.

## Root Cause

- The Flask/Gunicorn backend enforces trailing slashes for collection routes (e.g., `/form/`).
- The frontend was requesting `/form` (without slash).
- The backend sends a `308` redirect to `/form/`.
- The browser or `fetch` client fails to handle the redirect correctly in the context of CORS or Preflight parameters, resulting in a generic "Failed to fetch".

## Fix

- Identify endpoints requiring trailing slashes (usually collection roots).
- Update `src/lib/constants.ts` to append `/` to these paths.

## Prevention

- Always verify backend route definitions (e.g., `strict_slashes=True` default in Flask).
- Use `curl -v` to check if an endpoint returns a 3xx status.
