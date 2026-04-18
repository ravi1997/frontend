// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field_template.freezed.dart';
part 'custom_field_template.g.dart';

@freezed
abstract class CustomFieldTemplate with _$CustomFieldTemplate {
  const factory CustomFieldTemplate({
    required String id,
    required String name,
    required String category,

    /// Type of template: 'question', 'section', 'workflow', etc.
    @Default('question') String template_type,

    /// Raw JSON representing the template
    @Default({}) Map<String, dynamic> data,
  }) = _CustomFieldTemplate;

  factory CustomFieldTemplate.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldTemplateFromJson(json);
}
