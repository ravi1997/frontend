# 05. Data Model & API

## 1. Core Entities

### User

```dart
class User {
  final String id;
  final String username;
  final String email;
  final List<String> roles; // ['admin', 'creator', 'employee', 'general']
  final String userType;
  final String? employeeId;
  final String? mobile;
}
```

### Dashboard

```dart
class Dashboard {
  final String id;
  final String title;
  final String slug;
  final List<WidgetConfig> widgets;
}
```

### Workflow

```dart
class Workflow {
  final String id;
  final String name;
  final String triggerFormId;
  final String? triggerCondition;
  final List<WorkflowAction> actions;
}
```

### Form & Versions

```dart
class Form {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final bool isPublic;
  final String ownerId;
  final DateTime createdAt;
  final List<FormVersion> versions;
}

class FormVersion {
  final String version; // "1.0"
  final List<FormSection> sections;
  final bool isActive;
}

class FormSection {
  final String id;
  final String title;
  final List<Question> questions;
}
```

### Response

```dart
class FormResponse {
  final String id;
  final String formId;
  final Map<String, dynamic> data;
  final DateTime submittedAt;
  final String status; // 'pending', 'analyzed', etc.
}
```

## 2. API Endpoints (Backend Mapping)

| Service | Prefix | Key Routes |
| :--- | :--- | :--- |
| **Auth** | `/auth` | `/login`, `/register`, `/generate-otp`, `/logout` |
| **User** | `/user` | `/status`, `/change-password`, `/users` (Admin) |
| **Dashboard** | `/dashboards` | `/` (List), `/<slug>` (Get) |
| **Workflow** | `/workflows` | `/`, `/<id>` |
| **Form** | `/form` | `/` (CRUD), `/<id>/versions`, `/<id>/responses`, `versions/<v>/activate` |
| **AI** | `/ai` | `/generate`, `/<id>/responses/<id>/analyze` |

## 3. Integration Strategy

- **Client**: `Dio` or `http` package.
- **Base URL**: `/form/api/v1`
- **Auth**: Bearer Token in `Authorization` header.
- **State Management**: `Riverpod` or `Bloc` to handle async API states.
- **Offline**: `Hive` or `Isar` to cache `Form` definitions and queue `FormResponse` submissions.
