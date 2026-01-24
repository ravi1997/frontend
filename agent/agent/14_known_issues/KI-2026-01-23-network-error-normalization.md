# Network Error Crash Validation

## Symptoms

User encounters "NetworkError when attempting to fetch resource" (e.g. server down).
If the frontend code expects `error.response` or `error.status` to exist on all API errors, it might crash when accessing these properties on a native `fetch` error.

## Root Cause

Native `fetch` throws a `TypeError` (or similar) when the network is unreachable. This error object lacks the standardized `status` (e.g. 500, 404) and `response` properties that the `request` wrapper manually attaches to 4xx/5xx responses.

## Fix

Normalize unexpected errors (like Network Errors) in the `catch` block of `src/lib/api.ts`.
Assign default `status: 0` and a mock `response` object if they are missing.

```typescript
    // Normalize Network Errors (missing status/response)
    if (!error.response) {
      error.status = error.status || 0;
      error.statusText = error.statusText || 'Network Error';
      error.response = {
        data: { message: error.message || 'Network Error' },
        status: error.status,
        statusText: error.statusText
      };
    }
```

## Verification

Run `src/lib/api.test.ts`.
It verifies that a rejected promise from `fetch` yields an error structure with `status: 0` and `response.status: 0`.
