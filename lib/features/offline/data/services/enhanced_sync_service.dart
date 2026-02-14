import 'dart:math' as math;
import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/features/offline/data/repositories/conflict_repository_impl.dart';
import 'package:frontend/features/offline/domain/entities/sync_conflict.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/data/repositories/response_repository_impl.dart';

part 'enhanced_sync_service.g.dart';

/// Configuration for sync retry logic
class SyncConfig {
  final int maxRetries;
  final Duration initialRetryDelay;
  final Duration maxRetryDelay;
  final double backoffMultiplier;

  const SyncConfig({
    this.maxRetries = 3,
    this.initialRetryDelay = const Duration(seconds: 2),
    this.maxRetryDelay = const Duration(minutes: 1),
    this.backoffMultiplier = 2.0,
  });
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String? errorMessage;
  final int syncedCount;
  final int failedCount;
  final int conflictCount;

  const SyncResult({
    required this.success,
    this.errorMessage,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.conflictCount = 0,
  });

  factory SyncResult.success({int syncedCount = 0}) {
    return SyncResult(success: true, syncedCount: syncedCount);
  }

  factory SyncResult.failure(String errorMessage) {
    return SyncResult(success: false, errorMessage: errorMessage);
  }

  factory SyncResult.partial({
    required int syncedCount,
    required int failedCount,
    required int conflictCount,
  }) {
    return SyncResult(
      success: true,
      syncedCount: syncedCount,
      failedCount: failedCount,
      conflictCount: conflictCount,
    );
  }
}

/// Enhanced sync service with retry logic and conflict resolution
@riverpod
class EnhancedSyncService extends _$EnhancedSyncService {
  late Box _pendingBox;
  late Box _retryBox;
  late ConflictRepositoryImpl _conflictRepo;
  final SyncConfig _config = const SyncConfig();

  @override
  Future<void> build() async {
    _pendingBox = await Hive.openBox('pending_submissions');
    _retryBox = await Hive.openBox('sync_retries');
    _conflictRepo = ConflictRepositoryImpl();
    await _conflictRepo.init();

    // Listen for connectivity changes
    ref.listen(connectivityServiceProvider, (previous, next) {
      if (next == ConnectivityStatus.online) {
        syncPendingSubmissions();
      }
    });

    // Try to sync on startup if online
    if (ref.read(connectivityServiceProvider) == ConnectivityStatus.online) {
      await syncPendingSubmissions();
    }
  }

  /// Adds a pending submission to the sync queue
  Future<void> addPendingSubmission(FormResponse response) async {
    await _pendingBox.put(response.id, response.toJson());
    await _resetRetryCount(response.id);
    ref.notifyListeners();
  }

  /// Syncs all pending submissions with retry logic
  Future<SyncResult> syncPendingSubmissions() async {
    if (_pendingBox.isEmpty) {
      return SyncResult.success();
    }

    final repository = ref.read(responseRepositoryProvider);
    final keys = List<String>.from(_pendingBox.keys);

    int syncedCount = 0;
    int failedCount = 0;
    int conflictCount = 0;

    for (final key in keys) {
      final json = _pendingBox.get(key);
      if (json == null) continue;

      try {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json);
        final response = FormResponse.fromJson(data);

        // Check retry count
        final retryCount = await _getRetryCount(key);
        if (retryCount >= _config.maxRetries) {
          await _handleMaxRetriesExceeded(key, response);
          failedCount++;
          continue;
        }

        // Attempt to sync
        await repository.submitResponse(response);
        await _pendingBox.delete(key);
        await _retryBox.delete(key);
        syncedCount++;
      } catch (e) {
        // Handle sync error
        await _handleSyncError(key, json, e);
        failedCount++;
      }
    }

    ref.notifyListeners();

    // Determine result
    if (failedCount == 0 && conflictCount == 0) {
      return SyncResult.success(syncedCount: syncedCount);
    } else if (syncedCount > 0) {
      return SyncResult.partial(
        syncedCount: syncedCount,
        failedCount: failedCount,
        conflictCount: conflictCount,
      );
    } else {
      return SyncResult.failure('Sync failed for all items');
    }
  }

  /// Handles a sync error with retry logic
  Future<void> _handleSyncError(String key, dynamic json, Object error) async {
    final retryCount = await _incrementRetryCount(key);

    // Check if this is a conflict (e.g., 409 Conflict)
    if (error.toString().contains('409') ||
        error.toString().contains('conflict')) {
      await _createConflict(key, json, error);
    }

    // Log the error
    // ignore: avoid_print
    print(
      'Sync failed for $key (attempt ${retryCount + 1}/$_config.maxRetries): $error',
    );

    // Calculate next retry delay with exponential backoff
    final delay = _calculateRetryDelay(retryCount);
    // ignore: avoid_print
    print('Next retry in ${delay.inSeconds} seconds');

    // Schedule retry if not at max
    if (retryCount < _config.maxRetries) {
      Future.delayed(delay, () {
        syncPendingSubmissions();
      });
    }
  }

  /// Creates a conflict record for manual resolution
  Future<void> _createConflict(String key, dynamic json, Object error) async {
    final conflictId = _conflictRepo.generateConflictId();
    final conflict = SyncConflict(
      id: conflictId,
      localId: key,
      type: ConflictType.concurrentModification,
      localTimestamp: DateTime.now(),
      remoteTimestamp: DateTime.now(),
      localData: Map<String, dynamic>.from(json),
      remoteData: {},
      entityType: 'FormResponse',
      status: ConflictStatus.pending,
    );
    await _conflictRepo.createConflict(conflict);
  }

  /// Handles items that exceeded max retries
  Future<void> _handleMaxRetriesExceeded(
    String key,
    FormResponse response,
  ) async {
    // Create a conflict for manual review
    final conflictId = _conflictRepo.generateConflictId();
    final conflict = SyncConflict(
      id: conflictId,
      localId: key,
      type: ConflictType.versionMismatch,
      localTimestamp: DateTime.now(),
      remoteTimestamp: DateTime.now(),
      localData: response.toJson(),
      remoteData: {},
      entityType: 'FormResponse',
      status: ConflictStatus.pending,
      resolutionNote: 'Max retries exceeded',
      retryCount: _config.maxRetries,
    );
    await _conflictRepo.createConflict(conflict);
  }

  /// Gets the current retry count for an item
  Future<int> _getRetryCount(String key) async {
    return _retryBox.get(key, defaultValue: 0);
  }

  /// Increments the retry count for an item
  Future<int> _incrementRetryCount(String key) async {
    final currentCount = await _getRetryCount(key);
    final newCount = currentCount + 1;
    await _retryBox.put(key, newCount);
    return newCount;
  }

  /// Resets the retry count for an item
  Future<void> _resetRetryCount(String key) async {
    await _retryBox.put(key, 0);
  }

  /// Calculates retry delay with exponential backoff
  Duration _calculateRetryDelay(int retryCount) {
    final delay =
        _config.initialRetryDelay *
        (math.pow(_config.backoffMultiplier, retryCount));
    return delay > _config.maxRetryDelay ? _config.maxRetryDelay : delay;
  }

  /// Gets all pending submissions
  List<FormResponse> getPendingSubmissions() {
    return _pendingBox.values
        .map((json) => FormResponse.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  /// Gets all pending conflicts
  Future<List<SyncConflict>> getPendingConflicts() async {
    return _conflictRepo.getPendingConflicts();
  }

  /// Resolves a conflict
  Future<void> resolveConflict(
    String conflictId,
    ConflictStatus status, {
    Map<String, dynamic>? mergedData,
    String? resolutionNote,
  }) async {
    await _conflictRepo.resolveConflict(
      conflictId,
      status,
      mergedData: mergedData,
      resolutionNote: resolutionNote,
    );
  }

  /// Checks if there are pending submissions
  bool get hasPendingSubmissions => _pendingBox.isNotEmpty;

  /// Gets the count of pending submissions
  int get pendingCount => _pendingBox.length;

  /// Checks if there are pending conflicts
  Future<bool> get hasPendingConflicts async {
    final count = await _conflictRepo.getPendingConflictCount();
    return count > 0;
  }

  /// Gets the count of pending conflicts
  Future<int> get pendingConflictCount async {
    return _conflictRepo.getPendingConflictCount();
  }
}
