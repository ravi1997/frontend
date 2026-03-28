import 'package:frontend/core/services/connectivity_service.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/features/responses/data/repositories/response_repository_impl.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';

part 'sync_service.g.dart';

@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  Box? _box;
  String? _currentUserId;

  @override
  Future<void> build() async {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    if (user == null) {
      if (_box != null) {
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
      // Scoping box by userId to prevent data leakage between users
      _box = await Hive.openBox('pending_submissions_${user.id}');
    }

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
    if (_box == null) return;
    await _box!.put(response.id, response.toJson());
    ref.notifyListeners();
  }

  Future<void> syncPendingSubmissions() async {
    if (_box == null || _box!.isEmpty) return;

    final repository = ref.read(responseRepositoryProvider);
    final keys = List<String>.from(_box!.keys);

    for (final key in keys) {
      final json = _box!.get(key);
      try {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json);
        final response = FormResponse.fromJson(data);
        
        // Ensure we only sync if the user is still logged in and matches
        if (_currentUserId == null) break;

        await repository.submitResponse(response);
        await _box!.delete(key);
        // ignore: avoid_print
        print('Synced submission: $key for user $_currentUserId');
      } catch (e) {
        // ignore: avoid_print
        print('Failed to sync submission $key: $e');
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
    return _box!.values
        .map((json) => FormResponse.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  bool get hasPendingSubmissions => _box?.isNotEmpty ?? false;
  int get pendingCount => _box?.length ?? 0;
}
