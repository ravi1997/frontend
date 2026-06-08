# RIDP Frontend Agent Context

Flutter/Dart frontend for the RIDP Form Platform. Keep this file as the durable index; load task detail from `.agents/skills/<name>/SKILL.md` only when relevant.

## Durable Subagent Orchestration
Prefer the narrowest relevant skill for non-trivial work. Use the specialized `ridp-*` skills when the task clearly matches them, but do not force subagent orchestration for small, local edits.

## Token Discipline
- Keep parent prompts short: objective, constraints, exact files/symbols, and expected output only.
- Use codebase-memory MCP first for code discovery: `search_graph`, `trace_path`, `get_code_snippet`, `query_graph`, `get_architecture`.
- Send subagents one bounded task at a time. Do not bundle discovery, implementation, and verification unless the task is tiny.
- Pass file paths, symbol names, and commands instead of pasting large context blocks.
- Ask subagents to return only the decision, changed files, commands run, and residual risk.
- If work spans frontend and backend, split by repo and keep each prompt repo-local.
- Prefer targeted checks while iterating. Run broad gates only when contracts, auth, tenancy, generated code, or shared infrastructure changed.

## Codex & Antigravity (AGY) Integration

Codex is installed locally at `/usr/bin/codex` and can be leveraged to delegate subtasks, generate/refactor code, or perform automated reviews.

### Bidirectional Master-Worker Orchestration
Codex and Antigravity can operate in a bidirectional loop where Codex acts as the Master architect and Antigravity behaves as the coding agent, or vice versa.

* **Codex as Master**:
  To run Codex in Master mode with full access to execute commands and coordinate progress:
  ```bash
  /usr/bin/codex exec -s danger-full-access - <<'EOF'
  You are the Lead Master Software Architect. Execute the following goals.
  If you need Antigravity to perform a task (e.g., read code, execute tests), run:
  agy --print "Find all references to widget X"
  EOF
  ```

* **Delegating tasks from Codex to Antigravity (AGY)**:
  Within Codex execution, use the `agy` CLI to request help or run sub-commands:
  - `agy --print "Run flutter test on test/widgets/custom_widget_test.dart and return the summary"`
  - `agy --print "Read and explain lib/router.dart"`

* **Delegating tasks from Antigravity to Codex**:
  Run `codex exec` with the prompt as an argument or via stdin:
  - `codex exec "Write a Flutter unit test for the custom grid widget under test/widgets/"`
  - `codex exec --sandbox read-only -o codex_output.md "Explain the structure of routing"`

* **Code Reviews**:
  - `codex review` (runs in the workspace directory)


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
