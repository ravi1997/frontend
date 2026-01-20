# ISSUE-0013: Setup GitHub Actions CI/CD Pipeline

## Context / Problem

The project lacks automated testing and deployment pipelines. All checks must currently be run manually.

## Current Evidence

- `plans/Architecture/BASELINE_REPORT.md`: "Missing. No .github/workflows found."

## Proposed Fix / Tasks

- Create `.github/workflows/ci.yml`.
- Add steps for: Linting, Unit Testing, and Docker Build validation.

## Acceptance Criteria

- [ ] Pushing to `main` triggers a GitHub Action.
- [ ] Pipeline results are visible in GitHub UI.

## Risks / Notes

- None.

## References

- `plans/Architecture/BASELINE_REPORT.md`

## Metadata

- **labels**: type:devops, priority:P1, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as a critical infrastructure gap.
