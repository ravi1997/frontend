# Sub-Agent Output: Planner

- **Status**: COMPLETE
- **Role**: Planner
- **Task**: Define minimal scope to fix #42 (Docker Non-Root).

## Scope Definition

- Objective: Configure the Docker container to run as a non-root user for security.
- Deliverables:
  - Updated `Dockerfile` with `USER` instruction.
  - Verification that the app runs as non-root.
- Constraints:
  - Must use `node` user (available in standard node images) or create a new one.
  - Must ensure file permissions are correct for the new user.

## Action Plan

1. Modify `Dockerfile`:
    - Create group/user if not exists (checked: `node` image usually has `node` user).
    - `chown` the application directory.
    - Switch `USER node`.
2. Test:
    - Build image.
    - Run container and execute `id`.
