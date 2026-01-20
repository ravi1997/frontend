# Architecture Overview

## System Context Diagram

```mermaid
graph TD
    User((User))
    Admin((Admin))
    WebUI[Web Application - Next.js]
    BackendAPI[Backend API]
    Database[(Database - PostgreSQL/Prisma)]
    AuthService[Auth Service - JWT/Cookie]

    User -->|Interacts| WebUI
    Admin -->|Manages| WebUI
    WebUI -->|API Calls| BackendAPI
    BackendAPI -->|Persists| Database
    BackendAPI -->|Validates| AuthService
```

## Module Structure (Frontend)

```mermaid
graph LR
    subgraph "App Layer (Next.js App Router)"
        Routes[Routes / Pages]
        Layouts[Layouts]
        Middleware[Middleware]
    end

    subgraph "Component Layer"
        UI[Radical UI Components]
        FormBuilder[Form Builder Engine]
        Dashboard[Dashboard Widgets]
    end

    subgraph "Logic Layer"
        Hooks[Custom Hooks (useAuth, useForm)]
        Store[State Management (Zustand/Context)]
    end

    subgraph "Service Layer"
        APIClient[Axios/Fetch Client]
        Mappers[Data Transformers]
    end

    Routes --> UI
    Routes --> Hooks
    FormBuilder --> Hooks
    Hooks --> Store
    Hooks --> APIClient
```

## Data Entity Relationship (Simplified)

```mermaid
erDiagram
    USER ||--o{ FORM : creates
    FORM ||--o{ FORM_VERSION : has
    FORM ||--o{ FIELD : contains
    FORM ||--o{ RESPONSE : receives
    FORM_VERSION ||--o{ FIELD : contains
    USER ||--o{ RESPONSE : submits
```
