# Threat Model

**Document Date**: 2026-02-04  
**Project**: Flutter Frontend  
**Trust Zone**: Application Boundary

---

## 1. System Overview

### Components

| Component | Type | Trust Level |
|-----------|------|-------------|
| Flutter Mobile App | Client | Medium |
| REST API | Backend | Low |
| Local Storage (Hive) | Data Store | Medium |
| Docker Container | Infrastructure | Low |

### Data Flow Diagram

```
┌─────────────────┐     HTTPS      ┌─────────────────┐
│   Flutter App   │ ─────────────> │   REST API      │
│   (Mobile)      │ <───────────── │   (Backend)     │
└─────────────────┘                └─────────────────┘
        │                                  │
        │ Local Storage                    │
        v                                  │
┌─────────────────┐
│   Hive Store    │
│  (Encrypted)    │
└─────────────────┘
```

---

## 2. Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Application Boundary | Flutter app boundary |
| Network Boundary | HTTPS encryption (TLS 1.2+) |
| Container Boundary | Docker isolation |

---

## 3. Threat Analysis by Component

### A. Flutter Application

| Threat | Severity | Mitigation |
|--------|----------|------------|
| Reverse engineering | MEDIUM | Enable ProGuard/R8 obfuscation |
| Local data theft | MEDIUM | Encrypt Hive store with keychain |
| Certificate pinning bypass | LOW | Implement certificate pinning |
| Debug mode exploitation | LOW | Disable debugging in production |

### B. REST API Communication

| Threat | Severity | Mitigation |
|--------|----------|------------|
| MITM attacks | MEDIUM | Enforce HTTPS, certificate pinning |
| Token theft | MEDIUM | Short-lived JWTs, secure storage |
| API abuse | LOW | Rate limiting, input validation |
| SQL injection | LOW | Parameterized queries (backend) |

### C. Docker Container

| Threat | Severity | Mitigation |
|--------|----------|------------|
| Container escape | HIGH | Run as non-root user |
| Image vulnerabilities | MEDIUM | Scan images, use minimal base |
| Secrets exposure | MEDIUM | Use secret management, not env vars |
| Resource exhaustion | LOW | Set resource limits |

### D. Test Credentials

| Threat | Severity | Mitigation |
|--------|----------|------------|
| Credential leakage | HIGH | Never commit credentials |
| Credential reuse | HIGH | Unique credentials per environment |
| Credential rotation | MEDIUM | Automated rotation policy |

---

## 4. Attack Surface Analysis

### Entry Points

| Entry Point | Protocol | Authentication |
|-------------|----------|----------------|
| Login API | HTTPS | Password/MFA |
| Form Submission | HTTPS | JWT Token |
| Local Storage | File System | Encryption Key |
| Docker Shell | exec | SSH/None |

### Exit Points

| Exit Point | Data Type | Protection |
|------------|-----------|------------|
| API Responses | JSON | HTTPS |
| Analytics | Anonymized | TLS |
| Error Reports | Stack traces | Sanitized |

---

## 5. Risk Matrix

| Threat | Likelihood | Impact | Risk |
|--------|------------|--------|------|
| Container escape | LOW | CRITICAL | HIGH |
| Credential leakage | MEDIUM | HIGH | HIGH |
| MITM attack | LOW | HIGH | MEDIUM |
| Local data theft | LOW | HIGH | MEDIUM |
| API abuse | MEDIUM | LOW | LOW |
| Debug mode exploitation | LOW | MEDIUM | LOW |

---

## 6. Security Controls

### Implemented

| Control | Type | Effectiveness |
|---------|------|---------------|
| HTTPS | Network | ✅ HIGH |
| JWT Authentication | Auth | ✅ HIGH |
| Hive Encryption | Data | ✅ MEDIUM |
| .gitignore | Process | ✅ HIGH |

### Recommended

| Control | Type | Priority |
|---------|------|----------|
| Non-root Docker user | Container | P1 |
| Secret management | Process | P1 |
| Certificate pinning | Network | P2 |
| ProGuard obfuscation | App | P2 |
| Resource limits | Container | P3 |

---

## 7. Compliance Check

| Requirement | Status | Notes |
|-------------|--------|-------|
| No hardcoded secrets | ⚠️ PARTIAL | Test files have credentials |
| Encrypted data at rest | ✅ COMPLIANT | Hive encryption |
| HTTPS only | ✅ COMPLIANT | TLS enforced |
| Principle of least privilege | ⚠️ PARTIAL | Docker runs as root |
| Input validation | ✅ COMPLIANT | Backend responsibility |

---

## 8. Mitigation Roadmap

### Phase 1 (Immediate - Week 1)

1. Run Docker container as non-root user
2. Rotate all test credentials
3. Move credentials to environment variables

### Phase 2 (Short-term - Month 1)

1. Implement certificate pinning
2. Add secret management (Vault/Env vars)
3. Enable ProGuard/R8 for release builds

### Phase 3 (Long-term - Quarter 1)

1. Implement container image scanning
2. Add runtime application self-protection (RASP)
3. Complete threat modeling for new features

---

*Document follows threat_model_template.md from agent/10_security/*
