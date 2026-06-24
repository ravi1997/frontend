import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/modules/dashboard/form_dashboard_page.dart';
import 'package:frontend/modules/analysis_coder/screens/analysis_coder_screen.dart';
import 'package:frontend/modules/analytics/pages/analysis_boards_list_page.dart';
import 'package:frontend/modules/analytics/analysis_dashboard.dart';
import 'package:frontend/modules/analytics/analysis_dashboard_repository.dart';
import 'package:frontend/modules/analytics/analytics_providers.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:go_router/go_router.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  final BuilderForm form;
  final Object? error;

  _FakeFormBuilderRepository(this.form, {this.error});

  @override
  Future<BuilderForm> getForm(String projectId, String id) async {
    if (error != null) {
      throw error!;
    }
    return form;
  }

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) async => form;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FailingApiClient extends ApiClient {
  _FailingApiClient() : super(Dio(BaseOptions(baseUrl: 'http://localhost')));

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    throw Exception('analysis unavailable');
  }
}

class _FakeAnalysisDashboardRepository extends AnalysisDashboardRepository {
  _FakeAnalysisDashboardRepository()
      : super(ApiClient(Dio(BaseOptions(baseUrl: 'http://localhost'))));

  @override
  Future<List<AnalysisDashboard>> listDashboards() async => const [];
}

void main() {
  testWidgets('form dashboard renders live summary data', (tester) async {
    final repo = _FakeFormBuilderRepository(
      BuilderForm(
        id: 'form-1',
        title: 'Demo Form',
        status: 'published',
        sections: const <FormSection>[],
        quickResponses: const <Map<String, dynamic>>[
          {'name': 'Quick preset 1'},
        ],
      ),
    );

    final router = GoRouter(
      initialLocation: '/projects/project-1/forms/form-1?tab=overview',
      routes: [
        GoRoute(
          path: '/projects/:projectId/forms/:formId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final formId = state.pathParameters['formId']!;
            return FormDashboardPage(projectId: projectId, formId: formId);
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [formBuilderRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Demo Form'), findsOneWidget);
    expect(find.textContaining('Status: published'), findsOneWidget);
    expect(find.textContaining('Sections: 0'), findsOneWidget);
    expect(find.textContaining('Quick presets: 1'), findsOneWidget);
    expect(find.textContaining('Stub'), findsNothing);
  });

  testWidgets('form dashboard shows a visible error state when loading fails', (
    tester,
  ) async {
    final repo = _FakeFormBuilderRepository(
      BuilderForm(
        id: 'form-1',
        title: 'Demo Form',
        status: 'draft',
      ),
      error: Exception('failed to load form'),
    );

    final router = GoRouter(
      initialLocation: '/projects/project-1/forms/form-1?tab=overview',
      routes: [
        GoRoute(
          path: '/projects/:projectId/forms/:formId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final formId = state.pathParameters['formId']!;
            return FormDashboardPage(projectId: projectId, formId: formId);
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [formBuilderRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Unable to load form details'), findsOneWidget);
    expect(find.textContaining('The dashboard can still open responses'),
        findsOneWidget);
    expect(find.textContaining('Responses'), findsWidgets);
    expect(find.text('Edit form'), findsOneWidget);
  });

  testWidgets('analysis coder shows a visible fallback when init fails', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/projects/project-1/analysis-coder?analysisId=demo',
      routes: [
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
            return const Scaffold(body: Text('Project dashboard'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(_FailingApiClient()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.text('Loading analysis builder...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Analysis builder unavailable'), findsOneWidget);
    expect(find.text('Project dashboard'), findsNothing);
  });

  testWidgets('router keeps form dashboard distinct from project dashboard', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/projects/project-1/forms/form-1?tab=overview',
      routes: [
        GoRoute(
          path: '/projects/:projectId/forms/:formId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final formId = state.pathParameters['formId']!;
            return FormDashboardPage(projectId: projectId, formId: formId);
          },
        ),
        GoRoute(
          path: '/projects/:projectId',
          builder: (context, state) {
            return const Scaffold(body: Text('Project dashboard'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          formBuilderRepositoryProvider.overrideWithValue(
            _FakeFormBuilderRepository(
              BuilderForm(
                id: 'form-1',
                title: 'Demo Form',
                status: 'published',
              ),
            ),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Project dashboard'), findsNothing);
    expect(find.text('Demo Form'), findsOneWidget);
    expect(find.textContaining('Status: published'), findsOneWidget);
    expect(find.text('Project dashboard'), findsNothing);
  });

  testWidgets('analysis boards page navigates to analysis coder via go_router', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/projects/project-1/analysis-boards',
      routes: [
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
            return Scaffold(
              body: Text(
                'analysis coder $projectId ${analysisId ?? "new"}',
              ),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analysisDashboardRepositoryProvider.overrideWithValue(
            _FakeAnalysisDashboardRepository(),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Analysis dashboards'), findsWidgets);

    await tester.tap(find.text('Analysis coder'));
    await tester.pumpAndSettle();

    expect(find.textContaining('analysis coder project-1'), findsWidgets);
  });
}
