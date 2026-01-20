# Non-Functional Requirements

## 1. Performance

- **Target**: LCP < 2.5s.
- **Implementation**: Next.js App Router, SSR, Optimization via `next/image` (if used).
- **Status**: Likely met, but no benchmarks performed.

## 2. Accessibility

- **Target**: WCAG 2.1 AA Compliance.
- **Implementation**: Radical UI primitives used which are accessible by defaults.
- **Status**: Partially implemented via framework choices.

## 3. Security

- **Target**: Secure Authentication and Data Handling.
- **Implementation**: JWT with HttpOnly cookies, CSRF protection via SameSite.
- **Status**: Basic security implemented.

## 4. Maintainability

- **Target**: Clean Architecture and Type Safety.
- **Implementation**: TypeScript, Husky (check if exists), ESLint.
- **Status**: TypeScript is used extensively.

## 5. Build & Deployment

- **Target**: Containerized builds.
- **Implementation**: Dockerfile, docker-compose.
- **Status**: Implemented and verified via audit.
