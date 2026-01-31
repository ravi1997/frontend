import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/form_builder/presentation/pages/form_builder_page.dart';
import '../../../features/responses/presentation/pages/response_list_page.dart';
import '../../../features/responses/presentation/pages/response_detail_page.dart';
import '../../../features/form_builder/domain/entities/builder_form.dart';
import '../../../features/form_builder/presentation/pages/form_preview_page.dart';
import '../../../features/analytics/presentation/pages/analytics_page.dart';

part 'app_router.g.dart';

@riverpod
Raw<GoRouter> appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // If still loading, don't redirect
      if (authState.isLoading) {
        return null;
      }

      final isAuth = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isForgotPassword = state.matchedLocation == '/forgot-password';
      final isAuthPath = isLoggingIn || isRegistering || isForgotPassword;

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuth && !isAuthPath) {
        return '/login';
      }

      // If authenticated and on auth page, redirect to dashboard
      if (isAuth && isAuthPath) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/builder/:formId',
        builder: (context, state) {
          final formId = state.pathParameters['formId'] ?? 'new';
          return FormBuilderPage(formId: formId);
        },
      ),
      GoRoute(
        path: '/forms/:formId/responses',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          return ResponseListPage(formId: formId);
        },
      ),
      GoRoute(
        path: '/responses/:responseId',
        builder: (context, state) {
          final responseId = state.pathParameters['responseId']!;
          return ResponseDetailPage(responseId: responseId);
        },
      ),
      GoRoute(
        path: '/form-preview',
        builder: (context, state) {
          final form = state.extra as BuilderForm;
          return FormPreviewPage(form: form);
        },
      ),
      GoRoute(
        path: '/forms/:formId/analytics',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          return AnalyticsPage(formId: formId);
        },
      ),
    ],
  );

  // Listen to auth changes and refresh router
  ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
}
