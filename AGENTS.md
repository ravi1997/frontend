# RIDP Frontend Agent Context

Flutter/Dart frontend for the RIDP Form Platform. Keep this file as the durable index; load task detail from `.agents/skills/<name>/SKILL.md` only when relevant.

## Durable Subagent Orchestration
All major coding, planning, reviews, and test runs are delegated to specialized, narrow-context subagents to keep parent model token usage extremely low and optimize context cost. For architecture and operations, see [.agents/skills/ORCHESTRATOR.md](file:///home/ravi/workspace/docker/apps/form-backend/.agents/skills/ORCHESTRATOR.md).

## Skill Router
- `ridp-frontend-flutter`: UI, routing, state, form rendering, Smart Grid, accessibility, frontend tests.
- `ridp-api-contract-sync`: backend/frontend API compatibility, OpenAPI, generated Dart client, auth headers, response envelopes.
- `ridp-senior-planner`: architecture, multi-step plans, migrations, refactors, risk analysis.
- `ridp-code-review`: reviews, bug hunts, security/tenancy/auth audits.
- `ridp-testing-strategy`: new/failing/flaky tests and coverage strategy.
- `ridp-quality-gates`: final verification, lint/test/security/tooling readiness.

Project MCP defaults are in `.mcp.json`. Use the smallest relevant tool set. Validate agent tooling with `.agents/check-agent-tools.sh`.
For promptless report-only verification while another agent edits, run `.agents/watch-ridp-changes.sh`; logs go to `/home/ravi/workspace/.agent-worker-logs`.

## Hard Invariants
- Backend source: `/home/ravi/workspace/docker/apps/form-backend`; API prefix: `/mahasangraha/api/v1/`.
- Generated client `lib/generated/api/` is read-only; regenerate from backend with `make openapi && make generate-dart-client`.
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

Before handoff, report checks run, skipped checks, and residual risk.
