# Sub-Agent Output: Security Auditor

- **Status**: COMPLETE
- **Role**: Security Auditor
- **Task**: Verify requirements and provide security guidelines.

## Requirements

- Running as root is a major security risk (Privilege Escalation).
- The `node` official image comes with a pre-created user named `node` (uid 1000).
- **Recommendation**: Use the existing `node` user instead of creating a new one to keep image size small and logic simple.
- **Critical Step**: Ensure `chown -R node:node /app` is run *before* switching user, so the application has permission to write (e.g., `.next` folder during dev/build).

## Verification Command

`docker run --rm -it <image> id` should output `uid=1000(node) gid=1000(node)`.
