import 'dart:async';
import 'package:dio/dio.dart';
import '../network/token_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

/// Auth interceptor that handles JWT token management and refresh.
///
/// Responsibilities:
/// - Add access token to all requests (except auth endpoints)
/// - Add organization ID header for multi-tenancy
/// - Automatically refresh expired tokens
/// - Handle concurrent refresh requests with locking
class AuthInterceptor extends QueuedInterceptor {
  final AuthTokens? Function() _getTokens;
  final Future<void> Function() _clearTokens;
  final AuthRepositoryImpl Function() _getAuthRepository;
  final Function() _onNavigateToLogin;
  final Dio _dio;

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
      if (err.requestOptions.extra['_retried'] == true) {
        await _clearTokens();
        _onNavigateToLogin();
        return handler.next(err);
      }

      if (_isRefreshing) {
        return await _waitForRefresh(err, handler);
      }

      return await _performRefresh(err, handler);
    }

    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/') ||
        path.contains('/login') ||
        path.contains('/register') ||
        path.contains('/generate-otp') ||
        path.contains('/request-password-reset');
  }

  Future<void> _waitForRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await _refreshCompleter?.future;

      final newTokens = _getTokens();
      final newAccessToken = newTokens?.accessToken;

      if (newAccessToken != null) {
        return _retry(err.requestOptions, newAccessToken, handler);
      } else {
        return handler.next(err);
      }
    } catch (e) {
      return handler.next(err);
    }
  }

  Future<void> _performRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
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
