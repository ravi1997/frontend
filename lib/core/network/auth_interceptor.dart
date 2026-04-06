import 'dart:async';
import 'package:dio/dio.dart';
import '../network/token_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class AuthInterceptor extends QueuedInterceptor {
  final AuthTokens? Function() _getTokens;
  final Future<void> Function() _clearTokens;
  final AuthRepositoryImpl Function() _getAuthRepository;
  final Function() _onNavigateToLogin;
  final Dio _dio;

  // Lock to prevent multiple concurrent refresh requests
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required AuthTokens? Function() getTokens,
    required Future<void> Function() clearTokens,
    required AuthRepositoryImpl Function() getAuthRepository,
    required Function() onNavigateToLogin,
    required Dio dio,
  }) : _getTokens = getTokens,
       _clearTokens = clearTokens,
       _getAuthRepository = getAuthRepository,
       _onNavigateToLogin = onNavigateToLogin,
       _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Don't add token to auth-related endpoints as they might fail or confuse the backend
    final isAuthPath =
        options.path.contains('/auth/') ||
        options.path.contains('/login') ||
        options.path.contains('/register') ||
        options.path.contains('/generate-otp') ||
        options.path.contains('/request-password-reset');

    if (!isAuthPath) {
      final token = _getTokens()?.accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Add X-Organization-ID header for tenant isolation
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
    final isAuthPath =
        err.requestOptions.path.contains('/auth/') ||
        err.requestOptions.path.contains('/login') ||
        err.requestOptions.path.contains('/register') ||
        err.requestOptions.path.contains('/generate-otp') ||
        err.requestOptions.path.contains('/request-password-reset');

    if (err.response?.statusCode == 401 && !isAuthPath) {
      // If the request was already retried, it means refresh failed or token is still invalid.
      if (err.requestOptions.extra['_retried'] == true) {
        await _clearTokens();
        _onNavigateToLogin();
        return handler.next(err);
      }

      // If a refresh is already in progress, wait for it to complete
      if (_isRefreshing) {
        try {
          // Wait for the pending refresh to complete
          await _refreshCompleter?.future;

          // Get the new token (it should be updated in storage by the refresher)
          final newTokens = _getTokens();
          final newAccessToken = newTokens?.accessToken;

          if (newAccessToken != null) {
            return _retry(err.requestOptions, newAccessToken, handler);
          } else {
            // New token not found? potentially refresh failed.
            // Let the original error proceed or maybe 401 again.
            return handler.next(err);
          }
        } catch (e) {
          // If the refresh failed, we fail too
          return handler.next(err);
        }
      }

      // Start a new refresh
      _isRefreshing = true;
      _refreshCompleter = Completer<void>();

      try {
        final currentTokens = _getTokens();
        final accessToken = currentTokens?.accessToken;
        final refreshToken = currentTokens?.refreshToken;

        if (refreshToken == null) {
          _failRefresh(handler, err);
          return;
        }

        // Double check: Check if the token in the request is different from current storage
        // This optimizes if a refresh happened between the request start and now (unlikely with lock but possible in edge cases)
        final requestToken = err.requestOptions.headers['Authorization']
            ?.toString()
            .replaceFirst('Bearer ', '');

        if (accessToken != null && requestToken != accessToken) {
          _completeRefresh();
          return _retry(err.requestOptions, accessToken, handler);
        }

        final repo = _getAuthRepository();
        final newAccessToken = await repo.refreshToken(refreshToken);

        _completeRefresh();
        return _retry(err.requestOptions, newAccessToken, handler);
      } catch (e) {
        _failRefresh(handler, err);
      }
    } else {
      handler.next(err);
    }
  }

  void _completeRefresh() {
    _isRefreshing = false;
    if (_refreshCompleter?.isCompleted == false) {
      _refreshCompleter?.complete();
    }
    _refreshCompleter = null;
  }

  Future<void> _failRefresh(
    ErrorInterceptorHandler handler,
    DioException err,
  ) async {
    _isRefreshing = false;
    if (_refreshCompleter?.isCompleted == false) {
      _refreshCompleter?.completeError(err);
    }
    _refreshCompleter = null;

    await _clearTokens();
    _onNavigateToLogin();
    handler.next(err);
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    String accessToken,
    ErrorInterceptorHandler handler,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: {...requestOptions.extra, '_retried': true},
    );

    options.headers?['Authorization'] = 'Bearer $accessToken';

    try {
      final response = await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(
          DioException(
            requestOptions: requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }
  }
}
