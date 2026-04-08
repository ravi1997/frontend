import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/user_management_repository_impl.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import '../../../../core/controllers/base_controller_mixin.dart';

part 'user_management_controller.g.dart';

// ─── Main users list controller ───────────────────────────────────────────────

@riverpod
class UserManagementController extends _$UserManagementController
    with BaseControllerMixin {
  @override
  FutureOr<List<User>> build() async {
    return _fetchUsers();
  }

  Future<List<User>> _fetchUsers() async {
    final repo = ref.read(userManagementRepositoryImplProvider);
    return await repo.getUsers();
  }

  Future<void> refreshUsers() async {
    await executeRefresh(
      refreshOperation: () async {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchUsers());
      },
    );
  }

  Future<void> updateDepartment(String userId, String department) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.updateUserDepartment(userId, department);
        await refreshUsers();
      },
    );
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.updateUserStatus(userId, !isActive);
        await refreshUsers();
      },
    );
  }

  Future<void> updateRoles(String userId, List<String> roles) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.updateUserRoles(userId, roles);
        await refreshUsers();
      },
    );
  }

  Future<void> resetPassword(String userId, String newPassword) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.resetUserPassword(userId, newPassword);
      },
    );
  }

  Future<void> lockUser(String userId) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.lockUser(userId);
        await refreshUsers();
      },
    );
  }

  Future<void> unlockUser(String userId) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.unlockUser(userId);
        await refreshUsers();
      },
    );
  }

  Future<void> deleteUser(String userId) async {
    await executeDelete(
      id: userId,
      deleteOperation: (id) async {
        final repo = ref.read(userManagementRepositoryImplProvider);
        await repo.deleteUser(id);
      },
      refreshAfterDelete: () async {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchUsers());
      },
      entityName: 'user',
    );
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
