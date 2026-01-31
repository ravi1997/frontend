# Feature Kickoff: Advanced Workflows Engine

## Name: M-14 - Advanced Workflows Engine

## Linked Task: M-14

## Description

Implement the logic to bridge the Workflow UI with the system's submission flow. This involves:

1. Creating a `WorkflowRepository` to handle workflow configurations.
2. Integrating workflow triggers into the form submission process (currently simulated in Preview mode).
3. Supporting basic logic triggers for Email, Webhook, and Slack notifications based on the saved configuration.

## Implementation Plan

1. **Domain Layer**:
    - Define `WorkflowConfig` entity (if not already covered by the generic map in BuilderForm).
    - Create `WorkflowRepository` interface.
2. **Data Layer**:
    - Implement `MockWorkflowRepository` to handle saving/fetching.
3. **Internal Logic**:
    - Create a `WorkflowService` that "executes" workflows.
    - An "execution" means checking which integrations are enabled and calling the corresponding service (e.g., `EmailService`, `WebhookService`).
4. **Integration**:
    - Hook the `WorkflowService` into the `FormPreviewPage` submission handler.
    - Display "Workflow Triggered" toast/snackbar in the UI when a simulated submission occurs.

## Tests

- [ ] Unit test for `WorkflowService` logic (triggering correct integrations).
- [ ] Integration test: Submitting a form with Email enabled triggers a simulated email call.

## Checkpoints

- [ ] Repository and Service defined.
- [ ] Logic hooked into Submission flow.
- [ ] Linter passing.
- [ ] Tests passing.
