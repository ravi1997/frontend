import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/token_service.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<User?> {
  String? _cachedAccessToken;
  User? _cachedUser;

  @override
  FutureOr<User?> build() async {
    final tokenState = ref.watch(tokenServiceProvider);
    final tokens = tokenState.asData?.value;
    final accessToken = tokens?.accessToken;

    if (accessToken == null) {
      _cachedAccessToken = null;
      _cachedUser = null;
      return null;
    }

    if (_cachedAccessToken == accessToken && _cachedUser != null) {
      return _cachedUser;
    }

    try {
      final repo = ref.read(authRepositoryImplProvider);
      final user = await repo.getCurrentUser();
      if (!ref.mounted) return null;
      _cachedAccessToken = accessToken;
      _cachedUser = user;
      return user;
    } catch (e) {
      debugPrint('AuthController build failed to load current user: $e');
      return null;
    }
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      return repo.login(identifier, password);
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> loginWithOtp(String mobile, String otp) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      return repo.loginWithOtp(mobile, otp);
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> requestOtp(String mobile) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.requestOtp(mobile);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.logout();
    } finally {
      _cachedAccessToken = null;
      _cachedUser = null;
      if (ref.mounted) {
        state = const AsyncValue.data(null);
      }
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
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.register(
        username: username,
        email: email,
        password: password,
        employeeId: employeeId,
        mobile: mobile,
      );
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.requestPasswordReset(email);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> revokeAll() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.revokeAll();
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<User?>(() async {
      final repo = ref.read(authRepositoryImplProvider);
      await repo.changePassword(currentPassword, newPassword);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }
}
