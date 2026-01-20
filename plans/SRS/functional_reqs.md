# Functional Requirements

## 1. Authentication

| ID | Requirement | Status | Note |
| --- | --- | --- |---|
| FR-01 | Login via Email/Password | Implemented | Uses `useAuth` hook and `api.post` |
| FR-02 | Login via Mobile/OTP | Implemented | Uses `generateOtp` and `login` mutations |
| FR-03 | Registration | Implemented | Supports employee self-service |
| FR-04 | Session Management | Implemented | JWT in cookies and localStorage |

## 2. Dashboard

| ID | Requirement | Status | Note |
| --- | --- | --- |---|
| FR-05 | Form Statistics Widget | Implemented | Shows Total/Active forms |
| FR-06 | Recent Forms List | Implemented | Displays recent forms with edit links |
| FR-07 | Create Form Shortcut | Implemented | Button to redirect to builder |

## 3. Form Builder

| ID | Requirement | Status | Note |
| --- | --- | --- |---|
| FR-08 | Drag-and-Drop Editor | Implemented | Uses `@dnd-kit/core` |
| FR-09 | Field Type Library | Implemented | Text, Choice, Date, etc. |
| FR-10 | Properties Panel | Implemented | Context-sensitive settings |
| FR-11 | Form Preview | Partially Implemented | Toggle exists in UI but needs verification of logic |
| FR-12 | Versioning | Missing/Partial | `IFormVersion` exists in types but UI support is unclear |
| FR-13 | Conditional Logic | Missing | No UI found for building expressions |

## 4. Response Management

| ID | Requirement | Status | Note |
| --- | --- | --- |---|
| FR-14 | Response Grid | Implemented | TanStack Table used for display |
| FR-15 | Data Export | Missing | Button exists but backend integration needed |
| FR-16 | Search/Filter | Partially Implemented | Client-side filtering mostly |

## 5. Advanced Features

| ID | Requirement | Status | Note |
| --- | --- | --- |---|
| FR-17 | AI Form Generation | Missing | No code found for AI Chat |
| FR-18 | Workflow Automation | Missing | No React Flow nodes found |
| FR-19 | PWA Support | Missing | No manifest.json or Service Worker |
