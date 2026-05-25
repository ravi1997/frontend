# ADR 0001: API Contract Source of Truth

Status: Accepted

## Decision

Backend schemas and Flask route metadata are the source of truth for the public
API contract. CI exports and validates `docs/openapi_spec.json`; frontend Dart
clients are generated from that artifact into `lib/generated/api`.

## Consequences

- Any API change must update schemas, Swagger/OpenAPI metadata, contract tests,
  and generated frontend clients.
- Hand-written DTOs may remain as UI/domain models, but transport DTO drift is
  treated as a release blocker.
