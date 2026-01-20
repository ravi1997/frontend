# SRS: Acceptance Criteria

## AC-01: Engineering Foundation

- [ ] Codebase passes `npm run lint` without errors.
- [ ] TypeScript `tsc --noEmit` produces no errors.
- [ ] Docker build succeeds and image starts correctly.

## AC-02: Authentication

- [ ] User can login via Email and redirect to Dashboard.
- [ ] User status is persisted across page refreshes.
- [ ] Logout clears session and redirects to Login.

## AC-03: Form Creation

- [ ] Creator can add at least 3 sections with 5 fields each.
- [ ] Drag-and-drop reordering is preserved upon saving.
- [ ] Form slug is auto-generated and unique.

## AC-04: Testing & Quality

- [ ] Core hooks (`useAuth`, `useForm`) have > 90% unit test coverage.
- [ ] Critical path (Login -> Create Form -> View Responses) is covered by E2E tests.
- [ ] Continuous Integration (CI) blocks merging of PRs with failing tests.
