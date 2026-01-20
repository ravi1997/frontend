# SRS: Functional Requirements

## 1. Authentication & Security

| ID | Requirement | Description | Status |
| --- | --- | --- | --- |
| FR-AUTH-01 | Email/Password Login | Standard email-based authentication. | Implemented |
| FR-AUTH-02 | Mobile/OTP Login | OTP-based authentication for mobile accessibility. | Implemented |
| FR-AUTH-03 | Registration | Self-service registration for new users. | Implemented |
| FR-AUTH-04 | User Status | Endpoint to verify session validity and user details. | Implemented |

## 2. Form Builder

| ID | Requirement | Description | Status |
| --- | --- | --- | --- |
| FR-BLDR-01 | Drag-and-Drop | Interactive UI to add/reorder fields using `@dnd-kit`. | Implemented |
| FR-BLDR-02 | Field Types | Support for Text, Choice, Date, File, and Rating types. | Implemented |
| FR-BLDR-03 | Sections | Ability to group questions into logical sections. | Implemented |
| FR-BLDR-04 | Properties Panel | Real-time editing of field labels, placeholders, and rules. | Implemented |
| FR-BLDR-05 | Conditional Logic | Visual builder for "Show/Hide" logic based on answers. | Missing |
| FR-BLDR-06 | Versioning | Save and restore previous versions of a form. | Partial |

## 3. Data Management

| ID | Requirement | Description | Status |
| --- | --- | --- | --- |
| FR-DATA-01 | Response Grid | Sortable/Filterable table of all form submissions. | Implemented |
| FR-DATA-02 | Response Export | Export data to CSV or JSON formats. | Missing |
| FR-DATA-03 | Analytics Dashboard | Visual charts showing submission trends and stats. | Partial |

## 4. Advanced Features

| ID | Requirement | Description | Status |
| --- | --- | --- | --- |
| FR-ADV-01 | AI Assistant | AI chat to help generate form fields from descriptions. | Missing |
| FR-ADV-02 | PWA Support | Offline capabilities and installable home screen icon. | Missing |
