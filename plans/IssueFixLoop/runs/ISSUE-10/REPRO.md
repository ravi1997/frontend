# REPRO: Issue #10 - Versioning Integration

## Issue

The `VersionHistoryPanel` component exists but displays "No history available" because the frontend never fetches versions from the backend.
The `useBuilderStore` has a `versions` array, but nothing populates it.

## Location

- `src/components/form-builder/versions/VersionHistoryPanel.tsx`
- Missing hook for fetching versions.

## Evidence

Code inspection of `src/hooks/useForm.ts` and `src/app/builder/new/page.tsx` shows no `GET /form/:id/versions` call.

## Goal

Implement generic data fetching for form versions and connect it to the store/UI.
