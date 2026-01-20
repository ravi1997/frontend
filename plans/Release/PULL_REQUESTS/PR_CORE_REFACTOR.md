# Pull Request: Core Refactor and PR Feedback Fixes

## Description

This PR addresses feedback from the initial code review and implements a series of structural improvements to the frontend core. Key changes include restoring the project's absolute import standards and centralizing API endpoint management.

## Changes

- **Import Standardization**: Reverted relative path imports (`../`) back to absolute alias imports (`@/`) across all major hooks.
- **API Endpoint Centralization**:
  - Added `VERSIONS` endpoint to `API_ENDPOINTS.FORMS` in `constants.ts`.
  - Refactored `useForm.ts` to utilize the new constant instead of hardcoded strings.
- **Type Safety Improvements**:
  - Replaced `any` with `Record<string, string | undefined>` in `useAuth.ts` for credential mapping.
  - Added `AxiosError` typing to error handlers in `useForm.ts`.
- **Logic Cleanup**:
  - Removed unused imports and variables in `BuilderPage` and `FormsPage`.
  - Optimized data normalization in `useForms.ts`.

## Impact

- **Maintainability**: Centralized constants and standardized imports reduce friction for future file movements and endpoint updates.
- **Reliability**: Stronger typing in hooks reduces the likelihood of "undefined" errors during API interactions.

## Testing Performed

- Verified that form creation and versioning still point to the correct endpoints.
- Confirmed that authentication flow continues to work with the new type-safe payload transformation.

## Screenshots (if applicable)

N/A (Logic/Refactor PR)

## Checklist

- [x] All relative imports reverted to `@/`.
- [x] Hardcoded endpoints removed.
- [x] TypeScript errors resolved.
- [x] PR Review feedback addressed.
