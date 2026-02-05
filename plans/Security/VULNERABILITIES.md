# Vulnerabilities Log

**Last Updated**: 2026-02-04  
**Status**: 8 findings (1 HIGH, 3 MEDIUM, 4 LOW)

---

## HIGH Severity (1)

| ID | Vulnerability | Component | CVSS | Status |
|----|---------------|-----------|------|--------|
| H-001 | Container Running as Root | Docker | 7.5 | OPEN |

**Description**: Docker container runs as root user, increasing risk of container escape and privilege escalation attacks.

**Location**: `Dockerfile:1-24`

**Proof of Concept**:

```dockerfile
# Current (vulnerable)
FROM ubuntu:22.04
# No USER directive - runs as root
```

**Remediation**:

```dockerfile
# Fixed
FROM ubuntu:22.04

# Create non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

# Rest of Dockerfile...
```

**References**:

- OWASP Container Security: Docker
- CIS Docker Benchmark

---

## MEDIUM Severity (3)

| ID | Vulnerability | Component | CVSS | Status |
|----|---------------|-----------|------|--------|
| M-001 | Hardcoded Test Credentials | Python Tests | 6.5 | OPEN |
| M-002 | Outdated Base Image Tag | Docker | 5.3 | OPEN |
| M-003 | Missing Security Context | Docker Compose | 5.0 | OPEN |

### M-001: Hardcoded Test Credentials

**Description**: Multiple test files contain hardcoded username/password combinations that could be accidentally committed or leaked.

**Locations**:

- `test_analytics_integration.py:200`
- `playwright_tests/config.py:136`
- `playwright_tests/login_test.py:36`
- `comprehensive_login_test.py:31`
- `flutter_login_test.py:30`

**Affected Credentials**:

```
Username: admin1@example.com
Password: Singh@1997
```

**Remediation**:

```bash
# Use environment variables
export TEST_USERNAME="admin1@example.com"
export TEST_PASSWORD="[NEW_STRONG_PASSWORD]"
```

```python
# In test files
import os
USERNAME = os.getenv("TEST_USERNAME", "admin1@example.com")
PASSWORD = os.getenv("TEST_PASSWORD", "Singh@1997")  # Default only for local dev
```

### M-002: Outdated Base Image Tag

**Description**: Docker base image uses `ubuntu:22.04` instead of latest LTS or pinned digest.

**Location**: `Dockerfile:2`

**Remediation**:

```dockerfile
# Option 1: Pin to digest
FROM ubuntu:22.04@sha256:abc123...

# Option 2: Use latest LTS
FROM ubuntu:24.04
```

### M-003: Missing Security Context

**Description**: Docker Compose file lacks security context configuration.

**Location**: `docker-compose.yml`

**Remediation**:

```yaml
services:
  app:
    build: .
    security_opt:
      - no-new-privileges:true
    user: "1000:1000"  # Non-root user
```

---

## LOW Severity (4)

| ID | Vulnerability | Component | CVSS | Status |
|----|---------------|-----------|------|--------|
| L-001 | Missing Healthcheck | Docker | 3.7 | OPEN |
| L-002 | No Resource Limits | Docker Compose | 3.5 | OPEN |
| L-003 | Read-Write Volume Mount | Docker Compose | 3.3 | OPEN |
| L-004 | No Multi-stage Build | Docker | 3.0 | OPEN |

### L-001: Missing Healthcheck

**Remediation**:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

### L-002: No Resource Limits

**Remediation**:

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
```

### L-003: Read-Write Volume Mount

**Remediation**: (If write access is not needed)

```yaml
volumes:
  - .:/app:ro
