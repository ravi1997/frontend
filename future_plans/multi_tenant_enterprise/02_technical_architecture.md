# 02. Technical Architecture - Multi-Tenant Enterprise Features

## System Architecture Overview

The Multi-Tenant Enterprise Epic introduces comprehensive multi-tenancy to the platform with complete data isolation, SSO integration, advanced RBAC, and audit logging.

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                          │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Tenant Admin UI  │  │ SSO Config UI   │  │ Audit Log UI │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Domain Layer                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Tenant Entity    │  │ SSO Config      │  │ Audit Log    │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Custom Role     │  │ Org Unit         │  │ Permission   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Data Layer                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Tenant Repo      │  │ SSO Repo         │  │ Audit Repo   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Role Repo        │  │ User Repo        │  │ Quota Repo   │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Infrastructure Layer                         │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ SSO Service      │  │ Audit Service    │  │ Policy Engine│ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │ Tenant Context   │  │ Permission Check │  │ Branding     │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Presentation Layer

#### New Flutter Packages Required

```yaml
dependencies:
  # SSO libraries
  flutter_appauth: ^6.0.0
  url_launcher: ^6.2.0
  
  # File handling for bulk operations
  file_picker: ^8.0.0
  
  # CSV parsing
  csv: ^6.0.0  # Existing, extend usage
  
  # Organization chart
  flutter_treeview: ^1.0.0
```

#### New Presentation Components

```dart
// lib/features/enterprise/presentation/pages/
lib/features/enterprise/presentation/pages/
  ├── tenant_administration_page.dart
  ├── sso_configuration_page.dart
  ├── role_management_page.dart
  ├── audit_log_viewer_page.dart
  ├── organizational_units_page.dart
  ├── bulk_user_operations_page.dart
  └── tenant_health_dashboard_page.dart

// Widgets
lib/features/enterprise/presentation/widgets/
  ├── tenant_card_widget.dart
  ├── sso_provider_selector.dart
  ├── permission_checkbox_group.dart
  ├── org_unit_tree_widget.dart
  ├── audit_log_filter_widget.dart
  └── quota_indicator_widget.dart
```

### Domain Layer

#### New Domain Entities

```dart
// lib/features/enterprise/domain/entities/

class Tenant {
  final String id;
  final String name;
  final String slug;
  final String domain;
  final TenantBranding branding;
  final TenantQuotas quotas;
  final TenantSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TenantStatus status;
}

class TenantBranding {
  final String? logoUrl;
  final String? faviconUrl;
  final String primaryColor;
  final String secondaryColor;
  final String? customDomain;
}

class TenantQuotas {
  final int maxUsers;
  final int maxForms;
  final int maxStorageMB;
  final int maxApiCallsPerDay;
  final int maxConcurrentSessions;
}

class SsoConfiguration {
  final String id;
  final String tenantId;
  final SsoType type;
  final Map<String, dynamic> metadata;
  final Map<String, String> attributeMapping;
  final Map<String, String> groupRoleMapping;
  final bool jitProvisioning;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum SsoType { saml2, oidc }

class OrganizationalUnit {
  final String id;
  final String tenantId;
  final String name;
  final OrgUnitType type;
  final String? parentId;
  final List<String> userIds;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum OrgUnitType { department, team }

class CustomRole {
  final String id;
  final String tenantId;
  final String name;
  final String description;
  final Set<String> permissions;
  final List<String> userIds;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class AuditLogEntry {
  final String id;
  final String tenantId;
  final String userId;
  final String action;
  final String resourceType;
  final String resourceId;
  final Map<String, dynamic>? before;
  final Map<String, dynamic>? after;
  final String? ipAddress;
  final String? userAgent;
  final DateTime timestamp;
}
```

#### New Domain Services

```dart
// lib/features/enterprise/domain/services/

class TenantContextService {
  String? _currentTenantId;
  
  String get currentTenantId => _currentTenantId!;
  
  Future<void> setTenantContext(String tenantId) async {
    _currentTenantId = tenantId;
    await _validateTenantAccess(tenantId);
  }
  
  Future<void> clearTenantContext() async {
    _currentTenantId = null;
  }
  
  Future<bool> hasAccessToTenant(String userId, String tenantId) async {
    // Check if user belongs to tenant
    final user = await _userRepository.getUser(userId);
    return user?.tenantId == tenantId;
  }
}

class SsoService {
  Future<bool> configureSamlSso({
    required String tenantId,
    required String metadataXml,
    required Map<String, String> attributeMapping,
    required Map<String, String> groupRoleMapping,
  }) async {
    // Parse SAML metadata
    final metadata = await _parseSamlMetadata(metadataXml);
    
    // Validate configuration
    await _validateSamlConfiguration(metadata);
    
    // Save configuration
    final config = SsoConfiguration(
      id: uuid.v4(),
      tenantId: tenantId,
      type: SsoType.saml2,
      metadata: metadata,
      attributeMapping: attributeMapping,
      groupRoleMapping: groupRoleMapping,
      jitProvisioning: true,
      enabled: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _ssoRepository.saveConfiguration(config);
    return true;
  }
  
  Future<bool> configureOidcSso({
    required String tenantId,
    required String issuer,
    required String clientId,
    required String clientSecret,
    required Map<String, String> attributeMapping,
  }) async {
    // Validate OIDC configuration
    await _validateOidcConfiguration(issuer, clientId, clientSecret);
    
    // Save configuration
    final config = SsoConfiguration(
      id: uuid.v4(),
      tenantId: tenantId,
      type: SsoType.oidc,
      metadata: {
        'issuer': issuer,
        'clientId': clientId,
        'clientSecret': clientSecret,
      },
      attributeMapping: attributeMapping,
      groupRoleMapping: {},
      jitProvisioning: true,
      enabled: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _ssoRepository.saveConfiguration(config);
    return true;
  }
  
  Future<User?> authenticateWithSso({
    required String tenantId,
    required Map<String, dynamic> ssoResponse,
  }) async {
    final config = await _ssoRepository.getConfiguration(tenantId);
    if (config == null || !config.enabled) {
      throw SsoNotConfiguredException();
    }
    
    // Validate SSO response
    final claims = await _validateSsoResponse(config, ssoResponse);
    
    // Map attributes
    final email = claims[config.attributeMapping['email']];
    final name = claims[config.attributeMapping['name']];
    
    // Find or create user
    User? user = await _userRepository.findByEmail(email, tenantId);
    
    if (user == null && config.jitProvisioning) {
      user = await _provisionUser(
        tenantId: tenantId,
        email: email,
        name: name,
        claims: claims,
        config: config,
      );
    }
    
    return user;
  }
  
  Future<User> _provisionUser({
    required String tenantId,
    required String email,
    required String name,
    required Map<String, dynamic> claims,
    required SsoConfiguration config,
  }) async {
    // Determine role based on group membership
    String roleId = 'default_user';
    if (config.groupRoleMapping.isNotEmpty) {
      final groups = claims['groups'] as List<dynamic>?;
      if (groups != null) {
        for (final group in groups) {
          if (config.groupRoleMapping.containsKey(group)) {
            roleId = config.groupRoleMapping[group]!;
            break;
          }
        }
      }
    }
    
    // Create user
    final user = User(
      id: uuid.v4(),
      tenantId: tenantId,
      email: email,
      name: name,
      roleId: roleId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _userRepository.save(user);
    return user;
  }
}

class PermissionService {
  Future<bool> hasPermission({
    required String userId,
    required String permission,
    String? resourceId,
  }) async {
    final user = await _userRepository.getUser(userId);
    if (user == null) return false;
    
    // Get user's roles
    final roles = await _roleRepository.getRolesForUser(userId);
    
    // Check if any role has the permission
    for (final role in roles) {
      if (role.permissions.contains(permission)) {
        // Check resource-level permissions if specified
        if (resourceId != null) {
          return await _hasResourcePermission(
            userId,
            role.id,
            permission,
            resourceId,
          );
        }
        return true;
      }
    }
    
    return false;
  }
  
  Future<bool> _hasResourcePermission(
    String userId,
    String roleId,
    String permission,
    String resourceId,
  ) async {
    // Check if user has direct access to resource
    final resource = await _resourceRepository.getResource(resourceId);
    if (resource == null) return false;
    
    // Check tenant ownership
    if (resource.tenantId != user.tenantId) return false;
    
    // Check organizational unit access
    if (resource.orgUnitId != null) {
      final userOrgUnits = await _orgUnitRepository.getUserOrgUnits(userId);
      if (!userOrgUnits.any((ou) => ou.id == resource.orgUnitId)) {
        return false;
      }
    }
    
    return true;
  }
}

class AuditService {
  Future<void> logEvent({
    required String tenantId,
    required String userId,
    required String action,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
    String? ipAddress,
    String? userAgent,
  }) async {
    final entry = AuditLogEntry(
      id: uuid.v4(),
      tenantId: tenantId,
      userId: userId,
      action: action,
      resourceType: resourceType,
      resourceId: resourceId,
      before: before,
      after: after,
      ipAddress: ipAddress,
      userAgent: userAgent,
      timestamp: DateTime.now(),
    );
    
    await _auditRepository.save(entry);
    
    // Check for real-time alerts
    await _checkForAlerts(entry);
  }
  
  Future<List<AuditLogEntry>> searchLogs({
    required String tenantId,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? action,
    String? resourceType,
    String? resourceId,
  }) async {
    return await _auditRepository.search(
      tenantId: tenantId,
      startDate: startDate,
      endDate: endDate,
      userId: userId,
      action: action,
      resourceType: resourceType,
      resourceId: resourceId,
    );
  }
}
```

### Data Layer

#### New Repository Interfaces

```dart
// lib/features/enterprise/domain/repositories/

abstract class TenantRepository {
  Future<List<Tenant>> getAllTenants();
  Future<Tenant?> getTenant(String tenantId);
  Future<Tenant> createTenant(Tenant tenant);
  Future<Tenant> updateTenant(Tenant tenant);
  Future<void> deleteTenant(String tenantId);
  Future<bool> tenantExists(String slug);
}

abstract class SsoRepository {
  Future<SsoConfiguration?> getConfiguration(String tenantId);
  Future<SsoConfiguration> saveConfiguration(SsoConfiguration config);
  Future<void> deleteConfiguration(String tenantId);
  Future<bool> testConfiguration(String tenantId);
}

abstract class RoleRepository {
  Future<List<CustomRole>> getRoles(String tenantId);
  Future<CustomRole?> getRole(String roleId);
  Future<CustomRole> createRole(CustomRole role);
  Future<CustomRole> updateRole(CustomRole role);
  Future<void> deleteRole(String roleId);
  Future<List<CustomRole>> getRolesForUser(String userId);
}

abstract class OrgUnitRepository {
  Future<List<OrganizationalUnit>> getOrgUnits(String tenantId);
  Future<OrganizationalUnit?> getOrgUnit(String orgUnitId);
  Future<OrganizationalUnit> createOrgUnit(OrganizationalUnit orgUnit);
  Future<OrganizationalUnit> updateOrgUnit(OrganizationalUnit orgUnit);
  Future<void> deleteOrgUnit(String orgUnitId);
  Future<List<OrganizationalUnit>> getUserOrgUnits(String userId);
}

abstract class AuditRepository {
  Future<AuditLogEntry?> getLogEntry(String entryId);
  Future<void> save(AuditLogEntry entry);
  Future<List<AuditLogEntry>> search({
    required String tenantId,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? action,
    String? resourceType,
    String? resourceId,
  });
  Future<void> exportLogs({
    required String tenantId,
    required DateTime startDate,
    required DateTime endDate,
    required String format,
  });
}
```

#### Repository Implementation

```dart
// lib/features/enterprise/data/repositories/

class TenantRepositoryImpl implements TenantRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;
  
  @override
  Future<List<Tenant>> getAllTenants() async {
    final response = await _apiClient.get('/api/platform/tenants');
    return (response.data as List)
        .map((json) => Tenant.fromJson(json))
        .toList();
  }
  
  @override
  Future<Tenant?> getTenant(String tenantId) async {
    final cached = await _cacheManager.get('tenant_$tenantId');
    if (cached != null) {
      return Tenant.fromJson(cached);
    }
    
    final response = await _apiClient.get('/api/platform/tenants/$tenantId');
    await _cacheManager.set('tenant_$tenantId', response.data);
    return Tenant.fromJson(response.data);
  }
  
  @override
  Future<Tenant> createTenant(Tenant tenant) async {
    final response = await _apiClient.post(
      '/api/platform/tenants',
      data: tenant.toJson(),
    );
    final created = Tenant.fromJson(response.data);
    await _cacheManager.set('tenant_${created.id}', response.data);
    return created;
  }
  
  // ... other methods
}

class AuditRepositoryImpl implements AuditRepository {
  final ApiClient _apiClient;
  final HiveBox _auditBox;
  
  @override
  Future<void> save(AuditLogEntry entry) async {
    // Save to local database for offline access
    await _auditBox.put(entry.id, entry.toJson());
    
    // Sync to backend
    try {
      await _apiClient.post(
        '/api/tenants/${entry.tenantId}/audit-logs',
        data: entry.toJson(),
      );
    } catch (e) {
      // Mark for retry
      await _auditBox.put('sync_${entry.id}', {'needsSync': true});
    }
  }
  
  @override
  Future<List<AuditLogEntry>> search({
    required String tenantId,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? action,
    String? resourceType,
    String? resourceId,
  }) async {
    final response = await _apiClient.get(
      '/api/tenants/$tenantId/audit-logs',
      queryParameters: {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (userId != null) 'userId': userId,
        if (action != null) 'action': action,
        if (resourceType != null) 'resourceType': resourceType,
        if (resourceId != null) 'resourceId': resourceId,
      },
    );
    
    return (response.data as List)
        .map((json) => AuditLogEntry.fromJson(json))
        .toList();
  }
  
  @override
  Future<void> exportLogs({
    required String tenantId,
    required DateTime startDate,
    required DateTime endDate,
    required String format,
  }) async {
    final response = await _apiClient.get(
      '/api/tenants/$tenantId/audit-logs/export',
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'format': format,
      },
      options: Options(responseType: ResponseType.bytes),
    );
    
    return response.data;
  }
}
```

## Data Model Extensions

### Database Schema Changes

```sql
-- Add tenant_id to existing tables
ALTER TABLE users ADD COLUMN tenant_id VARCHAR(36) NOT NULL;
ALTER TABLE forms ADD COLUMN tenant_id VARCHAR(36) NOT NULL;
ALTER TABLE form_responses ADD COLUMN tenant_id VARCHAR(36) NOT NULL;
ALTER TABLE dashboards ADD COLUMN tenant_id VARCHAR(36) NOT NULL;

-- Create tenant-specific indexes
CREATE INDEX idx_users_tenant_id ON users(tenant_id);
CREATE INDEX idx_forms_tenant_id ON forms(tenant_id);
CREATE INDEX idx_responses_tenant_id ON form_responses(tenant_id);

-- New tenant table
CREATE TABLE tenants (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    domain VARCHAR(255),
    branding JSON,
    quotas JSON,
    settings JSON,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- New SSO configuration table
CREATE TABLE sso_configurations (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    type VARCHAR(50) NOT NULL,
    metadata JSON NOT NULL,
    attribute_mapping JSON,
    group_role_mapping JSON,
    jit_provisioning BOOLEAN DEFAULT TRUE,
    enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);

-- New organizational units table
CREATE TABLE organizational_units (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    parent_id VARCHAR(36),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES organizational_units(id) ON DELETE SET NULL
);

-- New custom roles table
CREATE TABLE custom_roles (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    permissions JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);

-- New audit log table
CREATE TABLE audit_logs (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    action VARCHAR(255) NOT NULL,
    resource_type VARCHAR(100) NOT NULL,
    resource_id VARCHAR(36),
    before_data JSON,
    after_data JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tenant_timestamp (tenant_id, timestamp),
    INDEX idx_user_timestamp (user_id, timestamp),
    INDEX idx_action_timestamp (action, timestamp),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);
```

### Row-Level Security

```sql
-- Enable row-level security
ALTER TABLE forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE dashboards ENABLE ROW LEVEL SECURITY;

-- Create policy for forms
CREATE POLICY tenant_isolation_forms ON forms
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

-- Create policy for responses
CREATE POLICY tenant_isolation_responses ON form_responses
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

-- Create policy for dashboards
CREATE POLICY tenant_isolation_dashboards ON dashboards
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
```

## API Integration

### New API Endpoints

```dart
// lib/features/enterprise/data/datasources/

class EnterpriseRemoteDataSource {
  final Dio dio;
  
  // Tenant management
  Future<List<TenantDto>> getTenants() async {
    final response = await dio.get('/api/platform/tenants');
    return (response.data as List)
        .map((json) => TenantDto.fromJson(json))
        .toList();
  }
  
  Future<TenantDto> createTenant(CreateTenantDto dto) async {
    final response = await dio.post(
      '/api/platform/tenants',
      data: dto.toJson(),
    );
    return TenantDto.fromJson(response.data);
  }
  
  // SSO configuration
  Future<SsoConfigurationDto> configureSso({
    required String tenantId,
    required ConfigureSsoDto dto,
  }) async {
    final response = await dio.post(
      '/api/tenants/$tenantId/sso/configure',
      data: dto.toJson(),
    );
    return SsoConfigurationDto.fromJson(response.data);
  }
  
  Future<bool> testSsoConnection(String tenantId) async {
    final response = await dio.get('/api/tenants/$tenantId/sso/test');
    return response.data['success'] as bool;
  }
  
  // Role management
  Future<List<CustomRoleDto>> getRoles(String tenantId) async {
    final response = await dio.get('/api/tenants/$tenantId/roles');
    return (response.data as List)
        .map((json) => CustomRoleDto.fromJson(json))
        .toList();
  }
  
  Future<CustomRoleDto> createRole({
    required String tenantId,
    required CreateRoleDto dto,
  }) async {
    final response = await dio.post(
      '/api/tenants/$tenantId/roles',
      data: dto.toJson(),
    );
    return CustomRoleDto.fromJson(response.data);
  }
  
  // Audit logs
  Future<List<AuditLogDto>> searchAuditLogs({
    required String tenantId,
    AuditLogSearchDto? search,
  }) async {
    final response = await dio.get(
      '/api/tenants/$tenantId/audit-logs',
      queryParameters: search?.toJson(),
    );
    return (response.data as List)
        .map((json) => AuditLogDto.fromJson(json))
        .toList();
  }
  
  // Bulk operations
  Future<BulkOperationResultDto> bulkImportUsers({
    required String tenantId,
    required List<CreateUserDto> users,
  }) async {
    final response = await dio.post(
      '/api/tenants/$tenantId/users/bulk-import',
      data: users.map((u) => u.toJson()).toList(),
    );
    return BulkOperationResultDto.fromJson(response.data);
  }
}
```

## State Management

### New Riverpod Providers

```dart
// lib/features/enterprise/presentation/providers/

@riverpod
class TenantController extends _$TenantController {
  @override
  Future<List<Tenant>> build() async {
    final repository = ref.watch(tenantRepositoryProvider);
    return repository.getAllTenants();
  }
  
  Future<void> createTenant(Tenant tenant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(tenantRepositoryProvider);
      return repository.createTenant(tenant);
    });
  }
  
  Future<void> updateTenant(Tenant tenant) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(tenantRepositoryProvider);
      return repository.updateTenant(tenant);
    });
  }
}

@riverpod
class SsoController extends _$SsoController {
  @override
  Future<SsoConfiguration?> build(String tenantId) => null;
  
  Future<void> configureSso({
    required String tenantId,
    required ConfigureSsoDto dto,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(ssoRepositoryProvider);
      return repository.saveConfiguration(
        SsoConfiguration.fromDto(dto),
      );
    });
  }
  
  Future<bool> testConnection(String tenantId) async {
    final repository = ref.watch(ssoRepositoryProvider);
    return repository.testConfiguration(tenantId);
  }
}

@riverpod
class AuditLogController extends _$AuditLogController {
  @override
  Future<List<AuditLogEntry>> build(String tenantId) => [];
  
  Future<void> searchLogs({
    required String tenantId,
    AuditLogSearchDto? search,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(auditRepositoryProvider);
      return repository.search(
        tenantId: tenantId,
        startDate: search?.startDate,
        endDate: search?.endDate,
        userId: search?.userId,
        action: search?.action,
        resourceType: search?.resourceType,
        resourceId: search?.resourceId,
      );
    });
  }
}
```

## Security Considerations

### Tenant Context Middleware

```dart
// lib/core/middleware/

class TenantContextMiddleware {
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get tenant ID from current user
    final tenantId = await _getCurrentTenantId();
    
    if (tenantId != null) {
      // Add tenant ID to request headers
      options.headers['X-Tenant-ID'] = tenantId;
      
      // Set database context
      await _setDatabaseContext(tenantId);
    }
    
    handler.next(options);
  }
  
  Future<String?> _getCurrentTenantId() async {
    final user = await _userRepository.getCurrentUser();
    return user?.tenantId;
  }
  
  Future<void> _setDatabaseContext(String tenantId) async {
    // Set PostgreSQL session variable for row-level security
    await _database.execute('SET app.current_tenant_id = $1', [tenantId]);
  }
}
```

### Permission Interceptor

```dart
// lib/core/interceptors/

class PermissionInterceptor {
  Future<bool> checkPermission({
    required String permission,
    String? resourceId,
  }) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return false;
    
    final permissionService = ref.watch(permissionServiceProvider);
    return permissionService.hasPermission(
      userId: userId,
      permission: permission,
      resourceId: resourceId,
    );
  }
}
```

## Deployment Considerations

### Backend Requirements

1. **Database Multi-Tenancy**
   - Row-level security implementation
   - Tenant-specific indexes
   - Database connection pooling per tenant

2. **SSO Infrastructure**
   - SAML 2.0 library integration
   - OIDC provider support
   - Certificate management

3. **Audit Log Storage**
   - Time-series database for efficient querying
   - Log retention policies
   - Export and archiving capabilities

4. **Monitoring**
   - Per-tenant metrics collection
   - Quota monitoring and alerting
   - Health checks for tenant isolation
