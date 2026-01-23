# Functional Requirements

## 1. Authentication & Authorization

- **FR-01**: Users must be able to register as 'General' or 'Employee'.
- **FR-02**: System must support Role-Based Access Control (RBAC) with defined Roles.
- **FR-03**: Support mobile layout and potentially OTP-based login (implied by `mobile` fields).

## 2. Form Builder

- **FR-04**: Drag-and-drop interface for adding fields.
- **FR-05**: Support for multiple field types: Short Text, Email, Mobile, Number, File Upload, Ratings.
- **FR-06**: Ability to organize questions into Sections.
- **FR-07**: Form Versioning (Draft, Published, Archived).
- **FR-08**: Conditional Logic validation (Show/Hide fields based on rules).

## 3. Form Logic & AI

- **FR-09**: AI Assistant to generate form structure from text prompts (Currently Mocked).
- **FR-10**: Client-side validation for required fields and data types.
- **FR-11**: Unique 'Slug' generation for public form access.

## 4. Workflows & Approvals

- **FR-12**: Multi-step approval workflows for form submissions.
- **FR-13**: Automated actions on submit: Email, Slack, Webhook triggers.
- **FR-14**: Expiration dates for forms.

## 5. Analytics & Dashboard

- **FR-15**: Dashboard to view total responses and completion rates.
- **FR-16**: Device breakdown analytics (Mobile vs Desktop).
- **FR-17**: Exportable data (implied requirement for enterprise).
