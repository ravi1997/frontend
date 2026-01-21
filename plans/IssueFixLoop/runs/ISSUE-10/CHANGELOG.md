# CHANGELOG: Issue #10 - Zero Logic Coverage for Core Hooks

## Added

- **src/test/test-utils.tsx**: Utility `renderWithProviders` for testing hooks with TanStack Query.
- **src/hooks/**tests**/useForm.test.ts**: New functional tests for `useForm` (89.4% coverage).
- **src/hooks/**tests**/useForms.test.ts**: New functional tests for `useForms` (100% coverage).

## Changed

- **src/hooks/**tests**/useAuth.test.ts**: Rewrote to include comprehensive functional tests (100% coverage).
- **vitest.config.mts**: Enabled `v8` coverage provider and included hook directories.

## Infrastructure

- Installed `global-jsdom` to support hook rendering in Node.js environment.
- Installed `@testing-library/dom` for React testing support.
- Configured Vitest to exclude irrelevant directories from coverage reports.
