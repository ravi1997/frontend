import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/form_version_history.dart';
import 'package:frontend/features/form_builder/domain/entities/form_section.dart';
import 'package:frontend/features/form_builder/domain/entities/form_question.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';

class MockFormBuilderRepository implements FormBuilderRepository {
  @override
  Future<BuilderForm> getForm(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return BuilderForm(
      id: id,
      title: 'Mock Form',
      version: '1.0.0',
      isLatest: true,
      sections: [
        FormSection(
          id: 's1',
          title: 'Section 1',
          questions: [
            const FormQuestion(
              id: 'q1',
              label: 'Full Name',
              type: QuestionType.shortText,
            ),
            const FormQuestion(
              id: 'q2',
              label: 'Email Address',
              type: QuestionType.email,
            ),
            const FormQuestion(
              id: 'q3',
              label: 'Gender',
              type: QuestionType.dropdown,
              options: ['Male', 'Female', 'Other'],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<List<FormVersionHistory>> getVersionHistory(String formId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      FormVersionHistory(
        version: '1.0.0',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        changeLog: 'Initial version',
      ),
    ];
  }

  @override
  Future<BuilderForm> getFormVersion(String formId, String version) async {
    return getForm(formId); // For now, just return the mock form
  }

  @override
  Future<void> saveForm(BuilderForm form) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<Map<String, dynamic>> publishForm(String formId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'published_version': '1.0.0', 'next_draft_version': '1.0.1'};
  }

  @override
  Future<List<FormSection>> generateFieldsWithAI(
    String prompt, {
    BuilderForm? currentForm,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      FormSection(
        id: 'ai-section',
        title: 'Generated Content',
        questions: [
          const FormQuestion(
            id: 'ai-q1',
            label: 'Generated Field 1',
            type: QuestionType.shortText,
          ),
          const FormQuestion(
            id: 'ai-q2',
            label: 'Generated Field 2',
            type: QuestionType.paragraph,
          ),
        ],
      ),
    ];
  }
}
