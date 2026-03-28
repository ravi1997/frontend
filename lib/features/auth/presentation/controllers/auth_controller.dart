import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/token_service.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../responses/data/services/sync_service.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    final tokenState = ref.watch(tokenServiceProvider);

    return tokenState.when(
      data: (tokens) async {
        if (tokens.accessToken == null) return null;
        try {
          final repo = ref.read(authRepositoryImplProvider);
          return await repo.getCurrentUser();
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (_, _) => null,
    );
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      final user = await repo.login(identifier, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> loginWithOtp(String mobile, String otp) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      final user = await repo.loginWithOtp(mobile, otp);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> generateOtp(String mobile) async {
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.generateOtp(mobile);
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.logout();
      // Clear offline data on logout
      await ref.read(syncServiceProvider.notifier).clearData();
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String userType,
    String? employeeId,
    String? mobile,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.register(
        username: username,
        email: email,
        password: password,
        userType: userType,
        employeeId: employeeId,
        mobile: mobile,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.requestPasswordReset(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(ErrorHandler.handle(e), st);
    }
  }
}
