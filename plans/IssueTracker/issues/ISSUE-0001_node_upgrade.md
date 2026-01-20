# ISSUE-0001: Upgrade Node.js Environment to 20.x+

## Context / Problem

The current environment is running Node.js **18.19.1**. However, the project's dependencies (Next.js 16/19) and the specific version of `next lint` require Node.js **>=20.9.0**. This mismatch is currently blocking the execution of the CI/CD linting phase.

## Current Evidence

- `plans/Issues/ISSUE_001_node_upgrade.md`: Explicitly identified during audit.
- `plans/SRS/11_acceptance_criteria.md`: Requirement for lint-clean code is blocked.
- `plans/Tests/LATEST_RESULTS.md`: Warns about Node version mismatch.

## Proposed Fix / Tasks

- Upgrade Node.js version to at least 20.9.0 (LTS preferred).
- Verify `npm run lint` executes without environment errors.
- Update `package.json` engines field if necessary.

## Acceptance Criteria

- [ ] Environment reports `node --version` >= 20.9.0.
- [ ] `npm run lint` completes without environment error.

## Risks / Notes

- Node version is often controlled by the hosting environment or a tool like `nvm`.

## References

- `plans/Issues/ISSUE_001_node_upgrade.md`
- `plans/Tests/LATEST_RESULTS.md`

## Metadata

- **labels**: type:devops, priority:P1, status:Blocked, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Blocked
- **status_reason**: Blocked by host environment node version (currently 18.x).
