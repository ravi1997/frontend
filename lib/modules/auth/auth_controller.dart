// lib/features/auth/auth_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/modules/auth/auth_models.dart';
import 'package:frontend/modules/auth/auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStore = ref.watch(tokenServiceProvider.notifier);
  return AuthService(apiClient, tokenStore);
});

final authControllerProvider = AsyncNotifierProvider<AuthController, UserModel?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<UserModel?> {
  String? _cachedAccessToken;
  UserModel? _cachedUser;

  @override
  FutureOr<UserModel?> build() async {
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
      final service = ref.read(authServiceProvider);
      final user = await service.getCurrentUser();
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
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      return service.login(identifier, password);
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> loginWithOtp(String mobile, String otp) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      return service.loginWithOtp(mobile, otp);
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> requestOtp(String mobile) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      await service.requestOtp(mobile);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(authServiceProvider);
      await service.logout();
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
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      await service.register(
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
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      await service.requestPasswordReset(email);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> revokeAll() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      await service.revokeAll();
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
    final result = await AsyncValue.guard<UserModel?>(() async {
      final service = ref.read(authServiceProvider);
      await service.changePassword(currentPassword, newPassword);
      return null;
    });
    if (!ref.mounted) return;
    state = result;
  }
}

final otpControllerProvider = NotifierProvider<OtpController, int>(
  OtpController.new,
);

class OtpController extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void startTimer() {
    _timer?.cancel();
    state = 30; // 30 seconds resend cooldown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp(String mobile) async {
    if (state > 0) return;

    await ref.read(authControllerProvider.notifier).requestOtp(mobile);
    startTimer();
  }

  bool get canResend => state == 0;
}
