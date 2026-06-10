# RIDP Frontend Agent Context

Flutter/Dart frontend for the RIDP Form Platform. Use this file as the repo-level operating index.

## Canonical Paths
- Docs: `/home/ravi/workspace/form-builder/docs`
- Backend: `/home/ravi/workspace/docker/apps/form-backend`
- Frontend: `/home/ravi/workspace/frontend`

## How to Work in This Repo
- Use codebase-memory MCP first for code discovery: `search_graph`, `trace_path`, `get_code_snippet`, `query_graph`, `get_architecture`.

## Do This First
- Check whether the task is UI, routing, state, or API-contract related.
- Open the owning feature file before changing shared code.
- Verify whether the backend contract or generated client changed before patching around it.
- Prefer graph discovery to locate the widget/provider/service path before scanning files manually.

## Common Failure Modes
- UI work that ignores backend contract drift.
- State living in widgets instead of Riverpod providers.
- Overbuilding abstractions instead of fixing the actual screen or flow.
- Forgetting to run `flutter analyze` after routing or provider changes.
- Letting API shape changes slip past the generated client boundary.

## Skill Router
- `ridp-frontend-flutter`: UI, routing, state, form rendering, accessibility, frontend tests.
- `ridp-api-contract-sync`: backend/frontend API compatibility, OpenAPI, generated Dart client, auth headers, envelopes.
- `ridp-senior-planner`: architecture, refactors, migration risk, cross-repo planning.
- `ridp-code-review`: reviews, bugs, security, auth, contract drift audits.
- `ridp-testing-strategy`: new tests, flaky tests, widget/golden coverage strategy.
- `ridp-quality-gates`: lint, tests, security, and release readiness.

## UI and State Priorities
- Preserve the existing Flutter architecture and feature-first structure.
- Keep UI logic in widgets and state in Riverpod providers/notifiers.
- Treat backend APIs as the source of truth for auth, permissions, and payload shape.
- When a backend contract changes, update the frontend in the same pass rather than layering a workaround.

## Frontend Safety and Behavior
- Auth supports Bearer and HttpOnly cookie modes; cookie writes require `X-CSRF-TOKEN-ACCESS`.
- Async workflows should surface `202` and `task_id` flows cleanly in the UI.

## Useful Commands
```bash
git status --short
flutter pub get
flutter analyze
flutter test
```

## Verification Gates
- Run `flutter analyze` after routing, provider, or shared widget changes.
- Run `flutter test` for touched widget, provider, or form-flow logic.
- Run `flutter run -d chrome` when you need a quick runtime check of a UI flow.
- Recheck API contracts when backend changes may affect generated models or request payloads.

## Pre-Handoff Checklist
- `git status --short`
- `flutter analyze`
- `flutter test` for touched widgets/providers/flows
- `flutter run -d chrome` for a quick runtime check when the UI changed
- Recheck API contracts if backend payloads or generated models changed

## Handoff Checklist
- Report what you checked.
- Report what you skipped.
- Call out residual risk explicitly.
