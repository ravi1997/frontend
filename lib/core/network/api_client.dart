import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'token_service.dart';
import 'auth_interceptor.dart';
import 'unified_network_interceptor.dart';
import '../widgets/snackbar_service.dart';
import 'api_endpoints.dart';
import 'app_config.dart';

part 'api_client.g.dart';

/// Dio HTTP client provider with authentication, error handling, and retry logic.
///
/// This provider creates and configures a Dio instance with:
/// - JWT authentication with automatic token refresh
/// - Request/response logging for debugging
/// - Centralized error handling and user notifications
/// - Connection and timeout configurations
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      // sendTimeout is a no-op on the web platform; kept for parity on native.
      sendTimeout: kIsWeb ? Duration.zero : const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // For browser fetch requests:
      //   - withCredentials: only set to true when cookie-based session auth is
      //     in use.  When bearer-token auth is the primary mode (default), leave
      //     this false so the browser sends simple-mode requests and avoids the
      //     extra preflight round-trip for most endpoints.
      //
      // Controlled by AppConfig.useCookieCredentials (dart-define:
      // USE_COOKIE_CREDENTIALS=true/false, default false).
      extra: {
        if (kIsWeb) 'withCredentials': AppConfig.useCookieCredentials,
      },
      validateStatus: (status) {
        return status != null && status >= 200 && status < 400;
      },
    ),
  );

  final tokenService = ref.read(tokenServiceProvider.notifier);
  final snackbarService = ref.read(snackbarServiceProvider.notifier);

  // Add unified network interceptor (handles retry, error, and envelope parsing)
  dio.interceptors.add(
    UnifiedNetworkInterceptor(snackbarService: snackbarService),
  );

  // Add authentication interceptor
  dio.interceptors.add(
    AuthInterceptor(
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
    ),
  );

  // Add logging interceptor (add last to log everything including retries)
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
}
