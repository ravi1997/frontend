import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/token_service.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    // Watch token service to rebuild when token changes (e.g., on login/logout)
    final tokenAsync = ref.watch(tokenServiceProvider);

    return tokenAsync.when(
      data: (token) async {
        if (token == null) return null;
        try {
          final repo = ref.read(authRepositoryImplProvider);
          return await repo.getCurrentUser();
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      final user = await repo.login(identifier, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithOtp(String mobile, String otp) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      final user = await repo.loginWithOtp(mobile, otp);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> generateOtp(String mobile) async {
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.generateOtp(mobile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryImplProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
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
      // After registration, we might want to log in automatically or steer user to login
      // For now, let's just clear the loading state.
      // The register screen listener will handle navigation based on success.
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.requestPasswordReset(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
