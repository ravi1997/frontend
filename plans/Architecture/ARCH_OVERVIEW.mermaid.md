# Architecture Overview

This document outlines the high-level architecture of the Form Management Platform.

## System Context Diagram

```mermaid
graph TD
    User[Form Creator] -->|Auth/Manage| ClientApp[Next.js App]
    Respondent[Public Respondent] -->|Fill Form| ClientApp
    
    subgraph "Frontend Layer (Next.js)"
        AuthUI[Auth UI]
        DashboardUI[Dashboard UI]
        BuilderUI[Form Builder UI]
        RendererUI[Form Renderer UI]
    end

    subgraph "Backend Layer (Server Actions / API)"
        AuthAPI[Auth Service]
        FormAPI[Form Management Service]
        SubAPI[Submission Service]
        WorkflowAPI[Workflow Engine]
        AIIntegration[AI Generator]
    end

    subgraph "Data Layer"
        DB[(PostgreSQL Database)]
        Redis[(Redis Cache - Optional)]
    end

    ClientApp --> AuthUI
    ClientApp --> DashboardUI
    ClientApp --> BuilderUI
    ClientApp --> RendererUI

    AuthUI -->|NextAuth| AuthAPI
    BuilderUI -->|CRUD| FormAPI
    RendererUI -->|Submit| SubAPI
    DashboardUI -->|Query| FormAPI

    AuthAPI --> DB
    FormAPI --> DB
    SubAPI --> DB
    SubAPI -->|Trigger| WorkflowAPI
    
    BuilderUI -->|Prompt| AIIntegration
```

## Module Definitions

### 1. Authentication Module

- **Responsibility**: Handles user registration, login, session management (JWT/Session), and Role-Based Access Control (RBAC).
- **Key Components**: `NextAuth.js`, `Middleware`, `RoleGuard`.

### 2. Form Builder Module

- **Responsibility**: Provides the WYSIWYG interface for creating forms. Manages form schemas, versioning, and validation rules.
- **Key Components**: `DragDropContext`, `FieldRegistry`, `FormSchemaGenerator`.

### 3. Respondent Interface (Renderer)

- **Responsibility**: Renders the form based on the schema, executes client-side validation (Zod), and handles conditional logic visibility.
- **Key Components**: `FormRenderer`, `LogicEvaluator`, `SubmissionHandler`.

### 4. Workflow Engine

- **Responsibility**: Processes post-submission actions asynchronously. Handles approvals, email notifications, and webhook dispatch.
- **Key Components**: `ApprovalQueue`, `NotificationService`, `WebhookDispatcher`.

### 5. AI Service

- **Responsibility**: Converts natural language prompts into valid Form Schemas.
- **Key Components**: `PromptEngine`, `SchemaMapper`.

## Data Flow (Submission)

1. **Respondent** submits data via `RendererUI`.
2. `SubAPI` validates data against Zod Schema.
3. Data is persisted to `DB`.
4. `WorkflowAPI` is triggered.
5. If **Approval** required -> Status set to `PENDING_APPROVAL`.
6. Else -> Notifications sent, Webhooks fired.
