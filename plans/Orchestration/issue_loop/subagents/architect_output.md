# Sub-Agent Output: Architect

- **Status**: COMPLETE
- **Role**: Architect
- **Task**: Define pipeline structure.

## Design Decisions

- **CI Provider**: GitHub Actions (as per issue requirements).
- **Triggers**: `push` and `pull_request` on `main` branch.
- **Node Version**: Use `actions/setup-node@v4` with `node-version: 20` (to avoid the 18.x blocker).
- **Jobs**:
  - `lint`: Run `npm run lint`.
  - `test`: Run `npm run test:unit`.
  - `docker`: Run a sanity build of the Docker image.

## Pipeline Flow

1. Install dependencies (`npm install`).
2. Parallel jobs for quality checks.
3. Finish with aggregate status.
