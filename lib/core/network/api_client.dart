import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'token_service.dart';
import 'auth_interceptor.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../widgets/snackbar_service.dart';
import '../router/app_router.dart';
import 'error_interceptor.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:5000/form/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final tokenService = ref.read(tokenServiceProvider.notifier);
  final snackbarService = ref.read(snackbarServiceProvider.notifier);

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

  dio.interceptors.add(ErrorInterceptor(snackbarService));

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  ref.onDispose(() {
    dio.close(force: true);
  });

  return dio;
}
