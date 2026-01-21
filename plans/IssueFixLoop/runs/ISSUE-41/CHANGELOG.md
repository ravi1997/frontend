# Changelog: ISSUE-0011 Workflow Automation

## Feature

- Implemented **Workflow Automation MVP** for Form Builder.
- Users can now define workflows triggered by form submission.
- Supported actions: Email, Slack, Webhook.

## Code Changes

### `src/types/index.ts`

- Added `IWorkflow`, `IWorkflowAction` interfaces.
- Added `WorkflowTriggerType`, `WorkflowActionType`.
- Updated `IForm` to include `workflows`.

### `src/store/builderStore.ts`

- Added `workflows` to `BuilderState`.
- Added actions: `addWorkflow`, `updateWorkflow`, `removeWorkflow`.

### `src/hooks/useForm.ts`

- Updated `CreateFormPayload` to pass `workflows` to the API.

### `src/components/form-builder/workflow/`

- Created `WorkflowManager.tsx`: Dialog UI for managing workflows.

### `src/app/builder/new/page.tsx`

- Integrated `WorkflowManager` button.
- Updated save logic to include workflows.

### `src/components/ui/dialog.tsx`

- Added Dialog/Modal components wrapper around `@radix-ui/react-dialog`.

## Tests

- Added `src/store/__tests__/builderStore.test.ts`.
