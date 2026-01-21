# REPRO: Core Hook Refactor & PR Remediation

## Context

The project underwent a core refactor to standardize imports and centralize API endpoints. This was tracked under ISSUE-14.

## Confirmation

Verified that `src/hooks/useAuth.ts` and `src/hooks/useForm.ts` use `@/` aliases and fetch endpoints from `API_ENDPOINTS` in `lib/constants.ts`.
