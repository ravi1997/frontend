# Console Error: UNAUTHORIZED

## Symptoms

User sees a console error with the message "UNAUTHORIZED" and a stack trace pointing to `src/lib/api.ts`.
This happens when a 401 response is received from the backend.

```text
UNAUTHORIZED
    at request (src/lib/api.ts:78:26)
```

## Root Cause

The `api.ts` file throws an `Error` for any non-OK response.
The global catch block in `request` catches this error, logs it via `console.error`, and then re-throws it.
Since the code also handles 401s (by redirecting to login), logging it as a generic "API Request Error" is redundant and confuses correctly handled behavior with a system error.

## Fix

Suppress `console.error` in `src/lib/api.ts` when `error.status === 401`.

```typescript
  } catch (error: any) {
    // Suppress logging for 401 errors as they are expected/handled
    if (error?.status !== 401) {
      console.error('API Request Error:', error);
    }
    throw error;
  }
```

## Verification

Run `src/lib/api.test.ts` to verify that 401 errors are thrown but NOT logged to console.
