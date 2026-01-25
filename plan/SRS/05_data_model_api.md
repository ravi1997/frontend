# 05. Data Model & API

## 1. Core Entities

### Form
```dart
class FormEntity {
  final String id;
  final String title;
  final String? description;
  final List<FormFieldEntity> fields;
  final DateTime createdAt;
  final bool isPublished;
}
```

### FormField
```dart
class FormFieldEntity {
  final String id;
  final String label;
  final FieldType type; // TEXT, NUMBER, DROPDOWN, etc.
  final bool isRequired;
  final Map<String, dynamic> validationRules;
  final List<String>? options; // For dropdowns/checkboxes
}
```

### Submission
```dart
class SubmissionEntity {
  final String id;
  final String formId;
  final Map<String, dynamic> data; // Mapping fieldId -> response
  final DateTime submittedAt;
  final Location? location; // Optional GPS coordinates
}
```

## 2. API Integration Strategy
- **Base URL**: Shared with the existing Next.js backend.
- **Interceptors**: Use Dio interceptors for:
    - Adding JWT tokens to headers.
    - Global error handling.
    - Logging.
- **Caching**: Implement a repository-level caching strategy where data is fetched from the network and saved to the local DB for offline access.
