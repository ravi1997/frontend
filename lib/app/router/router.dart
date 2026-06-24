import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/analytics/pages/analytics_page.dart';
import 'package:frontend/modules/analytics/pages/analysis_boards_list_page.dart';
import 'package:frontend/modules/auth/auth_screens.dart';
import 'package:frontend/app/startup/app_shell.dart';
import 'package:frontend/modules/dashboard/dashboard_page.dart';
import 'package:frontend/modules/dashboard/form_dashboard_page.dart';
import 'package:frontend/modules/dashboard/project_dashboard_page.dart';
import 'package:frontend/modules/forms/pages/form_builder_page.dart';
import 'package:frontend/modules/forms/pages/form_version_history_page.dart';
import 'package:frontend/modules/forms/pages/form_preview_page.dart';
import 'package:frontend/modules/forms/pages/form_submit_page.dart';
import 'package:frontend/modules/forms/pages/json_ui_preview_page.dart';
import 'package:frontend/modules/forms/pages/form_viewer_page.dart';
import 'package:frontend/modules/form_builder/responses/pages/response_detail_page.dart';
import 'package:frontend/modules/form_builder/responses/pages/response_list_page.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/modules/platform/screens/organization_management_screen.dart';
import 'package:frontend/modules/platform/screens/feature_flags_screen.dart';
import 'package:frontend/modules/platform/screens/api_key_management_screen.dart';
import 'package:frontend/modules/platform/screens/webhook_management_screen.dart';
import 'package:frontend/modules/platform/screens/ai_ops_screen.dart';
import 'package:frontend/modules/dashboard_builder/pages/dashboard_builder_page.dart';
import 'package:frontend/modules/dashboard_builder/pages/public_dashboard_page.dart';
import 'package:frontend/modules/analysis_coder/screens/analysis_coder_screen.dart';

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
      final isPublicPath = state.matchedLocation.contains('/f/') ||
          state.matchedLocation.startsWith('/d/');

      if (!isAuth && !isAuthPath && !isPublicPath) return '/login';
      if (isAuth && isAuthPath) return '/';

      if (isAuth) {
        final user = authState.value!;
        final isAdminOnly = state.matchedLocation == '/user-management';
        final isSuperAdminOnly = state.matchedLocation.startsWith('/admin');
        if (isAdminOnly && !user.hasAtLeastRole('admin')) return '/';
        if (isSuperAdminOnly && !user.hasAtLeastRole('superadmin')) return '/';
      }

      return null;
    },
    routes: [
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
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
          GoRoute(
            path: '/projects/:projectId/forms/:formId',
            builder: (context, state) {
              final projectId = state.pathParameters['projectId']!;
              final formId = state.pathParameters['formId']!;
              debugPrint('ROUTE form-dashboard project=$projectId form=$formId path=${state.uri.path}');
              return FormDashboardPage(projectId: projectId, formId: formId);
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
        path: '/projects/:projectId/forms/:formId/versions',
        name: 'formVersionHistory',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final formId = state.pathParameters['formId']!;
          final title = state.uri.queryParameters['title'] ?? '';
          return FormVersionHistoryPage(
            projectId: projectId,
            formId: formId,
            formTitle: title,
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
          final form = state.extra;
          if (form is! BuilderForm) {
            return Scaffold(
              body: ErrorStateWidget(
                title: 'Preview unavailable',
                message:
                    'Open preview from the form builder so the current form can be passed into the page.',
                error: 'Missing BuilderForm route state',
                onBack: () => context.go('/'),
              ),
            );
          }
          return FormPreviewPage(
            form: form,
            projectId: state.uri.queryParameters['projectId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/json-ui-preview',
        builder: (context, state) => const JsonUiPreviewPage(),
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
        path: '/forms/:formId/view',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final formSchema = state.uri.queryParameters['schema'] ?? '{}';
          final projectId = state.uri.queryParameters['projectId'];
          return FormViewerPage(
            formId: formId,
            formSchema: formSchema,
            projectId: projectId,
          );
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
        path: '/projects/:projectId/analysis-boards',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return ProjectAnalysisBoardsListPage(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/projects/:projectId/analysis-coder',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final analysisId = state.uri.queryParameters['analysisId'];
          return AnalysisCoderScreen(
            projectId: projectId,
            analysisId: analysisId,
          );
        },
      ),
      GoRoute(
        path: '/projects/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          debugPrint('ROUTE project-dashboard project=$projectId path=${state.uri.path}');
          return ProjectDashboardPage(projectId: projectId);
        },
      ),
      // ── Dashboard Builder ──────────────────────────────────────────
      GoRoute(
        path: '/projects/:projectId/dashboards/:dashboardId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          final dashboardId = state.pathParameters['dashboardId']!;
          return DashboardBuilderPage(
            organizationId: projectId,
            dashboardId: dashboardId,
          );
        },
      ),
      // ── Public Dashboard (unauthenticated) ─────────────────────────
      GoRoute(
        path: '/d/:shareToken',
        builder: (context, state) {
          final token = state.pathParameters['shareToken']!;
          return PublicDashboardPage(shareToken: token);
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
        path: '/admin/api-keys',
        builder: (context, state) => const ApiKeyManagementScreen(),
      ),
      GoRoute(
        path: '/admin/webhooks',
        builder: (context, state) => const WebhookManagementScreen(),
      ),
      GoRoute(
        path: '/admin/ai-ops',
        builder: (context, state) => const AIOpsScreen(),
      ),
        ],
      ),
    ],
  );

  ref.listen<AsyncValue>(authControllerProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});
