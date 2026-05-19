import 'dart:async';
import 'package:dio/dio.dart';
import '../network/token_service.dart';

/// Auth interceptor that handles JWT token management.
///
/// Responsibilities:
/// - Add access token to all requests (except credential-less auth endpoints)
/// - Add organization ID header for multi-tenancy
/// - Attach auth headers to outgoing requests
///
/// IMPORTANT: /auth/logout is intentionally NOT excluded here because the
/// backend requires a valid Bearer token to revoke the session. Only the
/// credential-less paths (login, register, OTP, refresh, password-reset)
/// bypass token injection.
class AuthInterceptor extends QueuedInterceptor {
  final AuthTokens? Function() _getTokens;
  final Future<void> Function() _clearTokens;
  final Function() _onNavigateToLogin;

  AuthInterceptor({
    required AuthTokens? Function() getTokens,
    required Future<void> Function() clearTokens,
    required Function() onNavigateToLogin,
  }) : _getTokens = getTokens,
       _clearTokens = clearTokens,
       _onNavigateToLogin = onNavigateToLogin;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthPath = _isAuthEndpoint(err.requestOptions.path);

    if (err.response?.statusCode == 401 && !isAuthPath) {
      await _clearTokens();
      _onNavigateToLogin();
      return handler.next(err);
    }

    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    // These credential-less paths must bypass token injection because they
    // either don't have a token yet (login/register/OTP) or carry their own
    // specific token (refresh).
    //
    // NOTE: /auth/logout is deliberately NOT in this list — it needs the
    // session's access token so the backend can revoke it server-side.
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/otp') ||
        path.contains('/auth/request-otp') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/request-password-reset') ||
        path.contains('/generate-otp'); // legacy alias
  }
}
