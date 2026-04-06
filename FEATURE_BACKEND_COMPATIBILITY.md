# Frontend-Backend Gap Analysis

**Analysis Date:** 2026-04-06  
**Backend Documentation:** `/backend-doc/blueprints/`

---

## Summary

This report identifies gaps between the Flutter frontend and backend API by comparing each feature area. Only **unresolved issues** and **missing frontend implementations** are listed.

---

## Gap Analysis Table

| # | Backend Feature | Frontend Status | Gap Description |
|---|-----------------|------------------|-----------------|
| 1 | SMS API (`/sms/*`) | ❌ **Not Implemented** | No SMS feature in frontend |
| 2 | Webhooks API (`/webhooks/*`) | ❌ **Not Implemented** | No webhook management in frontend |
| 3 | Anomaly Detection (`/forms/<id>/detect-anomalies`) | ❌ **Not Implemented** | No anomaly detection UI |
| 4 | Custom Fields API (`/custom-fields/*`) | ❌ **Not Implemented** | No custom field template management |
| 5 | Analytics Trends (`/analytics/trends`) | ⚠️ **Stub** | Backend is stub, but frontend has endpoint |
| 6 | Form Expiry (`/forms/<id>/expire`) | ❌ **Not Implemented** | No form expiration UI |
| 7 | Library API (`/library/*`) | ❌ **Not Implemented** | No form library browsing |
| 8 | Form Views (`/views/*`) | ❌ **Not Implemented** | No saved views feature |
| 9 | View API (`view.md`) | ❌ **Not Implemented** | No view management |
| 10 | Access Control细粒度权限) | ⚠️ **Partial** | Has endpoints but no full UI |
| 11 | Multi-language Form Rendering | ⚠️ **Partial** | Has translations, no language switcher |
| 12 | Dashboard CRUD | ⚠️ **Partial** | Has stats only, no custom dashboards |

---

## Detailed Gap Analysis

### 1. SMS API — NOT IMPLEMENTED

**Backend:** `/form/api/v1/sms/*`
- `POST /sms/single` - Send single SMS
- `POST /sms/otp` - Send OTP via SMS (admin)
- `POST /sms/notify` - Send notification
- `GET /sms/health` - Health check

**Frontend:** No SMS feature exists

**Gap:** No UI for sending SMS, OTPs, or notifications. Users must use external tools.

**Priority:** Low (requires admin role)

---

### 2. Webhooks API — NOT IMPLEMENTED

**Backend:** `/form/api/v1/webhooks/*`
- `POST /webhooks/deliver` - Trigger webhook
- `GET /webhooks/<delivery_id>/status` - View status
- `GET /webhooks/<delivery_id>/history` - View history
- `POST /webhooks/<delivery_id>/retry` - Retry failed
- `POST /webhooks/<delivery_id>/cancel` - Cancel scheduled
- `POST /webhooks/<webhook_id>/test` - Test webhook
- `GET /webhooks/<webhook_id>/logs` - View logs

**Frontend:** No webhook management exists

**Gap:** No UI to configure, test, or monitor webhooks.

**Priority:** Medium (integration feature)

---

### 3. Anomaly Detection — NOT IMPLEMENTED

**Backend:** `/form/api/v1/forms/<form_id>/detect-anomalies`
- Supports: spam, outlier, impossible_value, duplicate detection
- Sensitivity levels: auto, low, medium, high
- Batch scanning support
- Manual threshold override

**Frontend:** No anomaly detection feature

**Gap:** No UI to run anomaly detection on form responses or view flagged responses.

**Priority:** Medium (AI/ML feature)

---

### 4. Custom Fields Library — NOT IMPLEMENTED

**Backend:** `/form/api/v1/custom-fields/*`
- `GET /custom-fields/` - List field templates
- `POST /custom-fields/` - Create field template

**Frontend:** No custom field template management

**Gap:** No UI to create reusable field templates.

**Priority:** Low

---

### 5. Analytics Trends — BACKEND STUB

**Backend:** `/form/api/v1/analytics/trends`
- **Status:** Stub implementation returns empty array
- `GET /trends` returns `{ "trends": [] }`

**Frontend:** Has endpoint `ApiEndpoints.getTrends = '/analytics/trends'`

**Gap:** Frontend calls endpoint but gets empty data. This is a **backend gap**, not frontend.

---

### 6. Form Expiry — NOT IMPLEMENTED

**Backend:** `/form/api/v1/forms/<form_id>/expire`
- `PATCH /forms/<id>/expire` with body `{ "expires_at": string }`
- `GET /forms/expired` - List expired forms

**Frontend:** Has endpoint `ApiEndpoints.expireForm` and `listExpiredForms`

**Gap:** No UI to set form expiration date or view expired forms.

**Priority:** Medium

---

### 7. Library API — NOT IMPLEMENTED

**Backend:** `/form/api/v1/library/*`
- Public library of shared forms

**Frontend:** No library feature

**Gap:** No UI to browse public form library.

**Priority:** Low

---

### 8. Views/Saved Views — NOT IMPLEMENTED

**Backend:** `/form/api/v1/views/*`
- Save and load custom view configurations

**Frontend:** No saved views feature

**Gap:** Users cannot save custom filtered/sorted views of forms or responses.

**Priority:** Low

---

### 9. Access Control — PARTIAL

**Backend:** `/forms/<form_id>/access-control`, `/forms/<form_id>/access-policy`
- Granular permissions: editors, viewers, submitters
- Form visibility, response visibility settings

**Frontend:** 
- Has endpoint: `ApiEndpoints.accessControl` and `ApiEndpoints.accessPolicy`
- UI: Some share dialog exists but not full permission management

**Gap:** No comprehensive UI to manage form-level permissions.

**Priority:** Medium

---

### 10. Multi-language — PARTIAL

**Backend:** Full translation support
- Multiple languages per form
- AI translation jobs

**Frontend:**
- Has translations endpoints
- Has translation UI for form builder

**Gap:** No language switcher in form renderer for end-users to submit in different languages.

**Priority:** Medium

---

### 11. Dashboard CRUD — PARTIAL

**Backend:** `/form/api/v1/dashboards/*`
- `POST /dashboards/` - Create dashboard
- `GET /dashboards/<slug>` - Get dashboard
- `PUT /dashboards/<id>` - Update dashboard

**Frontend:**
- Has analytics stats: `ApiEndpoints.getDashboardStats`
- No custom dashboard creation/management UI

**Gap:** Users cannot create custom dashboards with widgets.

**Priority:** Low

---

## Features Successfully Implemented

These backend features ARE implemented in frontend:

| Feature | Backend Path | Status |
|---------|-------------|--------|
| Authentication | `/auth/*` | ✅ Complete |
| User Management | `/user/*` | ✅ Complete |
| Form Builder | `/forms/*` | ✅ Complete |
| Form Responses | `/forms/{id}/responses` | ✅ Complete |
| Form Export | `/forms/{id}/export/*` | ✅ Complete |
| AI Features | `/ai/*` | ✅ Complete |
| Form Translations | `/forms/translations/*` | ✅ Complete |
| Analytics | `/analytics/dashboard` | ✅ Complete |
| Sections CRUD | `/forms/{id}/sections/*` | ✅ Complete |

---

## Recommendations

### High Priority Gaps

1. **Anomaly Detection** - High-value AI feature
2. **Form Expiry** - Important for workflow management
3. **Access Control UI** - Security feature

### Medium Priority Gaps

4. **Webhooks** - Integration feature
5. **Multi-language Form Rendering** - User experience
6. **SMS API** - Admin tool

### Low Priority Gaps

7. Custom Fields Library
8. Dashboard CRUD
9. Saved Views
10. Form Library

---

## Build Status

```
$ flutter analyze
7 issues (warnings/info only, no errors)
```

No blocking issues remain from the previous compatibility fixes.
