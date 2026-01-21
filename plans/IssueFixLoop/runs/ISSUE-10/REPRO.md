# REPRO: Zero Logic Coverage for Core Hooks

## Current State

The repository contains three core hooks that handle logic for authentication and form management:

- `src/hooks/useAuth.ts`
- `src/hooks/useForm.ts`
- `src/hooks/useForms.ts`

Existing tests (`src/hooks/__tests__/useAuth.test.ts`) only verify:

1. The hook is a function.
2. The hook returns expected property keys.

### Gaps Identified

- **No Interaction Testing**: Mutations (login, logout, createForm) are not triggered in tests.
- **No Mock API Validation**: Responses from the `api` (axios) are not verified or mocked to trigger success/error paths.
- **No Store Integration Verification**: Success callbacks (onSuccess) that update `zustand` stores are not tested.
- **No Coverage Reporting**: Total functional coverage is near 0%.

## Conclusion

The tests are shallow and do not protect against regressions in business logic.
