import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/user_management_repository_impl.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import '../../../../core/utils/error_handler.dart';

part 'user_management_controller.g.dart';

// ─── Main users list controller ───────────────────────────────────────────────

@riverpod
class UserManagementController extends _$UserManagementController {
  @override
  FutureOr<List<User>> build() async {
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final repo = ref.read(userManagementRepositoryImplProvider);
    return await repo.getUsers();
  }

  Future<void> refreshUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUsers());
  }

  Future<void> updateDepartment(String userId, String department) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.updateUserDepartment(userId, department);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.updateUserStatus(userId, !isActive);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> updateRoles(String userId, List<String> roles) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.updateUserRoles(userId, roles);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> resetPassword(String userId, String newPassword) async {
    final repo = ref.read(userManagementRepositoryImplProvider);
    await repo.resetUserPassword(userId, newPassword);
  }

  Future<void> lockUser(String userId) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.lockUser(userId);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> unlockUser(String userId) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.unlockUser(userId);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final repo = ref.read(userManagementRepositoryImplProvider);
      await repo.deleteUser(userId);
      await refreshUsers();
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }
}

// ─── Departments provider ─────────────────────────────────────────────────────

@riverpod
Future<List<String>> departments(Ref ref) async {
  final repo = ref.read(userManagementRepositoryImplProvider);
  return await repo.getDepartments();
}

// ─── User activity provider ───────────────────────────────────────────────────

@riverpod
Future<UserActivity> userActivity(Ref ref, String userId) async {
  final repo = ref.read(userManagementRepositoryImplProvider);
  return await repo.getUserActivity(userId);
}
