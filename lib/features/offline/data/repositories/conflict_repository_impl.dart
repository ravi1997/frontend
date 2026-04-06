import 'package:frontend/features/offline/domain/entities/sync_conflict.dart';
import 'package:frontend/features/offline/domain/repositories/conflict_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Hive-based implementation of ConflictRepository
class ConflictRepositoryImpl implements ConflictRepository {
  String _boxName = 'sync_conflicts';
  Box? _box;
  final Uuid _uuid = const Uuid();

  ConflictRepositoryImpl();

  Future<void> init({String userId = 'default', String tenantId = 'default_tenant'}) async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
    _boxName = 'sync_conflicts_${tenantId}_$userId';
    _box = await Hive.openBox(_boxName);
  }

  Future<void> clearData() async {
    if (_box != null) {
      await _box!.clear();
      await _box!.close();
      _box = null;
    }
  }

  @override
  Future<List<SyncConflict>> getPendingConflicts() async {
    if (_box == null) return [];
    return _box!.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status == ConflictStatus.pending)
        .toList();
  }

  @override
  Future<List<SyncConflict>> getConflictsByType(String entityType) async {
    if (_box == null) return [];
    return _box!.values
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
    if (_box == null) return null;
    final json = _box!.get(conflictId);
    if (json == null) return null;
    return SyncConflict.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> createConflict(SyncConflict conflict) async {
    if (_box == null) return;
    await _box!.put(conflict.id, conflict.toJson());
  }

  @override
  Future<void> resolveConflict(
    String conflictId,
    ConflictStatus status, {
    Map<String, dynamic>? mergedData,
    String? resolutionNote,
  }) async {
    if (_box == null) return;
    final conflict = await getConflict(conflictId);
    if (conflict == null) return;

    final resolved = conflict.copyWith(
      status: status,
      resolutionNote: resolutionNote,
    );

    await _box!.put(conflictId, resolved.toJson());
  }

  @override
  Future<void> deleteConflict(String conflictId) async {
    if (_box == null) return;
    await _box!.delete(conflictId);
  }

  @override
  Future<int> getPendingConflictCount() async {
    if (_box == null) return 0;
    return _box!.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status == ConflictStatus.pending)
        .length;
  }

  @override
  Future<void> clearResolvedConflicts() async {
    if (_box == null) return;
    final keysToDelete = _box!.values
        .map((json) => SyncConflict.fromJson(Map<String, dynamic>.from(json)))
        .where((conflict) => conflict.status != ConflictStatus.pending)
        .map((conflict) => conflict.id)
        .toList();

    for (final key in keysToDelete) {
      await _box!.delete(key);
    }
  }

  /// Creates a new conflict ID
  String generateConflictId() {
    return _uuid.v4();
  }
}
