# Feature Specification: Advanced Workflows Engine

## 1. Context & Goal

- **Task ID**: M-14
- **Parent Requirement**: FR-WF-01, FR-WF-02
- **Objective**: To move the Workflow feature from a "UI Stub" to a functional logic bridge that executes actions (Email, Webhook, Slack) upon form submission.

## 2. Technical Design

- **New Files**:
  - `lib/features/form_builder/domain/services/workflow_executor.dart`: Logic engine to process workflows.
  - `lib/features/form_builder/domain/repositories/workflow_repository.dart`: Interface for workflow data.
- **Modified files**:
  - `lib/features/form_builder/presentation/pages/form_preview_page.dart`: Trigger workflows on submission.
- **Dependencies**: None (pure logic + existing dio/riverpod)

## 3. Data Model Changes

- **Schema Updates**: Already added `Map<String, dynamic> workflows` to `BuilderForm`.

## 4. API Contracts (Simulated)

- **Execution**: `POST /responses/<id>/trigger-workflows` (Triggered automatically after submission).

## 5. Acceptance Criteria

- [ ] When a form is "submitted" in preview mode, enabled workflows are processed.
- [ ] If "Email" is enabled, a specific notification logic is ran (simulated with logs/snackbars).
- [ ] If "Webhook" is enabled, a network request is attempted to the configured URL.
- [ ] Users see visual feedback indicating which workflows were triggered.

## 6. Testing Strategy

- **Test Spec**: `plans/FeatureAudit/SPECS/WORKFLOW_TEST_SPEC.md`
- **Unit Tests**: `test/features/form_builder/domain/services/workflow_executor_test.dart`

## 7. Rollback Plan

- Remove the `WorkflowExecutor` call from the submission path.
