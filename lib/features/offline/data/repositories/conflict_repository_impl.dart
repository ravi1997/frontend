import 'package:frontend/features/offline/domain/entities/sync_conflict.dart';
import 'package:frontend/features/offline/domain/repositories/conflict_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Hive-based implementation of ConflictRepository
class ConflictRepositoryImpl implements ConflictRepository {
  static const String _boxName = 'sync_conflicts';
  late Box _box;
  final Uuid _uuid = const Uuid();

  ConflictRepositoryImpl();

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  @override
  Future<List<SyncConflict>> getPendingConflicts() async {
    await init();
    return _box.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status == ConflictStatus.pending)
        .toList();
  }

  @override
  Future<List<SyncConflict>> getConflictsByType(String entityType) async {
    await init();
    return _box.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where(
          (conflict) =>
              conflict.entityType == entityType &&
              conflict.status == ConflictStatus.pending,
        )
        .toList();
  }

  @override
  Future<SyncConflict?> getConflict(String conflictId) async {
    await init();
    final json = _box.get(conflictId);
    if (json == null) return null;
    return SyncConflict.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> createConflict(SyncConflict conflict) async {
    await init();
    await _box.put(conflict.id, conflict.toJson());
  }

  @override
  Future<void> resolveConflict(
    String conflictId,
    ConflictStatus status, {
    Map<String, dynamic>? mergedData,
    String? resolutionNote,
  }) async {
    await init();
    final conflict = await getConflict(conflictId);
    if (conflict == null) return;

    final resolved = conflict.copyWith(
      status: status,
      resolutionNote: resolutionNote,
    );

    await _box.put(conflictId, resolved.toJson());
  }

  @override
  Future<void> deleteConflict(String conflictId) async {
    await init();
    await _box.delete(conflictId);
  }

  @override
  Future<int> getPendingConflictCount() async {
    await init();
    return _box.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status == ConflictStatus.pending)
        .length;
  }

  @override
  Future<void> clearResolvedConflicts() async {
    await init();
    final keysToDelete = _box.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status != ConflictStatus.pending)
        .map((conflict) => conflict.id)
        .toList();

    for (final key in keysToDelete) {
      await _box.delete(key);
    }
  }

  /// Creates a new conflict ID
  String generateConflictId() {
    return _uuid.v4();
  }
}
