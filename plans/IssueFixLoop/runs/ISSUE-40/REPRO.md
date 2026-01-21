# Reproduction Report: ISSUE-0010 Form Versioning UI

## Issue Description

Users cannot view or manage form versions.
Backend supports versions, but UI is missing.

## Gap Analysis

1. **Store**: `useBuilderStore` has no concept of `versions` history, only the current `sections` state.
2. **UI**: No "Version History" button or panel in `BuilderOverview` (page.tsx).

## Reproduction

1. Open Builder.
2. Look for "Versions" or "History".
3. **Result**: Not found.
