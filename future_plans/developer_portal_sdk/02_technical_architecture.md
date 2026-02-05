# 02. Technical Architecture - Developer Portal & SDK

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Developer Portal                           │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Documentation UI │  │ Test Console UI  │  │ Marketplace UI │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Portal Backend                               │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Docs Service     │  │ Test Service     │  │ Marketplace   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     SDK Generation                              │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ JS/TS Generator │  │ Python Generator │  │ PHP Generator │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     API Gateway                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Public API       │  │ Developer Auth   │  │ Rate Limiting  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### New Flutter/Web Packages Required

```yaml
dependencies:
  # Developer portal (web)
  flutter_markdown_plus: ^1.0.7  # Existing, extend usage
  highlight: ^0.7.0
  
  # Code examples
  flutter_highlight: ^0.7.0
```

### Domain Services

```dart
class DeveloperPortalService {
  Future<DeveloperAccount> registerDeveloper(RegisterDeveloperDto dto) async {
    final account = DeveloperAccount(
      id: uuid.v4(),
      userId: dto.userId,
      organizationName: dto.organizationName,
      apiKeys: [],
      createdAt: DateTime.now(),
    );
    
    await _developerRepository.save(account);
    await _createDefaultApiKey(account.id);
    return account;
  }
  
  Future<ApiKey> createApiKey(String developerId) async {
    final apiKey = ApiKey(
      id: uuid.v4(),
      developerId: developerId,
      key: _generateApiKey(),
      permissions: dto.permissions,
      createdAt: DateTime.now(),
    );
    
    await _apiKeyRepository.save(apiKey);
    return apiKey;
  }
}

class DocumentationService {
  Future<ApiDocumentation> getDocumentation() async {
    final spec = await _openApiRepository.getSpec();
    
    return ApiDocumentation(
      version: spec.info.version,
      baseUrl: spec.servers.first.url,
      endpoints: _parseEndpoints(spec.paths),
      models: _parseModels(spec.components?.schemas),
      examples: _generateExamples(spec),
    );
  }
  
  Future<SdkPackage> generateSdk(String language) async {
    final spec = await _openApiRepository.getSpec();
    
    switch (language) {
      case 'javascript':
        return await _jsSdkGenerator.generate(spec);
      case 'python':
        return await _pythonSdkGenerator.generate(spec);
      case 'php':
        return await _phpSdkGenerator.generate(spec);
      default:
        throw UnsupportedLanguageException(language);
    }
  }
}

class TestConsoleService {
  Future<ApiResponse> testApiCall(ApiTestRequest request) async {
    // Build HTTP request
    final httpRequest = _buildRequest(request);
    
    // Execute request
    final response = await _httpClient.execute(httpRequest);
    
    // Log test
    await _testLogRepository.save(TestLog(
      id: uuid.v4(),
      developerId: request.developerId,
      request: request,
      response: response,
      timestamp: DateTime.now(),
    ));
    
    return response;
  }
}

class MarketplaceService {
  Future<List<Integration>> getIntegrations({
    String? category,
    String? search,
  }) async {
    return await _integrationRepository.search(
      category: category,
      search: search,
    );
  }
  
  Future<Integration> submitIntegration(SubmitIntegrationDto dto) async {
    final integration = Integration(
      id: uuid.v4(),
      developerId: dto.developerId,
      name: dto.name,
      description: dto.description,
      category: dto.category,
      repositoryUrl: dto.repositoryUrl,
      rating: 0,
      downloads: 0,
      createdAt: DateTime.now(),
    );
    
    await _integrationRepository.save(integration);
    return integration;
  }
}
```

### SDK Generation

```dart
abstract class SdkGenerator {
  Future<SdkPackage> generate(OpenApiSpec spec);
}

class JavaScriptSdkGenerator implements SdkGenerator {
  @override
  Future<SdkPackage> generate(OpenApiSpec spec) async {
    final code = StringBuffer();
    
    // Generate package.json
    code.writeln(_generatePackageJson(spec));
    
    // Generate client class
    code.writeln(_generateClientClass(spec));
    
    // Generate endpoint methods
    for (final path in spec.paths.keys) {
      code.writeln(_generateEndpointMethod(path, spec.paths[path]!));
    }
    
    // Generate types
    for (final schema in spec.components?.schemas?.keys ?? []) {
      code.writeln(_generateType(schema, spec.components!.schemas![schema]!));
    }
    
    return SdkPackage(
      language: 'javascript',
      version: spec.info.version,
      files: {
        'package.json': _generatePackageJson(spec),
        'client.js': code.toString(),
        'types.d.ts': _generateTypeDefinitions(spec),
      },
    );
  }
}

class PythonSdkGenerator implements SdkGenerator {
  @override
  Future<SdkPackage> generate(OpenApiSpec spec) async {
    final code = StringBuffer();
    
    // Generate setup.py
    code.writeln(_generateSetupPy(spec));
    
    // Generate client class
    code.writeln(_generateClientClass(spec));
    
    // Generate endpoint methods
    for (final path in spec.paths.keys) {
      code.writeln(_generateEndpointMethod(path, spec.paths[path]!));
    }
    
    // Generate models
    for (final schema in spec.components?.schemas?.keys ?? []) {
      code.writeln(_generateModel(schema, spec.components!.schemas![schema]!));
    }
    
    return SdkPackage(
      language: 'python',
      version: spec.info.version,
      files: {
        'setup.py': _generateSetupPy(spec),
        'client.py': code.toString(),
        'models.py': _generateModels(spec),
      },
    );
  }
}
```

### Test Console

```dart
class ApiTestConsole {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _headersController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Request configuration
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(labelText: 'URL'),
        ),
        DropdownButton<String>(
          value: _methodController.text,
          items: ['GET', 'POST', 'PUT', 'DELETE'].map((method) {
            return DropdownMenuItem(value: method, child: Text(method));
          }).toList(),
          onChanged: (value) => _methodController.text = value ?? '',
        ),
        TextField(
          controller: _headersController,
          decoration: const InputDecoration(labelText: 'Headers (JSON)'),
        ),
        TextField(
          controller: _bodyController,
          decoration: const InputDecoration(labelText: 'Body (JSON)'),
        ),
        
        // Send button
        ElevatedButton(
          onPressed: () => _sendRequest(),
          child: const Text('Send Request'),
        ),
        
        // Response display
        Expanded(
          child: _buildResponseViewer(),
        ),
      ],
    );
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **Developer Portal**
   - Static site for documentation
   - Interactive API explorer
   - Test console backend
   - Marketplace database

2. **SDK Generation**
   - OpenAPI spec parser
   - Code generators for multiple languages
   - SDK packaging and hosting
   - Version management

3. **Monitoring**
   - Developer usage analytics
   - API usage per developer
   - SDK download statistics
   - Marketplace engagement metrics
