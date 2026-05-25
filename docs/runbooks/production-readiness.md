# Production Readiness Runbook

## Required Gates

- Backend CI passes lint, tests, security scan, and OpenAPI export.
- Frontend CI passes analyze, tests, accessibility audit, build, and Docker build.
- Contract compatibility matrix has no Critical or High unresolved issues.
- Tenant isolation and RBAC tests pass for every protected route.
- Backup and restore drill completed in staging.
- Rollback procedure exercised in staging.

## Rollback

1. Disable feature flags for the release.
2. Roll back frontend artifact to previous image/tag.
3. Roll back backend API and worker images together.
4. Do not roll back irreversible migrations; use forward-fix migration unless
   the migration runbook marks a specific version as reversible.
5. Verify `/form/health`, auth login, project form list, and response submit.

## Smoke Tests

- Login and refresh token.
- List projects.
- Create, draft-save, publish, and view a form.
- Submit authenticated and public responses.
- Export responses.
- Check task status.
- Confirm audit log entry and request ID propagation.
