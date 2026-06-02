import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/auth/auth_controller.dart';
import 'package:frontend/features/analytics/presentation/pages/analytics_page.dart';
import 'package:frontend/features/auth/auth_screens.dart';
import 'package:frontend/features/dashboard/dashboard_page.dart';
import 'package:frontend/features/dashboard/form_dashboard_page.dart';
import 'package:frontend/features/dashboard/project_dashboard_page.dart';
import 'package:frontend/features/form_builder/pages/form_builder_page.dart';
import 'package:frontend/features/form_builder/pages/form_preview_page.dart';
import 'package:frontend/features/form_builder/pages/form_submit_page.dart';
import '../features/responses/pages/response_detail_page.dart';
import '../features/responses/pages/response_list_page.dart';
import 'package:frontend/core/form_models.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
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

      if (authState.isLoading) return null;

      final isAuth = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isForgotPassword = state.matchedLocation == '/forgot-password';
      final isVerifyingOtp = state.matchedLocation == '/verify-otp';
      final isAuthPath =
          isLoggingIn || isRegistering || isForgotPassword || isVerifyingOtp;
      final isPublicPath = state.matchedLocation.contains('/f/');

      if (!isAuth && !isAuthPath && !isPublicPath) return '/login';
      if (isAuth && isAuthPath) return '/';

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
          return AnalyticsPage(projectId: projectId, formId: formId);
        },
      ),
    ],
  );

  ref.listen<AsyncValue>(authControllerProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});
