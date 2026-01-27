# 01. Functional Requirements

## 1. User Authentication & RBS

- **FR-AUTH-01**: Users shall register with username, email, password, and optional employee ID.
- **FR-AUTH-02**: Users shall login via Email/Password OR Mobile/OTP.
- **FR-AUTH-03**: System shall check roles (Admin, Creator, Employee) for access control.
- **FR-AUTH-04**: Admins shall manage users (Lock, Unlock, Reset OTP).

## 2. Form Builder & Versioning

- **FR-FORM-01**: Creators can create forms with Title, Slug, and Description.
- **FR-FORM-02**: System shall support **Form Versioning** (snapshotting structures as v1.0, v1.1).
- **FR-FORM-03**: Creators can activate specific versions for public use.
- **FR-FORM-04**: Creators can clone existing forms.
- **FR-FORM-05**: Editors can reorder sections and questions.
- **FR-FORM-06**: Editors can import options via CSV.

## 3. Form Distribution

- **FR-DIST-01**: Generate a shareable public link for forms.
- **FR-DIST-02**: Support for QR code generation for quick access.

## 4. Response Management

- **FR-RESP-01**: User shall see a list of all submissions for a form.
- **FR-RESP-02**: Support for filtering and searching responses.
- **FR-RESP-03**: Export responses to CSV/Excel format.

## 5. Analytics & AI

- **FR-AI-01**: Users can generate form structures using AI prompts (e.g. "Job Application").
- **FR-AI-02**: System shall analyze responses for Sentiment and PII.
- **FR-AI-03**: System shall moderate content (Profanity, Injection).
- **FR-DASH-01**: Admins can create custom Dashboards with widgets.
- **FR-DASH-02**: Users can view assigned Dashboards.

## 6. Workflows

- **FR-WF-01**: Admins can define workflows triggered by form submissions.
- **FR-WF-02**: Workflows can execute logic based on Python relational expressions.

## 6. Offline Mode & Sync

- **FR-OFFL-01**: Forms should be downloadable for offline use.
- **FR-OFFL-02**: Submissions made offline should be stored locally (SQLite/Hive).
- **FR-OFFL-03**: Automatic background synchronization when the device regains internet connection.
