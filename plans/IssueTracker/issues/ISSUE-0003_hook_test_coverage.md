# ISSUE-0003: Zero Logic Coverage for Core Hooks

## Context / Problem

The core business logic of the application resides in custom React hooks (`useAuth`, `useForm`, `useForms`), but they currently have **0% functional test coverage**. The existing tests only verify that the hooks are functions.

## Current Evidence

- `plans/Issues/ISSUE_003_hook_test_coverage.md`: Highlighted critical gap.
- `plans/Tests/COVERAGE_REPORT.md`: Estimated 0% coverage on functional logic.

## Proposed Fix / Tasks

- Implement unit tests for `useAuth`: login, register, and session management logic.
- Implement unit tests for `useForm`: createForm, createVersion, and composite save logic.
- Mock all `AXIOS` API calls using `vitest` mocks.
- Achieve >= 80% line coverage for each hook.

## Acceptance Criteria

- [ ] Hooks have passing tests for all happy and unhappy paths.
- [ ] Minimum 80% coverage per hook as reported by Vitest.

## Risks / Notes

- Requires complex mocking of TanStack Query and Axios.

## References

- `plans/Issues/ISSUE_003_hook_test_coverage.md`
- `plans/Tests/COVERAGE_REPORT.md`

## Metadata

- **labels**: type:test, priority:P1, status:Backlog, component:frontend
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as high priority debt; implementation not started.
