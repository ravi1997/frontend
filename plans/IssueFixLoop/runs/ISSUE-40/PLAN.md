# Implementation Plan: Form Versioning (MVP)

## Objectives

- Allow users to view list of previous versions.
- Allow users to restore (load) a previous version into the editor.
- Allow users to explicitly "Save as New Version" (or clarifying that 'Save' creates a version?).

## 1. Store Updates (`src/store/builderStore.ts`)

- Add `versions: IFormVersion[]` to `BuilderState`.
- Add `setVersions(versions: IFormVersion[])` action.
- Add `loadVersion(version: IFormVersion)` action (sets `sections` to `version.sections`).

## 2. API / Hooks (`src/hooks/useForm.ts`)

- Ensure `useForm` or `useForms` (fetch) populates the store's `versions` when loading a form.
- *Note*: `useForm` currently has `saveNewForm`. We might need `loadForm` logic or check where form data comes from.

## 3. UI Components (`src/components/form-builder/versions/`)

- `VersionHistoryPanel.tsx`: A Sheet or Dialog listing versions.
  - List items: "Version 1.0 - Created [Date]"
  - Action: "Restore" / "Preview" (Preview might be too complex for MVP, just Restore).
  - "Restore" = Load that version's sections into the builder canvas.

## 4. Integration (`src/app/builder/new/page.tsx`)

- Add "History" button in Header.
- Connect to `VersionHistoryPanel`.

## Context Budget

- Estimated tokens: 4000
