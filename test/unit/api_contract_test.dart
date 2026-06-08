import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/networking/auth_interceptor.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/core/networking/token_service.dart';

void main() {
  group('API contract constants', () {
    test('project form routes are project scoped', () {
      expect(
        ApiEndpoints.getProjectForm('project-1', 'form-1'),
        '/projects/project-1/forms/form-1',
      );
      expect(
        ApiEndpoints.saveFormDraft('project-1', 'form-1'),
        '/projects/project-1/forms/form-1/draft',
      );
      expect(
        ApiEndpoints.createProjectForm('project-1'),
        '/projects/project-1/forms',
      );
    });

    test('task status route matches backend canonical task route', () {
      expect(ApiEndpoints.taskStatus('task-1'), '/tasks/task-1');
    });

    test('OTP routes match backend auth contract', () {
      expect(ApiEndpoints.requestOtp, '/auth/request-otp');
      expect(ApiEndpoints.loginWithOtp, '/auth/login');
    });

    test('admin-adjacent routes match backend contracts', () {
      expect(ApiEndpoints.dashboardSettings, '/dashboard-settings/settings');
      expect(ApiEndpoints.webhookTest('hook-1'), '/webhooks/test');
      expect(ApiEndpoints.webhookLogs('hook-1'), '/webhooks/logs');
      expect(ApiEndpoints.nlpSearch('form-1'), '/ai/search/form-1/nlp-search');
    });

    test('project-scoped analytics and export routes are available', () {
      expect(
        ApiEndpoints.exportProjectResponses(
          'project-1',
          'form-1',
          format: 'json',
        ),
        '/projects/project-1/forms/form-1/export/json',
      );
      expect(
        ApiEndpoints.projectBulkExport('project-1'),
        '/projects/project-1/forms/export/bulk',
      );
      expect(
        ApiEndpoints.getProjectAnalytics('project-1', 'form-1'),
        '/projects/project-1/forms/form-1/analytics',
      );
    });

    test('response filter route is form scoped', () {
      expect(
        ApiEndpoints.filterResponses('form-1'),
        '/forms/form-1/responses/filter',
      );
    });
  });

  group('AuthInterceptor', () {
    test('adds request id, bearer token, and organization header', () {
      final interceptor = AuthInterceptor(
        getTokens: () => AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          organizationId: 'org-1',
        ),
        clearTokens: () async {},
        onNavigateToLogin: () {},
        getCsrfToken: () => 'csrf-token',
      );
      final options = RequestOptions(path: '/projects');
      final handler = _RequestCaptureHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer access');
      expect(options.headers['X-Organization-ID'], 'org-1');
      expect(options.headers['X-Request-ID'], isA<String>());
      expect((options.headers['X-Request-ID'] as String).isNotEmpty, isTrue);
    });

    test('adds csrf token for unsafe cookie-mode requests', () {
      final interceptor = AuthInterceptor(
        getTokens: () => AuthTokens(accessToken: 'access'),
        clearTokens: () async {},
        onNavigateToLogin: () {},
        getCsrfToken: () => 'csrf-token',
      );
      final options = RequestOptions(path: '/forms', method: 'POST');
      final handler = _RequestCaptureHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['X-CSRF-TOKEN-ACCESS'], 'csrf-token');
    });
  });
}

class _RequestCaptureHandler extends RequestInterceptorHandler {
  @override
  void next(RequestOptions requestOptions) {}
}
