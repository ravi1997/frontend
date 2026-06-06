# RIDP Frontend Agent Context

Flutter/Dart frontend for the RIDP Form Platform. Keep this file as the durable index; load task detail from `.agents/skills/<name>/SKILL.md` only when relevant.

## Durable Subagent Orchestration
Prefer the narrowest relevant skill for non-trivial work. Use the specialized `ridp-*` skills when the task clearly matches them, but do not force subagent orchestration for small, local edits.

## Codex Integration
Codex is installed locally at `/usr/bin/codex` and can be leveraged to delegate subtasks, generate/refactor code, or perform automated reviews.
- **How to delegate a task**: Run `codex exec` with the prompt as an argument.
- **How to retrieve output**: Use the `-o` option to write the result to a file or capture stdout.
- **How to run code reviews**: Run `codex review` in the workspace directory.

Example commands:
```bash
# Delegate a code modification task non-interactively
codex exec "Write a Flutter unit test for the custom grid widget under test/widgets/"

# Execute a read-only sandboxed task and write output to a file
codex exec --sandbox read-only -o codex_output.md "Explain the structure of routing in this project"

# Run a code review
codex review
```

## Skill Router
- `ridp-frontend-flutter`: UI, routing, state, form rendering, Smart Grid, accessibility, frontend tests.
- `ridp-api-contract-sync`: backend/frontend API compatibility, OpenAPI, generated Dart client, auth headers, response envelopes.
- `ridp-senior-planner`: architecture, multi-step plans, migrations, refactors, risk analysis.
- `ridp-code-review`: reviews, bug hunts, security/tenancy/auth audits.
- `ridp-testing-strategy`: new/failing/flaky tests and coverage strategy.
- `ridp-quality-gates`: final verification, lint/test/security/tooling readiness.

Project MCP defaults are in `.mcp.json`. Use the smallest relevant tool set. Validate agent tooling with `.agents/check-agent-tools.sh` when you need to confirm the local environment.
For promptless report-only verification while another agent edits, run `.agents/watch-ridp-changes.sh`; logs go to `/home/ravi/workspace/.agent-worker-logs`.

## Hard Invariants
- Backend source: `/home/ravi/workspace/docker/apps/form-backend`; API prefix: `/mahasangraha/api/v1/`.
- Generated client `lib/generated/api/` is read-only. Regenerate it from `/home/ravi/workspace/docker/apps/form-backend` with `make openapi && make generate-dart-client`, then copy the generated output back into this repo.
- Auth supports Bearer and HttpOnly cookie modes; cookie writes require `X-CSRF-TOKEN-ACCESS`.
- Role order: `superadmin > admin > manager > user`; enforce UI visibility from roles plus form ACLs, with backend as source of truth.
- Async operations such as publish, clone, bulk export, and translation jobs return `202` with `task_id`.
- Public submit is unauthenticated but only valid for public, published, not expired/scheduled forms.
- Clear-all responses requires typed confirmation and `{ "confirm": "DELETE_ALL" }`.
- Preserve separation of form layout (`form.uiType` / `ui_type`) and section layout (`section.layout`), including Smart Grid auto/manual spans.

## Commands
```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8051
```

If you touch `lib/generated/api/` or backend contract-dependent wrappers, also regenerate the client from the backend repo before handoff.

Before handoff, report checks run, skipped checks, and residual risk.
