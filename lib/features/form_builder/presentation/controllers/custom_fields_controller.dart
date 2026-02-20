import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/repositories/form_builder_repository.dart';

part 'custom_fields_controller.g.dart';

@riverpod
class CustomFields extends _$CustomFields {
  @override
  List<CustomFieldTemplate> build() {
    _fetchTemplates();
    return _getDefaultTemplates();
  }

  Future<void> _fetchTemplates() async {
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final templates = await repository.getTemplates();
      state = [..._getDefaultTemplates(), ...templates];
    } catch (e) {
      // Ignore
    }
  }

  List<CustomFieldTemplate> _getDefaultTemplates() {
    return [
      CustomFieldTemplate(
        id: 'tpl-full-name',
        name: 'Full Name',
        category: 'Personal Info',
        template_type: 'question',
        data: const FormQuestion(
          id: 'temp-id-1',
          label: 'Full Name',
          type: QuestionType.shortText,
          placeholder: 'Enter your first and last name',
          isRequired: true,
        ).toJson(),
      ),
      CustomFieldTemplate(
        id: 'tpl-phone-intl',
        name: 'International Phone',
        category: 'Contact',
        template_type: 'question',
        data: const FormQuestion(
          id: 'temp-id-2',
          label: 'Phone Number',
          type: QuestionType.mobile,
          placeholder: '+1 (555) 000-0000',
          inputMask: '+# (###) ###-####',
        ).toJson(),
      ),
      CustomFieldTemplate(
        id: 'tpl-satisfaction',
        name: 'Satisfaction Scale',
        category: 'Feedback',
        template_type: 'question',
        data: const FormQuestion(
          id: 'temp-id-3',
          label: 'How satisfied are you?',
          type: QuestionType.rating,
          metadata: {'maxStars': 10, 'icon': 'heart'},
        ).toJson(),
      ),
    ];
  }

  Future<void> saveAsTemplate(
    String name,
    String category,
    FormQuestion question,
  ) async {
    final tpl = CustomFieldTemplate(
      id: const Uuid().v4(),
      name: name,
      category: category,
      template_type: 'question',
      data: question.copyWith(id: 'TEMPLATE_ID').toJson(),
    );
    state = [...state, tpl];

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      await repository.saveTemplate(tpl);
      _fetchTemplates();
    } catch (_) {}
  }

  Future<void> removeTemplate(String id) async {
    state = state.where((t) => t.id != id).toList();
    // Assuming you have an API to remove, but we'll leave it as local state for now if not.
  }
}
