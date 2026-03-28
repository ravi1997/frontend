import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';
import 'token_service.dart';
import 'auth_interceptor.dart';
import 'retry_interceptor.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../widgets/snackbar_service.dart';
import '../router/app_router.dart';
import 'error_interceptor.dart';
import 'envelope_interceptor.dart';
import 'api_endpoints.dart';

part 'api_client.g.dart';

/// Dio HTTP client provider with authentication, error handling, and retry logic.
///
/// This provider creates and configures a Dio instance with:
/// - JWT authentication with automatic token refresh
/// - Request/response logging for debugging
/// - Automatic retry on network failures
/// - Centralized error handling and user notifications
/// - Connection and timeout configurations
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Validate status codes 2xx and 3xx as successful
      validateStatus: (status) {
        return status != null && status >= 200 && status < 400;
      },
    ),
  );

  final tokenService = ref.read(tokenServiceProvider.notifier);
  final snackbarService = ref.read(snackbarServiceProvider.notifier);

  // Add retry interceptor first (before auth to retry auth failures too)
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      logger: logger,
      maxRetries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ),
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
      getAuthRepository: () {
        if (!ref.mounted) throw Exception('Provider disposed');
        return ref.read(authRepositoryImplProvider) as AuthRepositoryImpl;
      },
      onNavigateToLogin: () {
        if (!ref.mounted) return;
        ref.read(appRouterProvider).go('/login');
      },
      dio: dio,
    ),
  );

  // Add envelope unwrapping interceptor
  dio.interceptors.add(EnvelopeInterceptor());

  // Add error interceptor for user-friendly error messages
  dio.interceptors.add(ErrorInterceptor(snackbarService));

  // Add logging interceptor (add last to log everything including retries)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (obj) {
        logger.d(obj);
      },
    ),
  );

  ref.onDispose(() {
    dio.close(force: true);
  });

  return dio;
}
