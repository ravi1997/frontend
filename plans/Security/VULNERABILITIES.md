# Vulnerability Log

## [VULN-001] Moderate: Prototype Pollution in Lodash

- **ID**: GHSA-xxjr-mmjv-4gpg
- **Severity**: Moderate
- **Status**: CLOSED
- **Remediation**: Upgraded `lodash` via `npm audit fix`.

## [VULN-002] Low: Sensitive Data Logging

- **Severity**: Low
- **File**: `src/app/api/form/[id]/route.ts`
- **Status**: CLOSED
- **Remediation**: Removed `console.log(body)` from the PATCH handler.
