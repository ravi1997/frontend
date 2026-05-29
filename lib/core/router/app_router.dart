import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/project_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/form_dashboard_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/form_builder/presentation/pages/form_builder_page.dart';
import '../../features/responses/presentation/pages/response_list_page.dart';
import '../../features/responses/presentation/pages/response_detail_page.dart';
import 'package:frontend/models/form_models.dart';
import '../../features/form_builder/presentation/pages/form_preview_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/form_builder/presentation/pages/form_submit_page.dart';

import '../../core/widgets/error_state_widget.dart';

part 'app_router.g.dart';

@riverpod
Raw<GoRouter> appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      body: ErrorStateWidget(
        title: 'Page not found',
        message: 'The page you are looking for doesn\'t exist or was moved.',
        error: state.error?.toString(),
        onBack: () => context.go('/'),
      ),
    ),
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
      final isPublicPath = state.matchedLocation.startsWith('/f/');

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuth && !isAuthPath && !isPublicPath) {
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
        if (isAdminOnly && !user.hasAtLeastRole('admin')) return '/';
        if (isSuperAdminOnly && !user.hasAtLeastRole('superadmin')) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
      GoRoute(
        path: '/projects/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return ProjectDashboardPage(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/projects/:projectId/forms/:formId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final formId = state.pathParameters['formId']!;
          return FormDashboardPage(projectId: projectId, formId: formId);
        },
      ),
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
        path: '/projects/:projectId/forms/:formId/edit',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final formId = state.pathParameters['formId'] ?? 'new';
          final mode = state.uri.queryParameters['mode'];
          return FormBuilderPage(
            formId: formId,
            projectId: projectId,
            mode: mode,
          );
        },
      ),
      GoRoute(
        path: '/projects/:projectId/forms/:formId/responses',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final formId = state.pathParameters['formId']!;
          return ResponseListPage(projectId: projectId, formId: formId);
        },
      ),
      GoRoute(
        path: '/projects/:projectId/forms/:formId/responses/:responseId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final formId = state.pathParameters['formId']!;
          final responseId = state.pathParameters['responseId']!;
          return ResponseDetailPage(
            projectId: projectId,
            formId: formId,
            responseId: responseId,
          );
        },
      ),
      GoRoute(
        path: '/form-preview',
        builder: (context, state) {
          final form = state.extra as BuilderForm;
          return FormPreviewPage(
            form: form,
            projectId: state.uri.queryParameters['projectId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/projects/:projectId/f/:formId',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final projectId = state.pathParameters['projectId']!;
          return FormSubmitPage(formId: formId, projectId: projectId);
        },
      ),
      GoRoute(
        path: '/projects/:projectId/forms/:formId/analytics',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final projectId = state.pathParameters['projectId']!;
          return AnalyticsPage(formId: formId, projectId: projectId);
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
