# ISSUE-0002: Missing Vitest Coverage Dependency

## Context / Problem

Total project coverage is currently unmeasurable because the required coverage provider `@vitest/coverage-v8` is missing from the development dependencies.

## Current Evidence

- `plans/Issues/ISSUE_002_vitest_coverage.md`: Identified during testing workflow.
- `plans/Tests/COVERAGE_REPORT.md`: States "Missing tool" for automated reporting.

## Proposed Fix / Tasks

- Install `@vitest/coverage-v8` as a devDependency.
- Configure `vitest.config.mts` to use `v8` as the coverage provider.
- Verify `npm run test:unit -- --coverage` generates a report in `coverage/`.

## Acceptance Criteria

- [ ] `@vitest/coverage-v8` present in `package.json`.
- [ ] `coverage/` directory generated with valid HTML report.

## Risks / Notes

- No significant risks; simple dependency addition.

## References

- `plans/Issues/ISSUE_002_vitest_coverage.md`
- `plans/Tests/COVERAGE_REPORT.md`

## Metadata

- **labels**: type:test, priority:P2, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as missing during test audit; hasn't been started.
