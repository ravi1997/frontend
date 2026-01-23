# Threat Model: AI Form Builder

## 1. Scope

The scope of this threat model covers the Next.js Frontend application, the AI Proxy Route (`/api/ai/generate`), and the Mock Authentication system.

---

## 2. Threat Identification (STRIDE)

### Spoofing

- **Threat**: Attacker creates a fake `mock-jwt-token-{id}` to access another user's forms.
- **Countermeasure**: In production, use standard JWT with cryptographic signatures (HS256/RS256).

### Tampering

- **Threat**: User modifies form configuration in transit via proxy intercept.
- **Countermeasure**: Use HTTPS for all communications. Implement server-side validation of form schemas.

### Information Disclosure

- **Threat**: `LLM_API_KEY` is leaked via client-side code.
- **Countermeasure**: The API key is restricted to the **Server Component / API Route**. Verified that no `process.env.LLM_API_KEY` is called in `use client` files.

### Denial of Service

- **Threat**: Attacker spams the AI Assistant to exhaust LLM API credits.
- **Countermeasure**: Implement rate limiting on the `/api/ai/generate` route.

### Elevation of Privilege

- **Threat**: User sets `is_admin: true` in a `PATCH` request to user profile.
- **Countermeasure**: Backend must strictly control which fields are updatable. (Mock DB currently allows full object spread; needs restriction).

---

## 3. Mitigation Summary

- [Secret Leakage] -> Restricted API Key to Server-side.
- [Dependency CVE] -> Update `lodash`.
- [Data Leakage] -> Remove `console.log(body)` from production-bound routes.
