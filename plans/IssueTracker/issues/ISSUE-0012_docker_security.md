# ISSUE-0012: Docker Non-Root User Execution

## Context / Problem

Current Docker configuration defaults to running as root inside the container, which is a security risk in production environments.

## Current Evidence

- `plans/Architecture/BASELINE_REPORT.md`: "Missing non-root user in execution".

## Proposed Fix / Tasks

- Modify `Dockerfile` to create a `node` or `app` user.
- Change ownership of code directory to the non-root user.
- Update `USER` instruction in `Dockerfile`.

## Acceptance Criteria

- [ ] Running `id` inside the container returns a non-zero UID.

## Risks / Notes

- Potential permission issues with bound volumes.

## References

- `plans/Architecture/BASELINE_REPORT.md`

## Metadata

- **labels**: type:security, priority:P2, status:Backlog, component:infra
- **milestone**: M1 - Core Stabilization & Advanced Builder
- **status**: Backlog
- **status_reason**: Identified as security debt; not yet scheduled.
