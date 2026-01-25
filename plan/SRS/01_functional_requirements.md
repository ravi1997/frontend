# 01. Functional Requirements

## 1. User Authentication
- **FR-AUTH-01**: User shall be able to register with email and password.
- **FR-AUTH-02**: User shall be able to login/logout.
- **FR-AUTH-03**: Support for biometric authentication (FaceID/Fingerprint) on mobile devices.

## 2. Form Builder
- **FR-FORM-01**: User shall be able to create new forms.
- **FR-FORM-02**: User shall be able to add multiple field types (Text, Number, Date, Dropdown, Checkbox).
- **FR-FORM-03**: User shall be able to reorder fields via drag-and-drop.
- **FR-FORM-04**: User shall be able to set validation rules (Required, Min/Max length, Regex).
- **FR-FORM-05**: User shall be able to preview the form in real-time.

## 3. Form Distribution
- **FR-DIST-01**: Generate a shareable public link for forms.
- **FR-DIST-02**: Support for QR code generation for quick access.

## 4. Response Management
- **FR-RESP-01**: User shall see a list of all submissions for a form.
- **FR-RESP-02**: Support for filtering and searching responses.
- **FR-RESP-03**: Export responses to CSV/Excel format.

## 5. Analytics Dashboard
- **FR-ANLT-01**: Visual charts (Bar, Pie, Line) showing submission trends.
- **FR-ANLT-02**: Summary statistics (Total views, Completion rate, Avg time spent).

## 6. Offline Mode & Sync
- **FR-OFFL-01**: Forms should be downloadable for offline use.
- **FR-OFFL-02**: Submissions made offline should be stored locally (SQLite/Hive).
- **FR-OFFL-03**: Automatic background synchronization when the device regains internet connection.
