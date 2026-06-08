import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_service.dart';
import 'auth_interceptor.dart';
import 'unified_network_interceptor.dart';
import 'package:frontend/modules/auth/auth_service.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'api_endpoints.dart';
import 'app_config.dart';
import 'web_cookie_store.dart'
    if (dart.library.html) 'web_cookie_store_web.dart';

/// Dio HTTP client provider with authentication, error handling, and retry logic.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: kIsWeb ? Duration.zero : const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      extra: {if (kIsWeb) 'withCredentials': AppConfig.useCookieCredentials},
      validateStatus: (status) {
        return status != null && status >= 200 && status < 400;
      },
    ),
  );

  final tokenService = ref.read(tokenServiceProvider.notifier);
  final snackbarService = ref.read(snackbarServiceProvider);
  final authService = AuthService(dio, tokenService);

  dio.interceptors.add(
    UnifiedNetworkInterceptor(snackbarService: snackbarService),
  );

  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      getTokens: () {
        if (!ref.mounted) return null;
        return ref.read(tokenServiceProvider).value;
      },
      clearTokens: () async {
        if (!ref.mounted) return;
        await tokenService.clearTokens();
      },
      onNavigateToLogin: () {
        if (!ref.mounted) return;
      },
      refreshAccessToken: (refreshToken) => authService.refreshToken(refreshToken),
      getCsrfToken: () => readCookieValue('X-CSRF-TOKEN-ACCESS'),
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (obj) {},
    ),
  );

  ref.onDispose(() {
    dio.close(force: true);
  });

  return dio;
});
