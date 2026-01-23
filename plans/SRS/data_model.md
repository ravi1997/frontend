# Data Model

## Users

- **IUser**: `id`, `username`, `email`, `role`, `user_type`, `mobile`.

## Forms

- **IForm**: `id`, `slug`, `title`, `workflow`, `approval_steps`.
- **IFormVersion**: snapshot of sections/questions at a specific time.
- **ISection**: `title`, `order_index`, `questions[]`.
- **IQuestion**: `field_type`, `validation_rules`, `logic_rules`.

## Workflows

- **IWorkflow**: Triggers (`on_submit`), Actions (`slack`, `email`).
- **IApprovalStep**: Approver roles, required counts.

## Responses

- **IFormResponse**: `data` (JSON), `status` (pending/approved), `approval_history`.
