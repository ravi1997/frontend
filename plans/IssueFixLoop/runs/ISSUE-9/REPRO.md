# REPRO: Missing Vitest Coverage Dependency

## Context

The project identifies ISSUE-0002 as a missing dependency error where `npm run test:unit -- --coverage` fails because `@vitest/coverage-v8` is not installed.

## Observation

Prior to resolution, attempting to run coverage threw an error about the missing provider.

## Confirmation

Verified that `package.json` was missing `@vitest/coverage-v8` and the `vitest.config.mts` was not configured for coverage.
