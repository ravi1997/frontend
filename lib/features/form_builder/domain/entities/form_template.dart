import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../models/form_models.dart';

part 'form_template.freezed.dart';
part 'form_template.g.dart';

/// Represents a pre-built form template that users can use to quickly create forms.
@freezed
abstract class FormTemplate with _$FormTemplate {
  const factory FormTemplate({
    required String id,
    required String name,
    required String description,
    required FormTemplateCategory category,
    required Form form,
    @Default('') String thumbnailUrl,
    @Default([]) List<String> tags,
    @Default(0) int usageCount,
    DateTime? createdAt,
  }) = _FormTemplate;

  factory FormTemplate.fromJson(Map<String, dynamic> json) =>
      _$FormTemplateFromJson(json);
}

/// Represents categories for organizing form templates.
enum FormTemplateCategory {
  contact('Contact Forms'),
  survey('Survey & Feedback'),
  registration('Registration'),
  event('Event Management'),
  assessment('Assessment & Quiz'),
  feedback('Feedback Forms'),
  order('Order Forms'),
  application('Application Forms'),
  other('Other');

  final String displayName;

  const FormTemplateCategory(this.displayName);
}

