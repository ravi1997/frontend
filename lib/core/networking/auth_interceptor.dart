import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'token_service.dart';

/// Auth interceptor that handles JWT token management.
///
/// Responsibilities:
/// - Add access token to all requests except credential-less auth endpoints
/// - Add organization ID header for multi-tenancy
/// - Attach CSRF headers when cookie auth is in use
///
/// NOTE: `/auth/logout` still receives the bearer token because the backend
/// revokes the current session server-side.
class AuthInterceptor extends QueuedInterceptor {
  static const _uuid = Uuid();
  final Dio _dio;
  final AuthTokens? Function() _getTokens;
  final Future<void> Function() _clearTokens;
  final Function() _onNavigateToLogin;
  final String? Function() _getCsrfToken;
  final Future<String?> Function(String refreshToken) _refreshAccessToken;

  AuthInterceptor({
    required Dio dio,
    required AuthTokens? Function() getTokens,
    required Future<void> Function() clearTokens,
    required Function() onNavigateToLogin,
    required Future<String?> Function(String refreshToken) refreshAccessToken,
    String? Function()? getCsrfToken,
  }) : _dio = dio,
       _getTokens = getTokens,
       _clearTokens = clearTokens,
       _onNavigateToLogin = onNavigateToLogin,
       _refreshAccessToken = refreshAccessToken,
       _getCsrfToken = getCsrfToken ?? (() => null);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('X-Request-ID', () => _uuid.v4());

    final isAuthPath = _isAuthEndpoint(options.path);

    if (!isAuthPath) {
      final token = _getTokens()?.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      final organizationId = _getTokens()?.organizationId;
      if (organizationId != null) {
        options.headers['X-Organization-ID'] = organizationId;
      }
    }

    // CSRF is orthogonal to Bearer token injection: in cookie-auth mode the
    // backend can require `X-CSRF-TOKEN-ACCESS` even for credential-less auth
    // endpoints (e.g. login/refresh) that set cookies.
    final needsCsrf = _requiresCsrf(options.method);
    if (needsCsrf) {
      final csrfToken = _getCsrfToken();
      if (csrfToken != null && csrfToken.isNotEmpty) {
        options.headers['X-CSRF-TOKEN-ACCESS'] = csrfToken;
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthPath = _isAuthEndpoint(err.requestOptions.path);

    if (err.response?.statusCode == 401 && !isAuthPath) {
      final tokens = _getTokens();
      final refreshToken = tokens?.refreshToken;
      final alreadyRetried =
          err.requestOptions.extra['auth_interceptor_retried'] == true;

      if (refreshToken != null && !alreadyRetried) {
        final accessToken = await _refreshAccessToken(refreshToken);
        if (accessToken != null) {
          final retryOptions = err.requestOptions.copyWith(
            headers: Map<String, dynamic>.from(err.requestOptions.headers)
              ..remove('Authorization'),
            extra: Map<String, dynamic>.from(err.requestOptions.extra)
              ..['auth_interceptor_retried'] = true,
          );
          try {
            final response = await _dio.fetch(retryOptions);
            return handler.resolve(response);
          } on DioException {
            // Fall through to the token-clear path below.
          }
        }
      }

      await _clearTokens();
      _onNavigateToLogin();
      return handler.next(err);
    }

    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    final normalized = Uri.parse(path).path;
    const authPaths = <String>{
      '/auth/login',
      '/auth/register',
      '/auth/otp',
      '/auth/request-otp',
      '/auth/refresh',
      '/auth/request-password-reset',
      '/generate-otp',
    };
    return authPaths.contains(normalized);
  }

  bool _requiresCsrf(String method) {
    switch (method.toUpperCase()) {
      case 'POST':
      case 'PUT':
      case 'PATCH':
      case 'DELETE':
        return true;
      default:
        return false;
    }
  }
}
