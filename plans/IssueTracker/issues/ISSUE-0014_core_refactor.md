# ISSUE-0014: Core Hook Refactor & PR Remediation

## Context / Problem

Core hooks (`useAuth`, `useForm`) required refactoring for architectural consistency (absolute imports) and centralized API endpoint management.

## Current Evidence

- `plans/Release/PULL_REQUESTS/PR_CORE_REFACTOR.md`: Successfully merged refactor.
- `plans/Release/REVIEWS/PR_LOCAL_CHANGES_REVIEW.md`: Original feedback requesting changes.

## Proposed Fix / Tasks

- Revert relative imports to `@/` aliases.
- Centralize API endpoints in `lib/constants.ts`.
- Refine TypeScript types for payload objects.

## Acceptance Criteria

- [ ] PR merged to `main`.
- [ ] Logic stays functional after refactor.

## Risks / Notes

- Completed.

## References

- `plans/Release/PULL_REQUESTS/PR_CORE_REFACTOR.md`

## Metadata

- **labels**: type:feature, priority:P1, status:Done, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Done
- **status_reason**: Merged to main on 2026-01-20.
