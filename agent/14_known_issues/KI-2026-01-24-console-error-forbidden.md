# Issue: Console Error FORBIDDEN on 403 Responses

## Symptoms

- Console shows a red error: `API Request Error: Error: FORBIDDEN` or similar.
- Stack trace points to `request` in `src/lib/api.ts`.
- Occurs when the backend returns a `403 Forbidden` status (e.g., user is authenticated but unauthorized for a specific action).

## Root Cause

- The `src/lib/api.ts` `request` function catches all request errors.
- It had a condition to skip logging for `401 Unauthorized` errors (which are handled via redirect), but it logged all other errors, including `403 Forbidden`.
- Since `403` is a "handled" state in the application logic (showing an alert to the user), logging it as a generic API error created unnecessary noise and "false alarm" errors in the console.

## Fix

- Updated `src/lib/api.ts` to suppress `console.error` logging for `403` status codes, treating them similarly to `401`.

## Prevention

- When defining global error handlers, consider which status codes represent "normal" application flows (like auth checks) versus actual system failures (like 500s or network errors).
- Suppress logging for status codes that are gracefully handled by UI components.
