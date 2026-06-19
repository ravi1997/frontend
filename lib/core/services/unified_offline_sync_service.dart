import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus {
  idle,
  syncing,
  conflict,
  error,
  completed,
}

class SyncState {
  final SyncStatus status;
  final String? errorMessage;
  final int pendingCount;
  final int syncedCount;
  final int conflictCount;
  final DateTime? lastSyncAt;

  const SyncState({
    this.status = SyncStatus.idle,
    this.errorMessage,
    this.pendingCount = 0,
    this.syncedCount = 0,
    this.conflictCount = 0,
    this.lastSyncAt,
  });
}

final unifiedOfflineSyncServiceProvider =
    AsyncNotifierProvider<UnifiedOfflineSyncService, SyncState>(
  UnifiedOfflineSyncService.new,
);

class UnifiedOfflineSyncService extends AsyncNotifier<SyncState> {
  @override
  Future<SyncState> build() async {
    return const SyncState();
  }

  Future<void> performFullSync() async {}

  Future<String> saveOfflineResponse({
    required String formId,
    required Map<String, dynamic> responseData,
    required DateTime submittedAt,
  }) async {
    return '';
  }

  Future<List<Object>> getPendingResponses() async => const [];

  Future<void> syncPendingResponses() async {}

  Future<void> dispose() async {}
}
