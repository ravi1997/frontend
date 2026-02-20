import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/form_builder/presentation/pages/form_builder_page.dart';
import '../../features/responses/presentation/pages/response_list_page.dart';
import '../../features/responses/presentation/pages/response_detail_page.dart';
import '../../features/form_builder/domain/entities/builder_form.dart';
import '../../features/form_builder/presentation/pages/form_preview_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/form_builder/presentation/pages/translator_page.dart';
import '../../features/form_builder/presentation/pages/version_history_page.dart';
import '../../features/form_builder/presentation/pages/workflow_builder_page.dart';
import '../../features/form_builder/presentation/pages/create_template_page.dart';
import '../../features/user_management/presentation/pages/user_management_page.dart';
import '../../features/backend_settings/presentation/pages/backend_settings_page.dart';

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
      final isVerifyingOtp = state.matchedLocation == '/verify-otp';
      final isAuthPath =
          isLoggingIn || isRegistering || isForgotPassword || isVerifyingOtp;

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuth && !isAuthPath) {
        return '/login';
      }

      // If authenticated and on auth page, redirect to dashboard
      if (isAuth && isAuthPath) {
        return '/';
      }

      // Admin only routes
      if (isAuth) {
        final user = authState.value!;
        final isAdminOnly = state.matchedLocation == '/user-management';
        final isSuperAdminOnly = state.matchedLocation == '/backend-settings';
        if (isAdminOnly && !user.isAdmin) {
          return '/';
        }
        if (isSuperAdminOnly && !user.roles.contains('superadmin')) {
          return '/';
        }
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
        path: '/verify-otp',
        builder: (context, state) {
          final mobile = state.uri.queryParameters['mobile'] ?? '';
          return OtpVerificationScreen(mobile: mobile);
        },
      ),
      GoRoute(
        path: '/builder/:formId',
        builder: (context, state) {
          final formId = state.pathParameters['formId'] ?? 'new';
          final mode = state.uri.queryParameters['mode'];
          return FormBuilderPage(formId: formId, mode: mode);
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
      GoRoute(
        path: '/forms/:formId/translate',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          return TranslatorPage(formId: formId);
        },
      ),
      GoRoute(
        path: '/forms/:formId/versions',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final formTitle = state.uri.queryParameters['title'];
          return VersionHistoryPage(formId: formId, formTitle: formTitle);
        },
      ),
      GoRoute(
        path: '/forms/:formId/workflows',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final workflowId = state.uri.queryParameters['workflowId'];
          return WorkflowBuilderPage(formId: formId, workflowId: workflowId);
        },
      ),
      GoRoute(
        path: '/templates/create',
        builder: (context, state) => const CreateTemplatePage(),
      ),
      GoRoute(
        path: '/user-management',
        builder: (context, state) => const UserManagementPage(),
      ),
      GoRoute(
        path: '/backend-settings',
        builder: (context, state) => const BackendSettingsPage(),
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
