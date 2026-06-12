import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/dashboard/form_dashboard_page.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:go_router/go_router.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  final BuilderForm form;

  _FakeFormBuilderRepository(this.form);

  @override
  Future<BuilderForm> getForm(String projectId, String id) async => form;

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) async => form;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
}
