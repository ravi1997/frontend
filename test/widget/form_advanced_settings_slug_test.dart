import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/models/custom_field_template.dart';
import 'package:frontend/modules/forms/models/form_version_history.dart';
import 'package:frontend/modules/forms/widgets/form_advanced_settings.dart';
import 'package:frontend/shared/models/form_models.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  final Map<String, bool> slugAvailability;
  String? lastSlugChecked;

  _FakeFormBuilderRepository(this.slugAvailability);

  @override
  Future<bool> isSlugAvailable(
    String slug, {
    String? formId,
    String? projectId,
  }) async {
    lastSlugChecked = slug;
    return slugAvailability[slug] ?? false;
  }

  @override
  Future<BuilderForm> getForm(String projectId, String id) =>
      throw UnimplementedError();

  @override
  Future<List<FormVersionHistory>> getVersionHistory(
    String projectId,
    String formId,
  ) => throw UnimplementedError();

  @override
  Future<BuilderForm> getFormVersion(
    String projectId,
    String formId,
    String version,
  ) => throw UnimplementedError();

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) => throw UnimplementedError();

  @override
  Future<void> updateFormVersion(
    String projectId,
    String formId,
    String version,
    Map<String, dynamic> data,
  ) => throw UnimplementedError();

  @override
  Future<void> createFormVersion(
    String projectId,
    String formId,
    Map<String, dynamic> data, {
    String type = 'patch',
    bool activate = true,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> saveDraft(String projectId, BuilderForm form) =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> getBuilderMetadata() =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> exportSchema(
    String projectId,
    String formId,
  ) => throw UnimplementedError();

  @override
  Future<BuilderForm> restoreFormVersion(
    String projectId,
    String formId,
    String version,
  ) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> publishForm(String projectId, String formId) =>
      throw UnimplementedError();

  @override
  Future<List<FormSection>> generateFieldsWithAI(
    String prompt, {
    BuilderForm? currentForm,
  }) => throw UnimplementedError();

  @override
  Future<List<Map<String, dynamic>>> getAISuggestions(BuilderForm form) =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> validateFormWithAI(BuilderForm form) =>
      throw UnimplementedError();

  @override
  Future<List<CustomFieldTemplate>> getTemplates() => throw UnimplementedError();

  @override
  Future<void> saveTemplate(CustomFieldTemplate template) =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> getTranslations(
    String formId, {
    String? language,
  }) => throw UnimplementedError();

  @override
  Future<void> saveTranslations(
    String formId,
    String language,
    Map<String, dynamic> translations,
  ) => throw UnimplementedError();

  @override
  Future<BuilderForm> cloneForm(
    String projectId,
    String formId, {
    String? title,
    String? slug,
  }) => throw UnimplementedError();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('slug availability updates inline in advanced settings', (
    tester,
  ) async {
    final repo = _FakeFormBuilderRepository({
      'retired-slug': false,
      'fresh-slug': true,
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [formBuilderRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          home: Scaffold(
            body: FormAdvancedSettings(
              form: const {'id': 'form-1', 'advancedSettings': {}},
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key('advanced-form-slug')), 'retired-slug');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(repo.lastSlugChecked, 'retired-slug');
    expect(find.text('Slug is already in use or reserved.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('advanced-form-slug')), 'fresh-slug');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(repo.lastSlugChecked, 'fresh-slug');
    expect(find.text('Slug is available.'), findsOneWidget);
  });
}
