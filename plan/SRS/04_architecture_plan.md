# 04. Architecture Plan

## 1. High-Level Architecture
We will follow **Clean Architecture** principles to ensure the code is testable, maintainable, and independent of external frameworks.

### Layers:
1.  **Presentation Layer**:
    - Widgets: UI components.
    - Controllers/State Notifiers: Manage UI state using **Riverpod**.
2.  **Domain Layer (Pure Dart)**:
    - Entities: Core business models.
    - Use Cases: Business logic/rules.
    - Repository Interfaces: Definitions of data operations.
3.  **Data Layer**:
    - Repositories: Implementations of repository interfaces.
    - DTOs (Data Transfer Objects): JSON parsing.
    - Data Sources: Remote (API) and Local (Hive/SQLite).

## 2. State Management
- **Riverpod**: Used for its compile-time safety, testability, and lack of dependency on the widget tree for provider access.

## 3. Recommended Directory Structure
```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── form_builder/
│   ├── dashboard/
│   └── responses/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## 4. Key Libraries
- `flutter_riverpod`: State management.
- `dio`: HTTP client.
- `go_router`: Declarative routing.
- `freezed`: Code generation for data classes.
- `hive` or `drift`: Local persistence.
- `get_it`: Service locator (optional, can use Riverpod).
