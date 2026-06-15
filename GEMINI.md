# Agent Instructions — Form Builder Frontend

> **Repo**: `/home/ravi/workspace/frontend`
> **Stack**: Flutter · Dart · Riverpod 2.x · Drift (SQLite)

---

## Codebase Knowledge Graph (codebase-memory-mcp)

**ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.**

### Priority Order
1. `search_graph` — find widgets, classes, providers, methods by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific widget/class source code
4. `query_graph` — run Cypher queries for complex patterns
5. `get_architecture` — high-level project summary

### When to fall back to grep/glob
- Searching for string literals, asset paths, localisation keys
- Searching non-code files (pubspec.yaml, analysis_options.yaml)
- When MCP tools return insufficient results

### Examples
```
search_graph(name_pattern=".*FormBuilderController.*")
trace_path(function_name="submitForm", direction="inbound")
get_code_snippet(qualified_name="modules.forms.services.FormBuilderController.submitForm")
```

### Token-Saving Rules
- Use `get_code_snippet` instead of `view_file` for widget/class lookups — saves ~70–90% tokens
- Use `trace_path` instead of grep chains to find callers/callees
- Open a session with `get_architecture(aspects=["modules","patterns","dependencies"])`
- Do NOT read entire files to answer a scoped question; query the graph first

---

## Inbuilt Multi-Agent Pipeline (Mandatory)
You MUST operate as a High-Level Orchestrator. For any task requested by the user, you must automatically:
1. Act as the **Chief Orchestrator** (refer to [00_ORCHESTRATOR.md](file:///home/ravi/workspace/form-builder/docs/agents/00_ORCHESTRATOR.md)).
2. Decompose the request and spawn the specialized subagents (`define_subagent` and `invoke_subagent`) to execute the pipeline:
   - **Researcher** ([01_RESEARCHER.md](file:///home/ravi/workspace/form-builder/docs/agents/01_RESEARCHER.md)) to analyze code context first.
   - **Planner** ([02_PLANNER.md](file:///home/ravi/workspace/form-builder/docs/agents/02_PLANNER.md)) to write a structured implementation blueprint.
   - **Coder** ([03_CODER.md](file:///home/ravi/workspace/form-builder/docs/agents/03_CODER.md)) to apply edits to code.
   - **Tester** ([04_TESTER.md](file:///home/ravi/workspace/form-builder/docs/agents/04_TESTER.md)) to run testing tools and verify.
   - **Writer** ([05_WRITER.md](file:///home/ravi/workspace/form-builder/docs/agents/05_WRITER.md)) to document and generate the final user report.
You must NOT execute micro-tasks directly in the main conversation unless specifically forced. Always delegate and orchestrate.

---

## Ollama Local Execution & Token Optimization (Feasibility Protocol)
To minimize cloud API token usage, you must evaluate if non-code generation sub-tasks can be delegated to the local Ollama instance (available at `http://localhost:11434`).

### 1. Allowed Tasks for Ollama
- **Log & Error Analysis**: Summarizing long test failure logs, build outputs, or trace files.
- **Document & Spec Drafting**: Drafting descriptions, updating developer guides, and translating raw plans to docs.
- **Lint & Static Review**: Searching for structural patterns or verifying lint rules (reading code, not writing it).
- **Embeddings & Search**: Generating embeddings locally using `nomic-embed-text:latest`.

### 2. Prohibited Tasks (Do NOT run on Ollama)
- **Application Code Generation**: All actual code edits, widget implementations, and script generation must be performed by the main agent/subagents using the primary model to ensure precision.

### 3. Feasibility Pre-Evaluation
Before assigning any task to Ollama, run a quick feasibility check:
1. Is it a code generation task? If yes, REJECT local execution.
2. Will it consume more than 20k tokens of context? If yes, check local memory limits (prefer smaller tasks on `qwen3.5:latest` and heavy analysis on `qwen3:30b`).
3. Call the Ollama API locally using `run_command` only for feasible sub-tasks.

---

## Session Startup (Do This First)

1. `manage_adr(mode="get", repo_path="/home/ravi/workspace/frontend")` — load persisted decisions
2. `get_architecture(aspects=["modules","patterns","dependencies"])` — prime structure
3. `detect_changes(repo_path="/home/ravi/workspace/frontend")` — scope to what changed
4. Then use `search_graph` / `get_code_snippet` for targeted lookups


---

## Tool Routing
- **Library / framework docs** → `context7` first (Riverpod, Drift, Flutter), NOT web search or manual reads
- **Recent changes** → `git_diff(repo="...", ref="HEAD~1")` NOT reading individual files
- **Complex or cross-repo tasks** → `sequential-thinking` BEFORE opening any files
- **Debugging a widget call chain** → `trace_path` NOT manual grep chains

---

## Project Structure

| Layer | Path | Notes |
|---|---|---|
| Pages / Screens | `lib/modules/*/pages/` | Top-level route pages |
| Widgets | `lib/modules/*/widgets/` | Feature-specific widgets |
| Controllers / Services | `lib/modules/*/services/` | Riverpod notifiers, business logic |
| Repositories | `lib/modules/*/data/repositories/` | API calls + local cache coordination |
| Shared Models | `lib/shared/models/` | Cross-module data models |
| Networking | `lib/core/networking/` | API client, endpoints |
| Offline Cache | `lib/core/offline/` | Drift SQLite tables |

---

## Engineering Guardrails

### Dynamic Form Components (Critical)
Flutter is compiled to native — runtime Dart execution is impossible.
All dynamic question components must be built from the static `component_schemas` JSON
using the custom **JSON UI Engine**. Never try to generate or inject dynamic Dart code.

### Architecture Rules
- Use **Riverpod 2.x** for all state management; avoid `setState` in complex layouts
- Data fetching → `FutureProvider` or `AsyncNotifierProvider`
- Local/sync operations → Drift service classes exposed via Riverpod `Provider`
- Use `ConsumerWidget` / `ConsumerStatefulWidget` instead of deeply nested `StatefulWidget`
- Follow official Dart Style Guide and enforce with `dart analyze`

### Testing
Write Flutter widget tests to verify dynamic component rendering using mock schemas
**before** implementing new widget types.

### After Every Edit
Run `dart analyze lib/` before considering a task complete. Fix all errors and warnings before closing.

---

## Canonical Cross-Repo Paths
- **Docs**: `/home/ravi/workspace/form-builder/docs`
- **Backend**: `/home/ravi/workspace/docker/apps/form-backend`
- **Frontend**: `/home/ravi/workspace/frontend`
- **API spec**: `/home/ravi/workspace/form-builder/docs/03_API_SPECIFICATION.md`
- **Component schemas**: `/home/ravi/workspace/form-builder/docs/09_COMPONENT_LIBRARY.md`

---

## Common Failure Modes
- Attempting runtime Dart generation → compile error, use JSON UI Engine instead
- Using `setState` for provider-managed state → causes stale UI
- Reading entire `.dart` files instead of using graph snippets → token waste
- Forgetting to update Drift table migrations when changing local schema
- Calling backend API directly from a widget instead of going through repository layer
