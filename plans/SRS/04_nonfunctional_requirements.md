# SRS: Non-Functional Requirements

## 1. Performance

- **NFR-PERF-01**: Average Lighthouse Performance score >= 90.
- **NFR-PERF-02**: Initial page load < 2s on 4G networks.
- **NFR-PERF-03**: Form Builder interactions (drag/drop) must happen within < 100ms.

## 2. Technical Stack

- **NFR-TECH-01**: Framework: Next.js 16 (React 19).
- **NFR-TECH-02**: Language: TypeScript (Strict mode).
- **NFR-TECH-03**: State Management: Zustand + TanStack Query.
- **NFR-TECH-04**: Styling: Tailwind CSS 4.

## 3. Deployment & Scalability

- **NFR-DPL-01**: Containerization: Must build via Docker (`node:20-slim`).
- **NFR-DPL-02**: Standalone Output: Next.js `standalone` mode for minimal image size.
- **NFR-DPL-03**: CI/CD: Automated builds and tests via GitHub Actions.

## 4. Maintainability & Quality

- **NFR-QUAL-01**: Test Coverage: >= 80% for core logic and hooks.
- **NFR-QUAL-02**: Linting: ESLint (next-config) with no errors.
- **NFR-QUAL-03**: Documentation: Architecture diagrams and API contracts kept up to date.
