import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/analytics/pages/analytics_page.dart';
import 'package:frontend/modules/auth/auth_screens.dart';
import 'package:frontend/modules/dashboard/dashboard_page.dart';
import 'package:frontend/modules/dashboard/form_dashboard_page.dart';
import 'package:frontend/modules/dashboard/project_dashboard_page.dart';
import 'package:frontend/modules/forms/pages/form_builder_page.dart';
import 'package:frontend/modules/forms/pages/form_preview_page.dart';
import 'package:frontend/modules/forms/pages/form_submit_page.dart';
import 'package:frontend/modules/form_builder/responses/pages/response_detail_page.dart';
import 'package:frontend/modules/form_builder/responses/pages/response_list_page.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/modules/platform/screens/organization_management_screen.dart';
import 'package:frontend/modules/platform/screens/feature_flags_screen.dart';
import 'package:frontend/modules/platform/screens/ai_ops_screen.dart';

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
      final isOidcCallback = state.matchedLocation == '/oidc/callback';
      final isAuthPath =
          isLoggingIn || isRegistering || isForgotPassword || isVerifyingOtp || isOidcCallback;
      final isPublicPath = state.matchedLocation.contains('/f/');

      if (!isAuth && !isAuthPath && !isPublicPath) return '/login';
      if (isAuth && isAuthPath) return '/';

      if (isAuth) {
        final user = authState.value!;
        final isAdminOnly = state.matchedLocation == '/user-management';
        final isSuperAdminOnly = state.matchedLocation == '/backend-settings' ||
            state.matchedLocation.startsWith('/admin');
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
        path: '/oidc/callback',
        builder: (context, state) {
          final code = state.uri.queryParameters['code'] ?? '';
          final callbackState = state.uri.queryParameters['state'] ?? '';
          return OidcCallbackScreen(code: code, state: callbackState);
        },
      ),
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
      GoRoute(
        path: '/admin/orgs',
        builder: (context, state) => const OrganizationManagementScreen(),
      ),
      GoRoute(
        path: '/admin/feature-flags',
        builder: (context, state) => const FeatureFlagsScreen(),
      ),
      GoRoute(
        path: '/admin/ai-ops',
        builder: (context, state) => const AIOpsScreen(),
      ),
    ],
  );

  ref.listen<AsyncValue>(authControllerProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});
