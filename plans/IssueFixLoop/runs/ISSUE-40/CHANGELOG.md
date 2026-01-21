# Changelog: ISSUE-0010 Form Versioning UI

## Feature

- Implemented **Form Versioning UI MVP**.
- Added **Version History Panel** to view and restore previous versions.
- Added **New Version** save action.

## Code Changes

### `src/store/builderStore.ts`

- Added `versions` to state.
- Added `setVersions` and `loadVersion` actions.
- `loadVersion` replaces current sections with the selected version's sections.

### `src/components/form-builder/versions/`

- Created `VersionHistoryPanel.tsx`: Dialog to list versions and restore them.

### `src/app/builder/new/page.tsx`

- Integrated `VersionHistoryPanel` into the header.
- Added "New Version" button (triggers save with prompt).

### Tests

- Added unit tests for version actions in `builderStore.test.ts`.

## Notes

- The `/builder/[id]` route seems to be missing in the codebase (only `/new` exists), so this feature currently only appears on the "New Form" page, where history will initially be empty. Future implementation should apply this to the Edit page.
