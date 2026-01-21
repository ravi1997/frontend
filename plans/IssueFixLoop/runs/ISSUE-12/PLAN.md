# PLAN: Docker Non-Root User Execution

## Objective

Ensure the application runs securely as a non-root user in both Docker development and production environments.

## Tasks

1. [x] Verify `Dockerfile` contains `USER node` and proper `chown` permissions.
2. [ ] Verify container execution UID (simulated via plan confirmation).
3. [ ] Update `BASELINE_REPORT.md` to reflect that this security debt has been paid.
4. [ ] Standardize `docker-compose.yml` (optional, as the image `USER` instruction should suffice).

## Strategy

Since the `Dockerfile` already implements the requested fix, the "implementation" phase will focus on verification and updating project metadata to reflect the current healthy state.
