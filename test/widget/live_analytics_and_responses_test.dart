import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/analytics/analytics_distribution.dart';
import 'package:frontend/modules/analytics/analysis_dashboard.dart';
import 'package:frontend/modules/analytics/analysis_dashboard_repository.dart';
import 'package:frontend/modules/analytics/analytics_repository.dart';
import 'package:frontend/modules/analytics/analytics_summary.dart';
import 'package:frontend/modules/analytics/analytics_timeline.dart';
import 'package:frontend/modules/analytics/form_analytics.dart';
import 'package:frontend/modules/analytics/pages/analytics_page.dart';
import 'package:frontend/modules/analytics/pages/analysis_boards_list_page.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';
import 'package:frontend/modules/forms/responses/pages/response_detail_page.dart';
import 'package:frontend/modules/forms/responses/pages/response_list_page.dart';
import 'package:frontend/modules/forms/responses/response_repository.dart';
import 'package:frontend/modules/forms/responses/response_repository_provider.dart';
import 'package:frontend/modules/analytics/analytics_providers.dart';

void main() {
  testWidgets('response list page renders live responses', (tester) async {
    final repo = _FakeResponseRepository(
      responses: [
        _response(id: 'resp-1', submittedBy: 'alice@example.com'),
        _response(id: 'resp-2', submittedBy: 'bob@example.com'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [responseRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: ResponseListPage(projectId: 'project-1', formId: 'form-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('resp-1'), findsOneWidget);
    expect(find.text('resp-2'), findsOneWidget);
    expect(find.text('Responses: 2'), findsOneWidget);
    expect(
      find.textContaining('Submitted by alice@example.com'),
      findsOneWidget,
    );
  });

  testWidgets('response detail page renders answers and history', (
    tester,
  ) async {
    final repo = _FakeResponseRepository(
      detail: _response(
        id: 'resp-9',
        submittedBy: 'casey@example.com',
        answers: {'patient_id': 'P-120', 'notes': 'Follow up required'},
      ),
      history: [
        ResponseHistory(
          id: 'hist-1',
          responseId: 'resp-9',
          action: 'created',
          performedBy: 'casey@example.com',
          performedAt: DateTime.utc(2026, 6, 1, 10, 30),
          changes: {'status': 'submitted'},
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [responseRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: ResponseDetailPage(
            projectId: 'project-1',
            formId: 'form-1',
            responseId: 'resp-9',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('patient_id'), findsOneWidget);
    expect(find.text('P-120'), findsOneWidget);
    expect(find.text('created'), findsOneWidget);
    expect(find.textContaining('casey@example.com'), findsWidgets);
  });

  testWidgets('analytics page renders repository-backed metrics', (
    tester,
  ) async {
    final repo = _FakeAnalyticsRepository(
      summary: const AnalyticsSummary(
        formId: 'form-1',
        totalSubmissions: 12,
        completionRate: 0.75,
        uniqueResponders: 9,
        averageCompletionTime: 4.5,
        statusBreakdown: {'submitted': 10, 'draft': 2},
      ),
      timeline: AnalyticsTimeline(
        formId: 'form-1',
        period: '7d',
        dataPoints: [
          TimelineDataPoint(date: DateTime.utc(2026, 6, 1), count: 2),
          TimelineDataPoint(date: DateTime.utc(2026, 6, 2), count: 3),
        ],
      ),
      distribution: AnalyticsDistribution(
        formId: 'form-1',
        fieldDistributions: [
          FieldDistribution(
            fieldId: 'status',
            fieldLabel: 'Status',
            totalResponses: 12,
            options: [
              const DistributionOption(
                label: 'Open',
                count: 8,
                percentage: 66.7,
              ),
              const DistributionOption(
                label: 'Closed',
                count: 4,
                percentage: 33.3,
              ),
            ],
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [analyticsRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: AnalyticsPage(projectId: 'project-1', formId: 'form-1'),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Analytics dashboard'), findsWidgets);
    expect(find.text('12'), findsWidgets);
    expect(find.text('75%'), findsWidgets);
    expect(find.text('Status'), findsWidgets);
    expect(find.text('Open'), findsWidgets);
  });

  testWidgets('analysis dashboard list renders repository dashboards', (
    tester,
  ) async {
    final repo = _FakeAnalysisDashboardRepository(
      dashboards: [
        AnalysisDashboard(
          id: 'dash-1',
          title: 'Operations',
          slug: 'operations',
          description: 'Operational tracking view',
          layout: 'grid',
          widgets: const [],
          roles: const ['admin'],
          createdAt: DateTime.utc(2026, 6, 1),
          updatedAt: DateTime.utc(2026, 6, 2),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analysisDashboardRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          home: ProjectAnalysisBoardsListPage(projectId: 'project-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Analysis dashboards'), findsWidgets);
    expect(find.text('Operations'), findsOneWidget);
    expect(find.text('Operational tracking view'), findsOneWidget);
    expect(find.text('Widgets: 0'), findsOneWidget);
  });
}

FormResponse _response({
  required String id,
  required String submittedBy,
  Map<String, dynamic> answers = const {},
}) {
  return FormResponse(
    id: id,
    formId: 'form-1',
    organizationId: 'org-1',
    submittedBy: submittedBy,
    submittedAt: DateTime.utc(2026, 6, 1, 10, 30),
    answers: answers,
    status: 'submitted',
  );
}

class _FakeResponseRepository implements ResponseRepository {
  final List<FormResponse> responses;
  final FormResponse? detail;
  final List<ResponseHistory> history;

  _FakeResponseRepository({
    this.responses = const [],
    this.detail,
    this.history = const [],
  });

  @override
  Future<List<FormResponse>> getProjectResponses(
    String projectId,
    String formId,
  ) async => responses;

  @override
  Future<FormResponse> getProjectResponseDetail(
    String projectId,
    String formId,
    String responseId,
  ) async => detail ?? responses.first;

  @override
  Future<List<ResponseHistory>> getProjectResponseHistory(
    String projectId,
    String formId,
    String responseId,
  ) async => history;

  @override
  Future<List<FormResponse>> getResponsesForForm(String formId) async =>
      responses;

  @override
  Future<FormResponse> getResponseDetail(
    String formId,
    String responseId,
  ) async => detail ?? responses.first;

  @override
  Future<void> submitProjectResponse(
    String projectId,
    FormResponse response,
  ) async {}

  @override
  Future<void> submitResponse(FormResponse response) async {}

  @override
  Future<List<FormResponse>> aiSearch(String formId, String query) async =>
      responses;

  @override
  Future<List<Map<String, dynamic>>> lookupSameFormResponses(
    String formId,
    String questionId,
    String value,
  ) async => const [];

  @override
  Future<List<ResponseHistory>> getResponseHistory(
    String formId,
    String responseId,
  ) async => history;

  @override
  Future<List<FormResponse>> getFilteredResponses(
    String projectId,
    String formId,
    List<Map<String, dynamic>> filters,
  ) async => responses;
}

class _FakeAnalyticsRepository implements AnalyticsRepository {
  final AnalyticsSummary summary;
  final AnalyticsTimeline timeline;
  final AnalyticsDistribution distribution;

  _FakeAnalyticsRepository({
    required this.summary,
    required this.timeline,
    required this.distribution,
  });

  @override
  Future<AnalyticsDistribution> getAnalyticsDistribution(String formId) async =>
      distribution;

  @override
  Future<AnalyticsSummary> getAnalyticsSummary(String formId) async => summary;

  @override
  Future<AnalyticsTimeline> getAnalyticsTimeline(
    String formId, {
    int days = 30,
  }) async => timeline;

  @override
  Future<FormAnalytics> getFormAnalytics(String formId) async {
    return FormAnalytics(
      formId: formId,
      totalSubmissions: summary.totalSubmissions,
      completionRate: summary.completionRate,
      trends: timeline.dataPoints
          .map((p) => TimeSeriesData(date: p.date, value: p.count))
          .toList(),
      fieldDistributions: {
        for (final field in distribution.fieldDistributions)
          field.fieldLabel: field.options
              .map(
                (o) => DistributionData(
                  label: o.label,
                  count: o.count,
                  percentage: o.percentage,
                ),
              )
              .toList(),
      },
    );
  }
}

class _FakeAnalysisDashboardRepository implements AnalysisDashboardRepository {
  final List<AnalysisDashboard> dashboards;

  _FakeAnalysisDashboardRepository({this.dashboards = const []});

  @override
  Future<void> createDashboard(AnalysisDashboard dashboard) async {}

  @override
  Future<void> deleteDashboard(String id) async {}

  @override
  Future<AnalysisDashboard> getDashboard(String slug) async => dashboards.first;

  @override
  Future<List<AnalysisDashboard>> listDashboards() async => dashboards;

  @override
  Future<void> updateDashboard(String id, AnalysisDashboard dashboard) async {}
}
