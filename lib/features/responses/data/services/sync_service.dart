import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/data/repositories/mock_response_repository.dart';

part 'sync_service.g.dart';

@riverpod
class SyncService extends _$SyncService {
  late Box _box;

  @override
  Future<void> build() async {
    _box = await Hive.openBox('pending_submissions');

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

  Future<void> addPendingSubmission(FormResponse response) async {
    await _box.put(response.id, response.toJson());
    // Trigger build to update state (optional, depends if UI listens to state)
    ref.notifyListeners();
  }

  Future<void> syncPendingSubmissions() async {
    if (_box.isEmpty) return;

    final repository = ref.read(responseRepositoryProvider);
    final keys = List<String>.from(_box.keys);

    for (final key in keys) {
      final json = _box.get(key);
      try {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json);
        final response = FormResponse.fromJson(data);
        await repository.submitResponse(response);
        await _box.delete(key);
        print('Synced submission: $key');
      } catch (e) {
        print('Failed to sync submission $key: $e');
      }
    }
    ref.notifyListeners();
  }

  List<FormResponse> getPendingSubmissions() {
    return _box.values
        .map((json) => FormResponse.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  bool get hasPendingSubmissions => _box.isNotEmpty;
  int get pendingCount => _box.length;
}
