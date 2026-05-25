# ADR 0002: Authentication and Tenancy

Status: Accepted

## Decision

Bearer JWT is the primary API authentication mode. `X-Organization-ID` is a
tenant selection hint only; backend authorization must derive valid tenant
membership from authenticated server-side user state and enforce tenant
predicates on every tenant-scoped resource.

## Consequences

- Cookie auth requires a separate CSRF-enabled decision before production use.
- Frontend route guards improve UX but never replace backend RBAC and tenant
  enforcement.
