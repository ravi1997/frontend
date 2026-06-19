import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/core/errors/app_exception.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/responses/response_repository_provider.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/core/storage/local_database.dart';
import 'package:drift/drift.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  final db = LocalDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final syncServiceProvider = AsyncNotifierProvider<SyncService, void>(
  SyncService.new,
);

bool pendingSubmissionBelongsToScope(
  Map<String, dynamic> payload, {
  required String? userId,
  required String? organizationId,
}) {
  final responseData = payload['response'];
  if (responseData is! Map) return false;
  final response = FormResponse.fromJson(Map<String, dynamic>.from(responseData));
  final sameUser = userId != null && response.submittedBy == userId;
  final sameOrg = organizationId == null ||
      organizationId.isEmpty ||
      response.organizationId == organizationId;
  return sameUser && sameOrg;
}

class SyncConflict {
  final String pendingUploadId;
  final String projectId;
  final FormResponse localResponse;
  final FormResponse serverResponse;

  SyncConflict({
    required this.pendingUploadId,
    required this.projectId,
    required this.localResponse,
    required this.serverResponse,
  });
}

class SyncService extends AsyncNotifier<void> {
  LocalDatabase get _db => ref.read(localDatabaseProvider);
  String? _currentUserId;
  String? _currentOrganizationId;
  List<FormResponse> _cachedPending = [];
  SyncConflict? activeConflict;

  void _log(String message) {
    debugPrint(message);
  }

  @override
  Future<void> build() async {
    final user = ref.watch(authControllerProvider).value;
    final tokens = ref.watch(tokenServiceProvider).value;

    if (user == null) {
      _currentUserId = null;
      _currentOrganizationId = null;
      _cachedPending = [];
      activeConflict = null;
      return;
    }

    _currentUserId = user.id;
    _currentOrganizationId = user.organizationId ?? tokens?.organizationId;
    await _refreshCachedPending();

    // Try to sync on startup if online
    if (ref.read(connectivityServiceProvider).isConnected) {
      await syncPendingSubmissions();
    }
  }

  Future<void> _refreshCachedPending() async {
    final rows = await _scopedPendingUploads();
    _cachedPending = rows.map((row) {
      final decoded = jsonDecode(row.payloadJson) as Map<String, dynamic>;
      final responseData = Map<String, dynamic>.from(decoded['response'] as Map);
      return FormResponse.fromJson(responseData);
    }).toList();
    ref.notifyListeners();
  }

  Future<List<PendingUpload>> _scopedPendingUploads() async {
    final rows = await _db.select(_db.pendingUploads).get();
    return rows.where(_matchesCurrentScope).toList();
  }

  bool _matchesCurrentScope(dynamic row) {
    if (_currentUserId == null) {
      return false;
    }

    final decoded = jsonDecode(row.payloadJson) as Map<String, dynamic>;
    return pendingSubmissionBelongsToScope(
      decoded,
      userId: _currentUserId,
      organizationId: _currentOrganizationId,
    );
  }

  Future<void> addPendingSubmission(
    FormResponse response, {
    String? projectId,
  }) async {
    final responseId = response.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final payload = jsonEncode({
      'response': response.toJson(),
      'projectId': projectId,
      'submittedBy': _currentUserId,
      'organizationId': _currentOrganizationId ?? response.organizationId,
    });

    await _db.into(_db.pendingUploads).insertOnConflictUpdate(
      PendingUploadsCompanion(
        id: Value(responseId),
        formId: Value(response.formId),
        payloadJson: Value(payload),
        queuedAt: Value(DateTime.now()),
        retryCount: const Value(0),
      ),
    );

    await _refreshCachedPending();
  }

  Future<void> syncPendingSubmissions() async {
    final rows = await _scopedPendingUploads();
    if (rows.isEmpty) return;

    final repository = ref.read(responseRepositoryProvider);

    for (final row in rows) {
      try {
        final decoded = jsonDecode(row.payloadJson) as Map<String, dynamic>;
        final responseData = Map<String, dynamic>.from(decoded['response'] as Map);
        final response = FormResponse.fromJson(responseData);
        final projectId = decoded['projectId'] as String?;

        // Ensure we only sync if the user is still logged in and matches
        if (_currentUserId == null) break;

        if (projectId != null) {
          await repository.submitProjectResponse(projectId, response);
        } else {
          await repository.submitResponse(response);
        }
        
        // Delete upon successful submission
        await (_db.delete(_db.pendingUploads)..where((t) => t.id.equals(row.id))).go();
        _log('Synced submission: ${row.id} for user $_currentUserId');
      } catch (e) {
        _log('Failed to sync submission ${row.id}: $e');
        
        if (e is ApiException && e.statusCode == 409) {
          final decoded = jsonDecode(row.payloadJson) as Map<String, dynamic>;
          final responseData = Map<String, dynamic>.from(decoded['response'] as Map);
          final response = FormResponse.fromJson(responseData);
          final projectId = decoded['projectId'] as String? ?? '';

          try {
            final serverResponse = await repository.getProjectResponseDetail(
              projectId,
              response.formId,
              response.id!,
            );
            activeConflict = SyncConflict(
              pendingUploadId: row.id,
              projectId: projectId,
              localResponse: response,
              serverResponse: serverResponse,
            );
            ref.notifyListeners();
            // Pause further syncing until conflict is resolved
            break;
          } catch (fetchError) {
            _log('Failed to fetch conflicting server response: $fetchError');
          }
        }
        
        // Handle permanently invalid submissions (e.g. 400 Bad Request, 403 Forbidden)
        // by deleting them from the queue so they do not block subsequent submissions.
        if (e is ApiException && (e.statusCode == 400 || e.statusCode == 403)) {
          await (_db.delete(_db.pendingUploads)..where((t) => t.id.equals(row.id))).go();
        } else {
          // Increment retry count
          await (_db.update(_db.pendingUploads)
            ..where((t) => t.id.equals(row.id)))
            .write(PendingUploadsCompanion(retryCount: Value(row.retryCount + 1)));
        }
      }
    }
    await _refreshCachedPending();
  }

  void clearActiveConflict() {
    activeConflict = null;
    ref.notifyListeners();
  }

  Future<void> clearData() async {
    final rows = await _scopedPendingUploads();
    for (final row in rows) {
      await (_db.delete(_db.pendingUploads)..where((t) => t.id.equals(row.id))).go();
    }
    _cachedPending = [];
    _currentUserId = null;
    _currentOrganizationId = null;
    activeConflict = null;
    ref.notifyListeners();
  }

  List<FormResponse> getPendingSubmissions() {
    return _cachedPending;
  }

  bool get hasPendingSubmissions => _cachedPending.isNotEmpty;
  int get pendingCount => _cachedPending.length;
}
