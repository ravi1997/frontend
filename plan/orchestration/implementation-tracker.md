# Implementation Tracker

Generated: 2026-05-25

## Phase Status

| Phase | Status | Evidence |
|---|---|---|
| Phase 0 Discovery & Baseline | Completed | Required domain inventories returned; task/dependency graph created |
| Phase 1 Contract Foundation | In progress | Canonical envelopes, OpenAPI export validation, CI fixes, frontend request IDs started |
| Phase 2 Backend/Frontend Alignment | Pending | Blocked on Phase 1 |
| Phase 3 Security & Tenancy | Pending | Blocked on Phase 2 |
| Phase 4 Async & Infrastructure | Pending | Blocked on Phase 3 |
| Phase 5 Frontend Production UX | Pending | Partially parallel after Phase 2 |
| Phase 6 Observability & Reliability | Pending | Partially parallel after infra inventory |
| Phase 7 Testing Completion | Pending | Blocked on implementations |
| Phase 8 Production Readiness | Pending | Blocked on tests/readiness |

## Active Subagents

| Domain | Agent | Status |
|---|---|---|
| Backend API Architecture | Raman | Completed |
| Frontend Architecture | James | Completed |
| OpenAPI & Schema Contracts | Rawls | Completed |
| Authentication & Security | Huygens | Completed |
| RBAC & Tenant Isolation | Lovelace | Completed |
| Async Tasks & Queue Systems | Kuhn | Completed |
| File Upload & Storage | Zeno | Completed |
| DevOps & Infrastructure / CI-CD | Cicero | Completed |
| Database & Migration Design | Mill | Completed |
| Testing & QA | Lagrange | Completed |
| Observability / Performance / Scalability | Locke | Completed |
| Import/Export / Analytics | McClintock | Completed |
| Notifications / Events / Admin Systems | Peirce | Completed |
| Accessibility / UX / Docs / Readiness | Einstein | Running |

## Completed Implementation

- Added canonical backend response envelope fields: `request_id`, structured error object, default error codes, pagination helper.
- Added backend tests for canonical envelopes and OpenAPI spec validation helpers.
- Fixed backend OpenAPI export script to call the real `/form/apispec_1.json` route and validate missing `$ref` definitions.
- Added backend API contract documentation and Dart client generation script.
- Added backend CI workflow with lint, security scan, tests, and OpenAPI export.
- Fixed frontend CI from Node commands to Flutter analyze/test/build.
- Fixed frontend Docker build inputs with valid Flutter image, `.dockerignore`, and Nginx SPA config.
- Added frontend request correlation via `X-Request-ID`.
- Aligned frontend OTP, webhook, NLP, dashboard settings, and project-scoped analytics/export endpoint helpers.
- Added frontend API contract tests for critical endpoint constants and request headers.

## Latest Validation

- Backend focused tests: `tests/test_response_helper.py`, `tests/test_openapi_contract.py`, `tests/test_auth_service.py` passing after auth/app fixture stabilization.
- Frontend focused tests: `test/unit/api_contract_test.dart` passing before latest endpoint assertions; rerun in progress.
- Frontend accessibility gate: `test/accessibility_audit_test.dart` now fails on guideline violations and passes on the audited surface.
- Backend OpenAPI export: `scripts/export_openapi.py` now exports `docs/openapi_spec.json`; remaining debt is replacing temporary placeholder definitions for service-local schemas.
- Frontend form publish/clone now use project-scoped routes and send `Idempotency-Key`.
- Frontend response list/detail/submit controllers and repositories now carry `projectId` and use project-scoped response routes.
- Backend idempotency foundation added with persistent `IdempotencyRecord` and `@require_idempotency`.
- Backend publish/clone mutations now require idempotency.
- Backend permission matrix seed added at `config/permissions.yaml`.
- Backend schema migration runner added with `schema_versions` state tracking, dry-run support, and down migration support.
- Frontend `flutter analyze` passes.
- Latest focused validation:
  - Frontend: `flutter test test/unit/api_contract_test.dart test/unit/model_parsing_test.dart test/accessibility_audit_test.dart` passed.
  - Backend: `pytest tests/test_security_contracts.py tests/test_migration_runner.py tests/test_response_helper.py tests/test_openapi_contract.py tests/test_auth_service.py` passed.

## Open Critical Work

- Full generated Dart client has not been committed; generation script exists.
- Many active frontend repositories still call legacy unscoped `/forms/...` paths.
- RBAC matrix and tenant enforcement coverage are not yet complete.
- Idempotency, durable notifications, DLQ semantics, file metadata/object storage, migration runner, Prometheus metrics, and full E2E/load/security gates remain pending.
- Durable notifications, DLQ semantics, file metadata/object storage, Prometheus metrics, full generated client adoption, and full E2E/load/security gates remain pending.

## Backlog

### Critical
- Normalize form routes around `/projects/{project_id}/forms`.
- Normalize OTP request/verify contracts.
- Add canonical API and error envelopes.
- Generate/validate OpenAPI.
- Add generated frontend DTO workflow.
- Add RBAC matrix and tenant isolation gates.
- Add idempotency for retryable mutations.
- Define task lifecycle contract.

### High
- Harden file uploads and metadata contract.
- Add queue partitioning and DLQ.
- Add observability readiness probes and structured log checks.
- Add frontend route/session/permission guards.
- Add autosave conflict handling.

### Medium
- Add accessibility automation.
- Add preview/staging runbooks.
- Add import/export dry-run validation.
- Add analytics cache freshness contracts.
