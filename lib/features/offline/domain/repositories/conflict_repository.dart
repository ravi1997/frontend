import 'package:frontend/features/offline/domain/entities/sync_conflict.dart';

/// Repository interface for managing sync conflicts
abstract class ConflictRepository {
  /// Gets all pending conflicts
  Future<List<SyncConflict>> getPendingConflicts();

  /// Gets conflicts by entity type
  Future<List<SyncConflict>> getConflictsByType(String entityType);

  /// Gets a specific conflict by ID
  Future<SyncConflict?> getConflict(String conflictId);

  /// Creates a new conflict record
  Future<void> createConflict(SyncConflict conflict);

  /// Resolves a conflict with the specified resolution
  Future<void> resolveConflict(
    String conflictId,
    ConflictStatus status, {
    Map<String, dynamic>? mergedData,
    String? resolutionNote,
  });

  /// Deletes a conflict record
  Future<void> deleteConflict(String conflictId);

  /// Gets count of pending conflicts
  Future<int> getPendingConflictCount();

  /// Clears all resolved conflicts
  Future<void> clearResolvedConflicts();

  /// Closes the repository and any underlying storage
  Future<void> close();
}
