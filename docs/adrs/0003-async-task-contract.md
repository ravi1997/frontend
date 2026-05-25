# ADR 0003: Async Task Contract

Status: Accepted

## Decision

Long-running operations return `202` with `{task_id,status_url}` and expose
state through `GET /form/api/v1/tasks/{task_id}`. Clients must poll with bounded
backoff and show terminal success/failure states.

## Consequences

- Publish, clone, import, export, AI, webhooks, and translation jobs must expose
  task progress or resource-specific job status.
- Queue retry exhaustion must surface through task errors and operator logs.
