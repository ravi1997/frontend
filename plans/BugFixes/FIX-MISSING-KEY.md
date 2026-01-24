# Plan - Fix Missing Key Warning in BuilderCanvas

The goal is to resolve the React "key" prop warning in `BuilderCanvas.tsx` when rendering sections.

## Problem

The warning `Each child in a list should have a unique "key" prop` is reported at `BuilderCanvas.tsx:180`. This suggests that `section.id` is either undefined or duplicated for some sections. This likely happens when a form is loaded from the backend, and the backend's section model does not include an `id` field that matches the frontend's expectation.

## Proposed Changes

### 1. Ensure IDs during loading in `src/store/builderStore.ts`

- Update `loadForm` and `loadVersion` to ensure every section and question has a unique `id`.
- If a section or question from the backend is missing an `id`, generate one using `uuidv4()`.

### 2. Verify `SortableContext` children

- Ensure that `SortableContext` only contains children that are intended to be sortable and have stable keys.

## Verification Plan

1. **Unit Test**: Create a test for `builderStore`'s `loadForm` to verify that it adds IDs to sections/questions if they are missing.
2. **Manual Check**: Verify that the console warning disappears when loading a form from the API (if mock data can be provided).
