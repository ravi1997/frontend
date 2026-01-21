# Implementation Plan: Workflow Automation (MVP)

## Objectives

- Allow users to define simple workflows (triggers and actions) for a form.
- Support "On Submit" trigger initially.
- Support "Email" and "Slack" actions.

## 1. Schema Updates (`src/types/index.ts`)

- Define `WorkflowTrigger` type ('on_submit').
- Define `WorkflowActionType` type ('email', 'slack', 'webhook').
- Define `IWorkflowAction` interface.
- Define `IWorkflow` interface.
- Update `IForm` to include `workflows: IWorkflow[]`.

## 2. Store Updates (`src/store/builderStore.ts`)

- Add `workflows: IWorkflow[]` to `BuilderState`.
- Add actions:
  - `addWorkflow(workflow: IWorkflow)`
  - `updateWorkflow(id, updates)`
  - `removeWorkflow(id)`

## 3. UI Components (`src/components/form-builder/workflow/`)

- `WorkflowManager.tsx`: A dialog/modal to list and manage workflows.
- `WorkflowEditor.tsx`: Form to edit a single workflow.
  - Title input.
  - Trigger select (disabled/fixed to 'on_submit' for now if only one).
  - Actions list (add/remove actions).

## 4. Integration (`src/app/builder/new/page.tsx`)

- Add a "Workflows" button in the header (next to Preview/Properties).
- Connect it to open the `WorkflowManager` dialog.

## 5. Mock API / Persistence

- Ensure `useForm.ts` (hook) handles the new `workflows` field when saving. (Need to check `src/hooks/useForm.ts` first).

## Context Budget

- Estimated tokens: 4000
