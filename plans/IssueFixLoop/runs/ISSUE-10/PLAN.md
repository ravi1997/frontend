# PLAN: Versioning Integration

## Objective

Connect the Version History UI to the backend (or mock backend) to display real version history.

## Tasks

1. [ ] **Create Hook**: `src/hooks/useVersions.ts` to fetch versions using React Query.
2. [ ] **Mock API**: Ensure `src/lib/api.ts` or a mock handler can return version data (if backend not ready).
    - Actually, I'll rely on the existing `API_ENDPOINTS.FORMS.VERSIONS`.
3. [ ] **Integration**:
    - Update `VersionHistoryPanel` to call the hook.
    - OR Update `BuilderPage.tsx` to call the hook and populate the store.
    - *Decision*: Update `VersionHistoryPanel` only when opened? Or load all valid versions on form load?
    - *Decision*: Load on form load makes sense for meta-data, but lazy loading on Panel open is better for performance.
    - Let's make `VersionHistoryPanel` fetch data when the dialog opens.
4. [ ] **Tests**: Unit test the hook and the integration.

## Strategy

- Create `useVersions(formId)` hook.
- It returns `{ data: versions, isLoading }`.
- In `VersionHistoryPanel`, verify we have `formId` (might need to get it from params or store).
- If `formId` is missing (new form), history is empty.
