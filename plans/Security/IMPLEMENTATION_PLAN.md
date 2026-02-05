# Security Remediation Implementation Plan

**Created**: 2026-02-04  
**Target Completion**: 2026-03-04  
**Owner**: DevOps / Development Team

---

## Phase 1: Immediate (Week 1)

### 1.1 Rotate Test Credentials

| Task | Details |
|------|---------|
| **Priority** | P1 - Critical |
| **Estimated Effort** | 1 hour |
| **Files Affected** | 5 test files |

**Steps**:

1. Generate new strong password (minimum 16 characters, mixed case, numbers, symbols)
2. Update CI/CD environment variables
3. Update all test files to use environment variables:

```python
# Before (INSECURE)
PASSWORD = "Singh@1997"

# After (SECURE)
import os
PASSWORD = os.getenv("TEST_PASSWORD")
if not PASSWORD:
    raise ValueError("TEST_PASSWORD environment variable not set")
```

**Rollback Plan**: Keep old credentials in a secure location for 7 days before permanent deletion.

---

### 1.2 Fix Docker Root Execution

| Task | Details |
|------|---------|
| **Priority** | P1 - Critical |
| **Estimated Effort** | 2 hours |
| **Files Affected** | `Dockerfile` |

**Steps**:

```dockerfile
# Add before CMD
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
RUN mkdir -p /home/appuser && chown -R appuser:appgroup /home/appuser
USER appuser
```

**Pre-requisites**:

- Ensure build artifacts have correct permissions
- Verify no processes require root access

**Validation**:

```bash
docker build -t frontend:test .
docker run --rm frontend:test whoami  # Should output: appuser
```

---

## Phase 2: Short-term (Weeks 2-3)

### 2.1 Docker Base Image Hardening

| Task | Details |
|------|---------|
| **Priority** | P2 - High |
| **Estimated Effort** | 1 hour |
| **Files Affected** | `Dockerfile` |

**Steps**:

```dockerfile
# Before
FROM ubuntu:22.04

# After - Pin to digest
FROM ubuntu:22.04@sha256:abc123def456...

# Or use specific LTS with digest pinning
FROM ubuntu:22.04@sha256:8a37d68f4f73ebf3d4efafbcf66379bf3728902a80386168f0d2d72d9b24d31
```

**Why**: Prevents "latest tag" hijacking and ensures reproducible builds.

---

### 2.2 Docker Compose Security Context

| Task | Details |
|------|---------|
| **Priority** | P2 - High |
| **Estimated Effort** | 1 hour |
| **Files Affected** | `docker-compose.yml` |

**Steps**:

```yaml
services:
  app:
    build: .
    user: "1000:1000"  # Non-root user UID:GID
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    read_only: true  # If filesystem writes not needed
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=10M
```

---

### 2.3 Add Docker Healthcheck

| Task | Details |
|------|---------|
| **Priority** | P2 - High |
| **Estimated Effort** | 2 hours |
| **Files Affected** | `Dockerfile` |

**Steps**:

```dockerfile
# Add to Dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# If curl not available:
# HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
#   CMD wget -q --spider http://localhost:8080/health || exit 1
```

---

### 2.4 Multi-stage Docker Build

| Task | Details |
|------|---------|
| **Priority** | P3 - Medium |
| **Estimated Effort** | 4 hours |
| **Files Affected** | `Dockerfile` |

**Steps**:

```dockerfile
# Stage 1: Build
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y flutter git
WORKDIR /app
COPY . .
RUN flutter build web --release

# Stage 2: Production
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Benefits**:

- Smaller attack surface (nginx vs Ubuntu)
- No build tools in production
- Faster deployments

---

## Phase 3: Long-term (Month 2)

### 3.1 Secret Management Integration

| Task | Details |
|------|---------|
| **Priority** | P2 - High |
| **Estimated Effort** | 8 hours |
| **Infrastructure** | Vault / AWS Secrets Manager |

**Steps**:

1. Set up HashiCorp Vault or AWS Secrets Manager
2. Create secrets for:
   - API keys
   - Database credentials
   - Third-party service tokens
3. Update CI/CD pipeline to fetch secrets at runtime
4. Remove hardcoded credentials from all files

**Architecture**:

```
┌─────────────────────────────────────────────────────────────┐
│                    CI/CD Pipeline                            │
├─────────────────────────────────────────────────────────────┤
│  1. Fetch secrets from Vault                                │
│  2. Inject via environment variables                        │
│  3. Build application                                       │
│  4. Push to registry                                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes / Docker                       │
│  - Secrets mounted as volumes or environment variables      │
│  - No secrets in container image                             │
└─────────────────────────────────────────────────────────────┘
```

---

### 3.2 Certificate Pinning for Flutter

| Task | Details |
|------|---------|
| **Priority** | P3 - Medium |
| **Estimated Effort** | 4 hours |
| **Files Affected** | `lib/core/network/` |

**Steps**:

```dart
// Add to api_client_wrapper.dart
class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
    ),
  )..interceptors.add(
      CertificatePinningInterceptor(
        sha: ['sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='],
      ),
    );
}
```

---

### 3.3 CI/CD Security Scanning

| Task | Details |
|------|---------|
| **Priority** | P2 - High |
| **Estimated Effort** | 4 hours |
| **Files Affected** | `.github/workflows/` |

**Steps**:

```yaml
# Add to CI/CD pipeline
- name: Security Scan
  run: |
    # Dependency vulnerability scan
    npm audit --production || true
    pip-audit || true
    
    # Secret scanning
    gitleaks detect --source=. || true
    
    # Container scanning
    trivy image frontend:latest || true
```

---

## Resource Requirements

| Phase | Team Members | Estimated Hours |
|-------|--------------|-----------------|
| Phase 1 | DevOps | 4 hours |
| Phase 2 | DevOps | 16 hours |
| Phase 3 | DevOps + Backend | 24 hours |
| **Total** | | **44 hours** |

---

## Success Criteria

| Metric | Target | Measurement |
|--------|--------|-------------|
| Critical vulnerabilities | 0 | Security scan |
| High vulnerabilities | 0 | Security scan |
| Secrets in code | 0 | Gitleaks scan |
| Docker root execution | 0 | Runtime check |
| Dependency CVEs | 0 | npm/dart audit |
| Security score | 90+ | Overall assessment |

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Multi-stage build failure | High | Test thoroughly in staging |
| Secret rotation disruption | Medium | Maintain old secrets for 7 days |
| Performance impact | Low | Benchmark before/after |

---

## Dependencies

| Task | Depends On | Blocking |
|------|-----------|----------|
| 3.1 Secret Management | Infrastructure setup | 2.2, 2.3 |
| 3.2 Certificate Pinning | Backend API support | None |
| 3.3 CI/CD Scanning | GitHub Actions access | None |

---

*Plan created based on security audit findings. Update quarterly.*
