# PLAN: Fix Dependency Conflicts

## Objective

Fix `npm install` errors by aligning `jsdom` version with `global-jsdom` requirements.

## Tasks

1. [ ] **Update package.json**: Change `jsdom` version to `^27.0.0` (or matching peer dep).
2. [ ] **Install Dependencies**: Run `npm install` to update `package-lock.json`.
3. [ ] **Verify Tests**: Run `npm run test:unit` to ensure the new jsdom version doesn't break existing tests.
4. [ ] **Close Issue**: Update `LOOP_STATUS.md` removing the blocker.

## Strategy

- Direct edit of `package.json`.
- Standard npm install.
