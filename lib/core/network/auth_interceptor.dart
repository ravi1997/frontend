import 'package:dio/dio.dart';
import '../network/token_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class AuthInterceptor extends QueuedInterceptor {
  final AuthTokens? Function() _getTokens;
  final Future<void> Function() _clearTokens;
  final AuthRepositoryImpl Function() _getAuthRepository;
  final Function() _onNavigateToLogin;
  final Dio _dio;

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
    final token = _getTokens()?.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.extra['_retried'] == true) {
        await _clearTokens();
        _onNavigateToLogin();
        return handler.next(err);
      }

      final currentTokens = _getTokens();
      final accessToken = currentTokens?.accessToken;
      final refreshToken = currentTokens?.refreshToken;

      if (refreshToken == null) {
        await _clearTokens();
        _onNavigateToLogin();
        return handler.next(err);
      }

      // Check if the token in the request is different from current storage
      // This happens if a previous request already refreshed the token
      final requestToken = err.requestOptions.headers['Authorization']
          ?.toString()
          .replaceFirst('Bearer ', '');

      if (accessToken != null && requestToken != accessToken) {
        // Token has already been refreshed
        return _retry(err.requestOptions, accessToken, handler);
      }

      try {
        final repo = _getAuthRepository();
        final newAccessToken = await repo.refreshToken(refreshToken);

        return _retry(err.requestOptions, newAccessToken, handler);
      } catch (e) {
        // Refresh failed (or concurrent refresh failed and we are seeing it)
        await _clearTokens();
        _onNavigateToLogin();
        return handler.next(err);
      }
    }
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
