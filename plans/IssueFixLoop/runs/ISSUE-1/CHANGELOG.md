# CHANGELOG: Issue #1 - Fix Dependency Conflicts

## Changed

- **package.json**: Updated `jsdom` dependency from `^24.1.3` to `^27.0.0` to resolve peer dependency conflict with `global-jsdom@27.0.0`.

## Verified

- **Install**: `npm install` now runs successfully without `--legacy-peer-deps`.
- **Tests**: All unit tests (`npm run test:unit`) continue to pass with the updated jsdom version.
