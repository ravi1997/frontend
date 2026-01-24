# Plan - Fix Version Conflict on Save

The goal is to fix the "Version 1.0 already exists" error when saving changes to an existing form.

## Problem

In `EditBuilderPage` (`src/app/builder/[id]/page.tsx`), the `handleSave` function hardcodes the version number as `'1.0'` when calling `createVersion.mutateAsync`. If a version 1.0 already exists for the form (which it will after the first save), subsequent saves fails with a conflict error.

## Proposed Changes

### 1. Update `handleSave` in `src/app/builder/[id]/page.tsx`

- Retrieve the existing `versions` from the `useBuilderStore`.
- Calculate the next version number.
- If versions exist, get the highest `version_number` and add 1.
- Format the next version as a string (e.g., `(max + 1).toFixed(1)`).

## Verification Plan

1. **Manual Check**: Verify the logic by reviewing the code.
2. **Mock Test**: Create a small utility test or just ensure the increment logic handles empty and non-empty version lists correctly.
