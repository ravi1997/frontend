# API Client Architecture Diagram

## High-Level Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                           Flutter Application Layer                         │
│                                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │    Auth      │  │    Forms     │  │  Responses   │  │  Dashboard   │   │
│  │   Feature    │  │   Feature    │  │   Feature    │  │   Feature    │   │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘   │
│         │                 │                  │                  │           │
└─────────┼─────────────────┼──────────────────┼──────────────────┼───────────┘
          │                 │                  │                  │
          └─────────────────┼──────────────────┼──────────────────┘
                            │                  │
                            ▼                  ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                          API Service Layer                                  │
│                         (api_service.dart)                                  │
│                                                                              │
│  Type-safe methods for all backend endpoints:                               │
│  • login(), register(), logout()                                            │
│  • listForms(), getForm(), createForm(), updateForm()                       │
│  • submitResponse(), listResponses(), exportResponses()                     │
│  • getDashboardStats(), getAnalytics()                                      │
│                                                                              │
└──────────────────────────────────┬─────────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                      API Client Wrapper Layer                               │
│                    (api_client_wrapper.dart)                                │
│                                                                              │
│  HTTP method abstractions:                                                  │
│  • get<T>(path, options)                                                    │
│  • post<T>(path, data, options)                                             │
│  • put<T>(path, data, options)                                              │
│  • delete<T>(path, options)                                                 │
│                                                                              │
└──────────────────────────────────┬─────────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         Dio HTTP Client Layer                               │
│                          (api_client.dart)                                  │
│                                                                              │
│  Configuration:                                                              │
│  • Base URL: http://localhost:5000/form/api/v1                             │
│  • Timeouts: 15s connect, receive, send                                     │
│  • Headers: JSON content-type, accept                                       │
│                                                                              │
└──────────────────────────────────┬─────────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         Interceptor Chain                                   │
│                      (Executed in Order)                                    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  1. Retry Interceptor (retry_interceptor.dart)                       │  │
│  │     • Detects network/server errors                                  │  │
│  │     • Retries with exponential backoff (1s, 2s, 4s)                  │  │
│  │     • Max 3 retries                                                   │  │
│  │     • Only retries transient errors (timeouts, 5xx)                  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                   ↓                                          │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  2. Auth Interceptor (auth_interceptor.dart)                         │  │
│  │     • Adds JWT token to request headers                              │  │
│  │     • Detects 401 Unauthorized responses                             │  │
│  │     • Refreshes token using refresh token                            │  │
│  │     • Retries original request with new token                        │  │
│  │     • Handles concurrent refresh (prevents multiple refreshes)       │  │
│  │     • Redirects to login on refresh failure                          │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                   ↓                                          │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  3. Error Interceptor (error_interceptor.dart)                       │  │
│  │     • Converts errors to user-friendly messages                      │  │
│  │     • Shows snackbar notifications                                   │  │
│  │     • Handles different error types (timeout, no internet, etc.)     │  │
│  │     • Skips 401 errors (handled by AuthInterceptor)                  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                   ↓                                          │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  4. Logging Interceptor (LogInterceptor - Dio built-in)             │  │
│  │     • Logs request URL, method, headers, body                        │  │
│  │     • Logs response status, headers, body                            │  │
│  │     • Logs errors with details                                       │  │
│  │     • Pretty printing with colors                                    │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└──────────────────────────────────┬─────────────────────────────────────────┘
                                   │
                                   ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                         Backend API Server                                  │
│                   http://localhost:5000/form/api/v1                         │
│                                                                              │
│  Endpoints:                                                                  │
│  • /auth/login, /auth/register, /auth/logout                               │
│  • /forms, /forms/:id, /forms/:id/publish                                  │
│  • /responses, /responses/:id                                               │
│  • /analytics, /analytics/dashboard                                         │
│                                                                              │
└────────────────────────────────────────────────────────────────────────────┘
```

## Request Flow Diagram

### Successful Request Flow

```
User Action
    │
    ▼
┌─────────────────────────┐
│  Application Feature    │  (e.g., Load Forms)
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│    API Service          │  apiService.listForms()
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  API Client Wrapper     │  client.get('/forms')
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   Dio HTTP Client       │  Configure request
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Retry Interceptor      │  onRequest: Pass through
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Auth Interceptor       │  onRequest: Add JWT token
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   HTTP Request          │  Send to backend
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   Backend Server        │  Process request
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   HTTP Response 200     │  Return data
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Logging Interceptor    │  Log response
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Return to Application  │  Display data
└─────────────────────────┘
```

### Request with Token Refresh Flow

```
User Action
    │
    ▼
Send Request with Expired Token
    │
    ▼
┌─────────────────────────┐
│  Auth Interceptor       │  Add expired token
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   Backend Server        │  Check token validity
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   HTTP Response 401     │  Token expired
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Auth Interceptor       │  onError: Detect 401
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Refresh Token Request  │  POST /auth/refresh
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Receive New Token      │  Store in TokenService
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Retry Original Request │  With new token
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   HTTP Response 200     │  Success!
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Return to Application  │  Display data
└─────────────────────────┘
```

### Request with Retry Flow

```
User Action
    │
    ▼
Send Request
    │
    ▼
┌─────────────────────────┐
│   Network Timeout       │  Connection lost
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Retry Interceptor      │  onError: Detect timeout
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Wait 1 second          │  Exponential backoff
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Retry Request (1/3)    │  Attempt 1
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   Network Timeout       │  Still failing
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Wait 2 seconds         │  Longer delay
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Retry Request (2/3)    │  Attempt 2
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   HTTP Response 200     │  Success!
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Return to Application  │  Display data
└─────────────────────────┘
```

## Token Storage Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                         Token Management System                             │
└────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────┐
│   TokenService          │
│  (token_service.dart)   │
│                         │
│  • JWT token storage    │
│  • Access token         │
│  • Refresh token        │
│  • Hive integration     │
│  • Token expiry check   │
│  • Riverpod notifier    │
└───────────┬─────────────┘
            │
            ▼
   ┌─────────────────┐
   │   Hive Storage  │
   │  (auth_box)     │
   │                 │
   │  • access_token │
   │  • refresh_token│
   └─────────────────┘
```

## API Endpoints Organization

```
api_endpoints.dart
├── Authentication (8 endpoints)
│   ├── /auth/login
│   ├── /auth/login (OTP)
│   ├── /auth/generate-otp
│   ├── /auth/register
│   ├── /auth/refresh
│   ├── /auth/logout
│   ├── /auth/request-password-reset
│   └── /user/status
│
├── Form Management (10 endpoints)
│   ├── /form/
│   ├── /forms/:id
│   ├── /forms (POST)
│   ├── /forms/:id (PUT)
│   ├── /form/:id (DELETE)
│   ├── /forms/:id/publish
│   ├── /form/:id/clone
│   ├── /forms/:id/versions
│   └── /forms/:id/versions/:version
│
├── Response Submission (6 endpoints)
│   ├── /responses (POST)
│   ├── /responses (GET)
│   ├── /responses/:id (GET)
│   ├── /responses/:id (PUT)
│   ├── /responses/:id (DELETE)
│   └── /responses/export
│
├── Analytics (2 endpoints)
│   ├── /analytics
│   └── /analytics/dashboard
│
├── Template Library (2 endpoints)
│   ├── /templates
│   └── /templates/:id
│
├── Workflows (3 endpoints)
│   ├── /workflows
│   ├── /workflows (POST)
│   └── /workflows/:id (PUT)
│
├── File Upload (2 endpoints)
│   ├── /upload
│   └── /signatures
│
└── Health Check (1 endpoint)
    └── /health
```

## Error Handling Flow

```
┌─────────────────────────┐
│   API Call Fails        │
└───────────┬─────────────┘
            │
            ▼
     ┌──────────────┐
     │ Error Type?  │
     └──────┬───────┘
            │
    ┌───────┴───────────────────────────────┐
    │                                       │
    ▼                                       ▼
┌─────────────┐                     ┌─────────────┐
│ Network     │                     │    401      │
│ Error       │                     │ Unauthorized│
└──────┬──────┘                     └──────┬──────┘
       │                                   │
       ▼                                   ▼
┌─────────────┐                     ┌─────────────┐
│   Retry     │                     │   Refresh   │
│ Interceptor │                     │    Token    │
└──────┬──────┘                     └──────┬──────┘
       │                                   │
       ▼                                   ▼
┌─────────────┐                     ┌─────────────┐
│ Retry 3x    │                     │   Retry     │
│ with delay  │                     │   Request   │
└──────┬──────┘                     └──────┬──────┘
       │                                   │
       └───────────┬───────────────────────┘
                   │
                   ▼
            ┌──────────────┐
            │  Success?    │
            └──────┬───────┘
                   │
         ┌─────────┴─────────┐
         │                   │
         ▼                   ▼
    ┌─────────┐         ┌─────────┐
    │  YES    │         │   NO    │
    │ Return  │         │  Error  │
    │  Data   │         │ Handler │
    └─────────┘         └────┬────┘
                             │
                             ▼
                      ┌─────────────┐
                      │   Show      │
                      │  Snackbar   │
                      └─────────────┘
```

## Component Interactions

```
┌──────────────────────────────────────────────────────────────────┐
│                      Application Layer                            │
│                                                                    │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐ │
│  │   Login    │  │Form Builder│  │  Response  │  │ Dashboard  │ │
│  │   Screen   │  │   Screen   │  │   List     │  │   Screen   │ │
│  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘ │
└────────┼───────────────┼───────────────┼───────────────┼─────────┘
         │               │               │               │
         ▼               ▼               ▼               ▼
┌──────────────────────────────────────────────────────────────────┐
│                       API Service Provider                        │
│                      (Riverpod Integration)                       │
└────────┬───────────────┬───────────────┬───────────────┬─────────┘
         │               │               │               │
         ▼               ▼               ▼               ▼
    [login()]      [createForm()]  [submitResp...]  [getStats()]
         │               │               │               │
         └───────────────┴───────────────┴───────────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │   Dio HTTP Client     │
                    │   + Interceptors      │
                    └───────────┬───────────┘
                                │
                    ┌───────────┴───────────┐
                    │                       │
                    ▼                       ▼
           ┌─────────────────┐    ┌─────────────────┐
           │ Token Storage   │    │  Snackbar       │
           │ Service         │    │  Service        │
           └─────────────────┘    └─────────────────┘
```

## Key Design Principles

### 1. Separation of Concerns
- **API Service**: Business logic and type safety
- **API Client**: HTTP configuration and interceptors
- **Interceptors**: Cross-cutting concerns (auth, retry, error handling)
- **Token Storage**: Security and persistence

### 2. Single Responsibility
- Each interceptor handles one concern
- Each service has a clear purpose
- Clean interfaces between layers

### 3. Dependency Injection
- Riverpod for dependency management
- Easy testing and mocking
- Loose coupling between components

### 4. Error Handling
- Multiple layers of error handling
- User-friendly error messages
- Comprehensive logging

### 5. Security
- JWT token management
- Automatic token refresh
- Secure storage
- No token exposure in logs

## Performance Considerations

### Optimization Techniques
1. **Connection Pooling**: Dio reuses connections
2. **Request Caching**: Can be added via cache interceptor
3. **Concurrent Requests**: Handled efficiently by Dio
4. **Token Refresh**: Prevents concurrent refresh attempts
5. **Retry Logic**: Smart retry only when needed

### Bottlenecks to Watch
1. Network latency (mitigated by retry logic)
2. Token refresh time (handled transparently)
3. Large response payloads (streaming available)
4. Concurrent request limits (Dio handles well)

---

This architecture provides a robust, maintainable, and scalable foundation for API communication in the Flutter application.
