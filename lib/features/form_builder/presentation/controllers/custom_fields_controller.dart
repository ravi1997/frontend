import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/custom_field_template.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';

part 'custom_fields_controller.g.dart';

@riverpod
class CustomFields extends _$CustomFields {
  @override
  List<CustomFieldTemplate> build() {
    return _getDefaultTemplates();
  }

  List<CustomFieldTemplate> _getDefaultTemplates() {
    return [
      CustomFieldTemplate(
        id: 'tpl-full-name',
        name: 'Full Name',
        category: 'Personal Info',
        question: const FormQuestion(
          id: 'temp-id-1',
          label: 'Full Name',
          type: QuestionType.shortText,
          placeholder: 'Enter your first and last name',
          isRequired: true,
        ),
      ),
      CustomFieldTemplate(
        id: 'tpl-phone-intl',
        name: 'International Phone',
        category: 'Contact',
        question: const FormQuestion(
          id: 'temp-id-2',
          label: 'Phone Number',
          type: QuestionType.mobile,
          placeholder: '+1 (555) 000-0000',
          inputMask: '+# (###) ###-####',
        ),
      ),
      CustomFieldTemplate(
        id: 'tpl-satisfaction',
        name: 'Satisfaction Scale',
        category: 'Feedback',
        question: const FormQuestion(
          id: 'temp-id-3',
          label: 'How satisfied are you?',
          type: QuestionType.rating,
          metadata: {'maxStars': 10, 'icon': 'heart'},
        ),
      ),
    ];
  }

  void saveAsTemplate(String name, String category, FormQuestion question) {
    final tpl = CustomFieldTemplate(
      id: const Uuid().v4(),
      name: name,
      category: category,
      question: question.copyWith(id: 'TEMPLATE_ID'),
    );
    state = [...state, tpl];
  }

  void removeTemplate(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}
