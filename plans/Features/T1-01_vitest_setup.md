# Feature Spec: T1-01 Vitest Setup

## Problem

The project has Vitest configured in `package.json` but no tests exist, and the current environment makes it hard to run tests locally due to Node version mismatch.

## Proposed Solution

1. Verify `vitest` installation in the Docker container.
2. Create a basic unit test for `src/hooks/useAuth.ts` to verify the setup.
3. Fix any configuration issues in `vitest.config.ts` (if it exists) or `next.config.ts`.

## Implementation Plan

1. Check for `vitest.config.ts` or `vite.config.ts`.
2. Create `src/hooks/__tests__/useAuth.test.ts`.
3. Implement a mock-based test for the `login` functionality.
4. Run tests via Docker.

## Dependencies

- Docker (Verified)
- Node 20 (Provided by Docker)
