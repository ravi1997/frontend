# 02. Technical Architecture - Integration Platform

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     External Integrations                       │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Zapier           │  │ Make             │  │ Custom Apps  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     API Gateway                                │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Rate Limiting    │  │ Authentication   │  │ Routing      │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Application Layer                           │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Webhook Service  │  │ API Service      │  │ SDK Gen      │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Layer                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Webhook Repo     │  │ API Key Repo    │  │ Usage Repo   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### New Flutter Packages Required

```yaml
dependencies:
  # API documentation
  openapi_generator: ^4.12.0
  
  # Webhook testing
  webhook_testing: ^1.0.0
```

### Domain Services

```dart
class WebhookService {
  Future<Webhook> createWebhook(CreateWebhookDto dto) async {
    final webhook = Webhook(
      id: uuid.v4(),
      userId: dto.userId,
      url: dto.url,
      events: dto.events,
      auth: dto.auth,
      active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _webhookRepository.save(webhook);
    return webhook;
  }
  
  Future<void> deliverWebhook(WebhookEvent event) async {
    final webhooks = await _webhookRepository.getByEvent(event.type);
    
    for (final webhook in webhooks) {
      await _deliverWithRetry(webhook, event);
    }
  }
  
  Future<void> _deliverWithRetry(Webhook webhook, WebhookEvent event) async {
    int attempts = 0;
    const maxAttempts = 3;
    
    while (attempts < maxAttempts) {
      try {
        await _httpClient.post(
          webhook.url,
          data: event.payload,
          headers: _buildAuthHeaders(webhook.auth),
        );
        await _webhookRepository.logDelivery(webhook.id, true);
        return;
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          await _webhookRepository.logDelivery(webhook.id, false, error: e);
          return;
        }
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
  }
}

class ApiService {
  Future<ApiResponse> handleRequest(ApiRequest request) async {
    // Rate limiting
    await _rateLimiter.checkLimit(request.apiKey);
    
    // Authentication
    final apiKey = await _authService.validateApiKey(request.apiKey);
    if (apiKey == null) {
      throw UnauthorizedException();
    }
    
    // Check permissions
    if (!await _permissionService.hasPermission(apiKey, request)) {
      throw ForbiddenException();
    }
    
    // Route to handler
    return await _router.route(request);
  }
}
```

### API Gateway

```dart
class ApiGateway {
  final RateLimiter _rateLimiter;
  final AuthService _authService;
  final ApiRouter _router;
  
  Future<ApiResponse> handle(HttpRequest request) async {
    // Extract API key
    final apiKey = request.headers['X-API-Key'];
    
    // Rate limiting
    if (!await _rateLimiter.check(apiKey)) {
      return ApiResponse.tooManyRequests();
    }
    
    // Authentication
    final user = await _authService.authenticate(apiKey);
    if (user == null) {
      return ApiResponse.unauthorized();
    }
    
    // Route request
    return await _router.route(request, user);
  }
}
```

### Webhook Delivery

```dart
class WebhookDeliveryService {
  final HttpClient _httpClient;
  final WebhookLogRepository _logRepository;
  
  Future<void> deliverEvent(WebhookEvent event) async {
    final webhooks = await _webhookRepository.getActiveByEvent(event.type);
    
    final deliveries = webhooks.map((webhook) async {
      try {
        await _httpClient.post(
          webhook.url,
          data: event.toJson(),
          headers: _buildHeaders(webhook.auth),
          timeout: Duration(seconds: 10),
        );
        
        await _logRepository.logSuccess(webhook.id, event.id);
      } catch (e) {
        await _logRepository.logFailure(webhook.id, event.id, e.toString());
      }
    });
    
    await Future.wait(deliveries, eagerError: false);
  }
}
```

## SDK Generation

```dart
class SdkGenerator {
  Future<String> generateJavaScriptSdk(OpenApiSpec spec) async {
    final generator = JavaScriptSdkGenerator(spec);
    return generator.generate();
  }
  
  Future<String> generatePythonSdk(OpenApiSpec spec) async {
    final generator = PythonSdkGenerator(spec);
    return generator.generate();
  }
  
  Future<String> generatePhpSdk(OpenApiSpec spec) async {
    final generator = PhpSdkGenerator(spec);
    return generator.generate();
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **API Gateway**
   - Kong or AWS API Gateway
   - Rate limiting and throttling
   - Request/response transformation

2. **Webhook Service**
   - Message queue for async delivery
   - Retry logic with exponential backoff
   - Dead letter queue for failed deliveries

3. **API Documentation**
   - Swagger UI or Redoc
   - Interactive API explorer
   - Code examples in multiple languages

4. **Monitoring**
   - API usage analytics
   - Webhook delivery metrics
   - Error tracking and alerting
