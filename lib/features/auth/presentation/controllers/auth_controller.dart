import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/token_service.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/controllers/base_controller_mixin.dart';
import '../../../responses/data/services/sync_service.dart';
import '../../../offline/data/services/enhanced_sync_service.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController with BaseControllerMixin {
  @override
  FutureOr<User?> build() async {
    final tokenState = ref.watch(tokenServiceProvider);

    if (tokenState.isLoading) return null;
    if (tokenState.hasError) return null;

    final tokens = tokenState.value;
    if (tokens == null || tokens.accessToken == null) return null;

    try {
      final repo = ref.read(authRepositoryImplProvider);
      return await repo.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    final result = await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        return repo.login(identifier, password);
      },
    );
    if (result != null) {
      state = AsyncValue.data(result);
    }
  }

  Future<void> loginWithOtp(String mobile, String otp) async {
    state = const AsyncValue.loading();
    final result = await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        return repo.loginWithOtp(mobile, otp);
      },
    );
    if (result != null) {
      state = AsyncValue.data(result);
    }
  }

  Future<void> requestOtp(String mobile) async {
    await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        await repo.requestOtp(mobile);
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.logout();
      await ref.read(syncServiceProvider.notifier).clearData();
      await ref.read(enhancedSyncServiceProvider.notifier).clearData();
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? employeeId,
    String? mobile,
  }) async {
    state = const AsyncValue.loading();
    await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        await repo.register(
          username: username,
          email: email,
          password: password,
          employeeId: employeeId,
          mobile: mobile,
        );
        state = const AsyncValue.data(null);
      },
    );
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AsyncValue.loading();
    await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        await repo.requestPasswordReset(email);
        state = const AsyncValue.data(null);
      },
    );
  }

  Future<void> revokeAll() async {
    state = const AsyncValue.loading();
    await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        await repo.revokeAll();
        state = const AsyncValue.data(null);
      },
    );
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    state = const AsyncValue.loading();
    await executeOperation(
      operation: () async {
        final repo = ref.read(authRepositoryImplProvider);
        await repo.changePassword(currentPassword, newPassword);
        state = const AsyncValue.data(null);
      },
    );
  }
}
