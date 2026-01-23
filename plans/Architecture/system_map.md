# System Architecture Map

## As-Is Architecture

```mermaid
graph TD
    User[User Browser]
    FE[Next.js Frontend (Port 3000)]
    BE[Backend API (Port 5000) - External/Local]
    AI[AI Service (Currently Mocked in FE)]

    User --> FE
    FE -- Axios (REST) --> BE
    FE -- Internal Logic --> AI
```

## To-Be Architecture (Roadmap)

```mermaid
graph TD
    User[User Browser]
    FE[Next.js Frontend]
    BE[Backend API (Python/Node)]
    RealAI[LLM Service Interface]

    User --> FE
    FE --> BE
    BE --> RealAI
```

## Component Breakdown

1. **Frontend**: Next.js App Router, Shadcn UI, Zustand State.
2. **Connectivity**: Axios Interceptors, Bearer Token Auth.
3. **Missing Context**: Backend codebase is not present in this workspace (only `frontend` repo). The API URL defaults to `http://127.0.0.1:5000/form/api/v1`.
