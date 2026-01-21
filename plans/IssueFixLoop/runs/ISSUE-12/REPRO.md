# REPRO: Docker Non-Root User Execution

## Context

The baseline audit reported that the Docker container runs as root, posing a security risk.

## Current State Investigation

Checking the `Dockerfile`:

```dockerfile
14: # Change ownership to the non-root 'node' user defined in the base image
15: # This ensures the user has permission to write to /app (needed for next.js)
16: RUN chown -R node:node /app
17: 
18: # Switch to non-root user
19: USER node
```

## Observation

The `Dockerfile` currently contains the `USER node` instruction. However, the `BASELINE_REPORT.md` still lists this as a gap, and the `docker-compose.yml` does not specify a user, which might lead to confusion if the image is overridden or if the host permissions conflict with the bind mount.

## Conclusion

The fix is present in the `Dockerfile` but needs verification and potentially a corresponding update to the documentation/report to reflect the secured state.
