# Pull Request: Core Hook Refactor & PR Remediation

## 📋 Description

This PR refactors the core authentication and form-building hooks to improve type safety, consistency, and alignment with project architectural standards. It specifically addresses issues identified in the recent PR review, including regression to relative imports and hardcoded API endpoints.

## 🚀 Changes

- **Refactoring**:
  - Migrated all relative imports (`../`) back to absolute path aliases (`@/`) for consistency.
  - Centralized the `VERSIONS` API endpoint in `src/lib/constants.ts`.
- **Type Safety**:
  - Replaced `any` with `Record<string, unknown>` in `useAuth` login payload for better type narrowing.
  - Added `AxiosError` typing to error handlers in `useForm`.
- **Logic Improvements**:
  - Updated `useForm` to use the centralized `API_ENDPOINTS.FORMS.VERSIONS` helper.
  - Cleaned up syntax in `BuilderPage` catch block.

## 🛠️ Technical Details

- Added `VERSIONS: (id: string) => /form/${id}/versions` to `API_ENDPOINTS.FORMS`.
- Ensured `CreateVersionPayload` correctly includes `version` and `sections` fields.

## ✅ Checklist

- [x] All absolute imports restored.
- [x] Hardcoded endpoints removed.
- [x] TypeScript errors resolved (except where infrastructure is missing).
- [x] Logic verified against SRS requirements.

## 📸 Screenshots / Demos

*(N/A - Logic/Hook changes)*

## 🔗 Related Tasks

- [BACKLOG-001] Core Feature Refactor
- [PR-REVIEW-001] Remediation
