# Current Issue: #43 - ISSUE-0013: Setup GitHub Actions CI/CD Pipeline

- **Issue URL**: <https://github.com/ravi1997/frontend/issues/43>
- **Priority**: P1
- **Status**: Backlog
- **Component**: infra
- **Labels**: type:devops, status:Backlog, priority:P1
- **Issue-Key**: PLAN-14DF82F6

## Problem Description

The project lacks automated testing and deployment pipelines. All checks must currently be run manually.

## Known Evidence

- Missing `.github/workflows` directory.
- `plans/Architecture/BASELINE_REPORT.md` highlights this gap.

## Proposed Fix

- Create `.github/workflows/ci.yml`.
- Add steps for:
  - Linting (Requires Node upgrade if run on 18.x locally, but GHA can use 20.x).
  - Unit Testing (`npm run test:unit`).
  - Docker Build validation.

## Assumptions

- We use GitHub Actions.
- The default branch is `main`.
- We can use Node 20.x in the GHA runner.

## Risks

- Linting might fail if the code has many violations.
- Docker build might fail if the Dockerfile is incomplete.
