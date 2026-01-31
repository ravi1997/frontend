# Recommended Fixes

## 🛠️ Immediate Remediation (Priority: High)

1. **Implement Form Versioning**:
    - Add `version` (String) and `isLatest` (bool) to `BuilderForm`.
    - Create `FormVersionHistory` entity.
    - Update `FormRepository` to fetch specific versions.

2. **Add QR Code Utility**:
    - Integrate `qr_flutter` package.
    - Add a "Show QR Code" button in the Dashboard / Form Share dialog.

3. **Bridge Workflow UI to Logic**:
    - Create `WorkflowRepository`.
    - Implement a `SubmissionInterceptor` on the backend (or client-side simulation) that triggers the saved logic.

## 🚀 Future Enhancements (Priority: Medium)

1. **Activate LLM Module**:
    - Develop `AiService` using the keys in `.env.local`.
    - Add "Generate with AI" button in the Form Gallery.

2. **Theming Reconciliation**:
    - Add a Theme Toggle to allow the "Deep Space" Dark Mode to co-exist with the current light theme.

3. **Offline Queue**:
    - Implement `SubmissionQueueService` using Hive to store failed submissions and retry on connectivity restoration.
