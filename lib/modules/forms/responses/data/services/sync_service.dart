import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/core/errors/app_exception.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/responses/response_repository_provider.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/auth/auth_models.dart';

final syncServiceProvider = AsyncNotifierProvider<SyncService, void>(
  SyncService.new,
);

class SyncService extends AsyncNotifier<void> {
  Box? _box;
  String? _currentUserId;

  void _log(String message) {
    debugPrint(message);
  }

  String _boxNameForUser(String organizationId, String userId) {
    return 'pending_submissions_${organizationId}_$userId';
  }

  UserModel? _currentUser() {
    return ref.read(authControllerProvider).value;
  }

  @override
  Future<void> build() async {
    final user = ref.watch(authControllerProvider).value;

    if (user == null) {
      if (_box != null) {
        // Only close the box, DO NOT clear it, so that pending submissions
        // are preserved and can be synced once the user logs back in.
        await _box!.close();
        _box = null;
        _currentUserId = null;
      }
      return;
    }

    if (_currentUserId != user.id) {
      if (_box != null) {
        await _box!.close();
      }
      _currentUserId = user.id;
      // Scoping box by organizationId and userId to prevent data leakage between users/orgs
      final organizationId = user.organizationId ?? 'default';
      _box = await Hive.openBox(_boxNameForUser(organizationId, user.id));
    }

    // Try to sync on startup if online
    if (ref.read(connectivityServiceProvider).isConnected) {
      await syncPendingSubmissions();
    }
  }

  Future<void> addPendingSubmission(
    FormResponse response, {
    String? projectId,
  }) async {
    await _ensureBox();
    if (_box == null) return;
    // Wrapping the response along with the optional projectId to preserve project scoping on sync
    await _box!.put(response.id, {
      'response': response.toJson(),
      'projectId': projectId,
    });
    ref.notifyListeners();
  }

  Future<void> syncPendingSubmissions() async {
    await _ensureBox();
    if (_box == null || _box!.isEmpty) return;

    final repository = ref.read(responseRepositoryProvider);
    final keys = List<String>.from(_box!.keys);

    for (final key in keys) {
      final value = _box!.get(key);
      try {
        if (value == null) continue;

        final FormResponse response;
        final String? projectId;

        // Backward compatibility support for legacy responses stored as plain Maps
        if (value is Map && value.containsKey('response')) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(
            value['response'] as Map,
          );
          response = FormResponse.fromJson(data);
          projectId = value['projectId'] as String?;
        } else if (value is Map) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(value);
          response = FormResponse.fromJson(data);
          projectId = null;
        } else {
          continue;
        }

        // Ensure we only sync if the user is still logged in and matches
        if (_currentUserId == null) break;

        if (projectId != null) {
          await repository.submitProjectResponse(projectId, response);
        } else {
          await repository.submitResponse(response);
        }
        await _box!.delete(key);
        _log('Synced submission: $key for user $_currentUserId');
      } catch (e) {
        _log('Failed to sync submission $key: $e');
        // Handle permanently invalid submissions (e.g. 400 Bad Request, 403 Forbidden)
        // by deleting them from the queue so they do not block subsequent submissions.
        if (e is ApiException && (e.statusCode == 400 || e.statusCode == 403)) {
          await _box!.delete(key);
        }
      }
    }
    ref.notifyListeners();
  }

  Future<void> clearData() async {
    if (_box != null) {
      await _box!.clear();
      await _box!.close();
      _box = null;
      _currentUserId = null;
    }
  }

  List<FormResponse> getPendingSubmissions() {
    if (_box == null) return [];
    return _box!.values.map((value) {
      if (value is Map && value.containsKey('response')) {
        return FormResponse.fromJson(
          Map<String, dynamic>.from(value['response'] as Map),
        );
      }
      return FormResponse.fromJson(Map<String, dynamic>.from(value as Map));
    }).toList();
  }

  bool get hasPendingSubmissions => _box?.isNotEmpty ?? false;
  int get pendingCount => _box?.length ?? 0;

  Future<void> _ensureBox() async {
    if (_box != null) return;

    final user = _currentUser();
    if (user == null) return;

    _currentUserId = user.id;
    final organizationId = user.organizationId ?? 'default';
    _box = await Hive.openBox(_boxNameForUser(organizationId, user.id));
  }
}
