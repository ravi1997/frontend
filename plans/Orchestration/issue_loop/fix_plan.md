# Fix Plan: ISSUE-0013 - Setup GitHub Actions CI/CD Pipeline

- **Branch**: `fix/issue-43-cicd-pipeline`
- **Files Changed**:
  - `.github/workflows/ci.yml`

## Implementation Details

1. Created `.github/workflows/` directory.
2. Added `ci.yml` with the following jobs:
   - `quality`: Installs dependencies, runs `npm run lint`, and `npm run test:unit`.
   - `docker`: Performs a `docker build` to ensure the Dockerfile is valid and remains functional.
3. Specified Node.js version 20 to ensure compatibility with Next.js 16/19 requirements.
4. Used `actions/setup-node` with npm caching to speed up consecutive runs.

## Verification Strategy

- Local: Run `npm run lint` (if node version allowed) and `npm run test:unit`.
- Docker: Run `docker build` locally to verify image creation.
- GitHub: Push to origin and verify the Action triggers and passes.
