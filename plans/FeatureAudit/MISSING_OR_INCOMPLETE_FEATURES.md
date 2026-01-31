# Missing or Incomplete Features

## 1. Critical Missing Features (Blocking v1.0)

### Form Versioning (FR-FORM-02)

- **Gap**: There is no mechanism to save "snapshots" of form structures. Editing a form overwrites the current structure for all users.
- **Impact**: Inability to manage breaking changes in forms without losing historical data integrity.

### QR Code Distribution (FR-DIST-02)

- **Gap**: The planned QR code generation for public forms is absent.
- **Impact**: Reduced usability for physical location form entry.

## 2. Incomplete / Stubbed Features

### Workflows (FR-WF-01)

- **Status**: UI Only.
- **Gap**: The "Save" action only prints to console. There is no logic engine or backend integration to trigger emails/webhooks on submission.

### Login OTP (FR-AUTH-02)

- **Status**: Missing.
- **Gap**: Only Email/Password login is implemented. Mobile number collection exists but OTP verification flow is missing.

## 3. High-Priority Tech Debt

### Offline Sync Engine (FR-OFFL-03)

- **Gap**: Lack of a `LocalSubmissionRepository` and background sync worker. Submissions failed due to 503/404 are lost.

### AI Integration (FR-AI-01/02)

- **Gap**: `.env.local` contains LLM keys, but no `AiRepository` or prompt-to-JSON engine has been built.
