# CHANGELOG: Issue #10 - Form Versioning Integration

## Added

- **src/hooks/useVersions.ts**: New hook to fetch form versions from the backend (or fallback to empty array safely).
- **src/components/form-builder/versions/VersionHistoryPanel.tsx**: Integrated `useVersions` hook to fetch data when the panel is opened.

## Fixed

- **UI**: The Version History panel now calls the API instead of relying on empty store state.

## Verified

- **Unit Test**: `src/hooks/__tests__/useVersions.test.tsx` validates the hook correctly fetches and populates the store.
