# Architecture Diagrams

## As-Is Architecture (Current)

The current system is a basic Next.js frontend with authentication and a form builder.

```mermaid
graph TB
    subgraph "Frontend (Next.js)"
        Auth[Auth Module]
        Dash[Dashboard]
        Builder[Form Builder]
        Store[Zustand Store]
        Query[React Query]
    end

    subgraph "Backend (External)"
        API[REST API :5000]
    end

    Auth <--> API
    Dash <--> Query <--> API
    Builder <--> Store
    Builder <--> API
```

## To-Be Architecture (Target)

The target includes AI assistance, workflow automation, and full PWA support.

```mermaid
graph TB
    subgraph "Frontend (Next.js PWA)"
        Auth[Enhanced Auth]
        Dash[Interactive Dashboard]
        Builder[Form Builder + AI Helper]
        Workflow[Workflow Node Editor]
        Store[Unified State Management]
        Query[Optimized Data Fetching]
        Offline[Service Worker & Sync]
    end

    subgraph "Backend (External)"
        API[REST API]
        AI[OpenAI/LLM Gateway]
    end

    Auth <--> API
    Dash <--> Query <--> API
    Builder <--> AI <--> API
    Workflow <--> API
    Offline <--> API
```

## Data Flow: Form Submission (Target)

1. User fills form.
2. Zod validates locally.
3. If offline, Service Worker queues submission.
4. If online, Axios sends to API.
5. Notification sent via Workflow engine.
