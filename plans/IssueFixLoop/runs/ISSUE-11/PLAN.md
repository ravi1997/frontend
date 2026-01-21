# PLAN: Fix Workflow Manager

## Objective

Fix UI bugs in `WorkflowManager` and verify workflow CRUD functionality.

## Tasks

1. [ ] **Fix JSX Errors**: Remove the comment text and duplicate button in `WorkflowManager.tsx`.
2. [ ] **Verify Remove Workflow**: Ensure `removeWorkflow` stops propagation if needed (UI has `e.stopPropagation` but verifying functionality).
3. [ ] **Unit Tests**: Create `src/components/form-builder/workflow/__tests__/WorkflowManager.test.tsx` (Component test) or `src/store/__tests__/builderStore.test.ts` (Store test already exists, check coverage).
4. [ ] **Integration**: Verify workflows are saved in `useForm` (already verified by code inspection, but a test case in `useForm.test.ts` wouldn't hurt).

## Strategy

- Use `multi_replace_file_content` to clean up `WorkflowManager.tsx`.
- Add test coverage for workflow actions in the store.
