import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict.freezed.dart';
part 'sync_conflict.g.dart';

/// Represents a conflict that occurs during offline synchronization
@freezed
abstract class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String id,
    required String localId,
    String? remoteId,
    required ConflictType type,
    required DateTime localTimestamp,
    required DateTime remoteTimestamp,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required String entityType,
    String? entityId,
    required ConflictStatus status,
    String? resolutionNote,
    @Default(0) int retryCount,
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
}

/// Types of conflicts that can occur
enum ConflictType {
  /// Same entity was modified both locally and remotely
  concurrentModification,

  /// Entity was deleted remotely while being edited locally
  remoteDeletion,

  /// Entity was created locally but already exists remotely
  duplicateCreation,

  /// Version mismatch during sync
  versionMismatch,
}

/// Status of a conflict resolution
enum ConflictStatus {
  /// Conflict is pending resolution
  pending,

  /// User chose to keep local changes
  resolvedLocal,

  /// User chose to keep remote changes
  resolvedRemote,

  /// User chose to merge changes
  resolvedMerge,

  /// Conflict was automatically resolved
  resolvedAuto,

  /// Conflict resolution failed
  failed,
}
