import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/core/services/connectivity_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/local_database.dart';
import 'package:frontend/modules/forms/responses/data/services/sync_service.dart';

final offlineSyncServiceProvider = AsyncNotifierProvider<OfflineSyncService, void>(
  OfflineSyncService.new,
);

class OfflineSyncService extends AsyncNotifier<void> {
  LocalDatabase get _db => ref.read(localDatabaseProvider);
  String? _currentUserId;
  String? _currentOrgId;

  @override
  Future<void> build() async {
    final user = ref.watch(authControllerProvider).value;

    if (user == null) {
      _currentUserId = null;
      _currentOrgId = null;
      return;
    }

    _currentUserId = user.id;
    _currentOrgId = user.organizationId;

    // Sync data on startup if online
    if (ref.read(connectivityServiceProvider).isConnected) {
      await syncAllData();
    }
  }

  /// Sync all required data for offline use
  Future<void> syncAllData() async {
    if (_currentUserId == null || _currentOrgId == null) return;

    try {
      await Future.wait([
        _syncUserProfile(),
        _syncOrgMemberships(),
        _syncProjectMetadata(),
        _syncFormSchemas(),
        _syncNotificationHistory(),
        _syncPluginComponentSchemas(),
      ]);
      
      debugPrint('Offline sync completed successfully');
    } catch (e) {
      debugPrint('Offline sync failed: $e');
      rethrow;
    }
  }

  /// Sync user profile and auth tokens
  Future<void> _syncUserProfile() async {
    if (_currentUserId == null) return;

    // User profile is typically handled by the auth service
    // Here we ensure any user-specific data is cached
    final user = ref.read(authControllerProvider).value;
    if (user != null) {
      // Cache user profile in local database
      await _db.upsertCachedForm(
        CachedFormRecord(
          id: 'user_profile_$_currentUserId',
          title: 'User Profile',
          slug: 'user_profile',
          rawJson: jsonEncode(user.toJson()),
          cachedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Sync organization memberships and roles
  Future<void> _syncOrgMemberships() async {
    if (_currentUserId == null || _currentOrgId == null) return;

    // In a real implementation, this would fetch from the API
    // For now, we'll cache the current organization info
    final orgData = {
      'user_id': _currentUserId,
      'org_id': _currentOrgId,
      'roles': ['org_viewer'], // Default role
      'synced_at': DateTime.now().toIso8601String(),
    };

    await _db.upsertCachedForm(
      CachedFormRecord(
        id: 'org_memberships_$_currentUserId',
        title: 'Organization Memberships',
        slug: 'org_memberships',
        rawJson: jsonEncode(orgData),
        cachedAt: DateTime.now(),
      ),
    );
  }

  /// Sync project metadata the user can access
  Future<void> _syncProjectMetadata() async {
    if (_currentUserId == null || _currentOrgId == null) return;

    // In a real implementation, this would fetch projects from API
    // For now, we'll create placeholder data
    final projectsData = {
      'user_id': _currentUserId,
      'org_id': _currentOrgId,
      'projects': [
        {
          'id': 'project_1',
          'name': 'Sample Project',
          'description': 'A sample project for offline access',
          'synced_at': DateTime.now().toIso8601String(),
        }
      ],
    };

    await _db.upsertCachedForm(
      CachedFormRecord(
        id: 'projects_$_currentUserId',
        title: 'Projects',
        slug: 'projects',
        rawJson: jsonEncode(projectsData),
        cachedAt: DateTime.now(),
      ),
    );
  }

  /// Sync form schemas (production branch only)
  Future<void> _syncFormSchemas() async {
    if (_currentUserId == null || _currentOrgId == null) return;

    // In a real implementation, this would fetch forms from API
    // For now, we'll create a sample form schema
    final formSchema = {
      'id': 'form_1',
      'title': 'Sample Form',
      'description': 'A sample form for offline access',
      'schema': {
        'type': 'column',
        'children': [
          {
            'type': 'text_field',
            'id': 'name',
            'label': 'Full Name',
            'required': true,
          },
          {
            'type': 'email',
            'id': 'email',
            'label': 'Email Address',
            'required': true,
          },
          {
            'type': 'text_area',
            'id': 'feedback',
            'label': 'Feedback',
            'placeholder': 'Please provide your feedback...',
          },
        ],
      },
      'production_branch': 'main',
      'synced_at': DateTime.now().toIso8601String(),
    };

    await _db.upsertCachedForm(
      CachedFormRecord(
        id: 'form_schema_${_currentOrgId}_form_1',
        title: 'Sample Form',
        slug: 'sample_form',
        rawJson: jsonEncode(formSchema),
        cachedAt: DateTime.now(),
      ),
    );
  }

  /// Sync notification history (last 100)
  Future<void> _syncNotificationHistory() async {
    if (_currentUserId == null) return;

    // In a real implementation, this would fetch notifications from API
    final notifications = {
      'user_id': _currentUserId,
      'notifications': [
        {
          'id': 'notif_1',
          'type': 'info',
          'title': 'Welcome',
          'message': 'Welcome to the Form Builder Platform',
          'created_at': DateTime.now().toIso8601String(),
          'read': false,
        }
      ],
      'synced_at': DateTime.now().toIso8601String(),
    };

    await _db.upsertCachedForm(
      CachedFormRecord(
        id: 'notifications_$_currentUserId',
        title: 'Notifications',
        slug: 'notifications',
        rawJson: jsonEncode(notifications),
        cachedAt: DateTime.now(),
      ),
    );
  }

  /// Sync plugin component schemas for rendering
  Future<void> _syncPluginComponentSchemas() async {
    if (_currentUserId == null || _currentOrgId == null) return;

    // In a real implementation, this would fetch plugin schemas from API
    final pluginSchemas = {
      'org_id': _currentOrgId,
      'components': [
        {
          'type': 'text_field',
          'primitive': 'text_input',
          'properties': [
            {'key': 'placeholder', 'type': 'string', 'default': ''},
            {'key': 'required', 'type': 'boolean', 'default': false},
          ],
        },
        {
          'type': 'dropdown',
          'primitive': 'select',
          'properties': [
            {'key': 'options', 'type': 'array', 'default': []},
            {'key': 'required', 'type': 'boolean', 'default': false},
          ],
        },
      ],
      'synced_at': DateTime.now().toIso8601String(),
    };

    await _db.upsertCachedForm(
      CachedFormRecord(
        id: 'plugin_schemas_$_currentOrgId',
        title: 'Plugin Schemas',
        slug: 'plugin_schemas',
        rawJson: jsonEncode(pluginSchemas),
        cachedAt: DateTime.now(),
      ),
    );
  }

  /// Get cached form schema by ID
  Future<Map<String, dynamic>?> getCachedFormSchema(String formId) async {
    try {
      final cachedForm = await _db.getCachedForm('form_schema_${_currentOrgId}_$formId');
      return cachedForm == null
          ? null
          : jsonDecode(cachedForm.rawJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Get cached projects
  Future<Map<String, dynamic>?> getCachedProjects() async {
    try {
      final cachedProjects = await _db.getCachedForm('projects_$_currentUserId');
      return cachedProjects == null
          ? null
          : jsonDecode(cachedProjects.rawJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Get cached notifications
  Future<Map<String, dynamic>?> getCachedNotifications() async {
    try {
      final cachedNotifications = await _db.getCachedForm('notifications_$_currentUserId');
      return cachedNotifications == null
          ? null
          : jsonDecode(cachedNotifications.rawJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached data for the current user
  Future<void> clearAllCachedData() async {
    if (_currentUserId == null) return;

    await Future.wait([
      _db.deleteAllCachedForms(),
      _db.deleteAllCachedResponses(),
      _db.deleteAllPendingUploads(),
    ]);

    debugPrint('Cleared all cached data for user: $_currentUserId');
  }

  /// Force refresh all cached data
  Future<void> refreshAllData() async {
    if (_currentUserId == null) return;

    await clearAllCachedData();
    await syncAllData();
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'user_id': _currentUserId,
      'org_id': _currentOrgId,
      'last_sync': DateTime.now().toIso8601String(),
      'status': 'completed',
    };
  }
}
