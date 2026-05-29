import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'token_service.dart';
import 'auth_interceptor.dart';
import 'unified_network_interceptor.dart';
import '../widgets/snackbar_service.dart';
import 'api_endpoints.dart';
import 'app_config.dart';
import 'web_cookie_store.dart';

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
      getCsrfToken: () => readCookieValue('X-CSRF-TOKEN-ACCESS'),
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

/// HTTP API client wrapper around Dio for making REST requests.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

@riverpod
ApiClient apiClient(Ref ref) {
  final dioClient = ref.watch(dioProvider);
  return ApiClient(dioClient);
}

