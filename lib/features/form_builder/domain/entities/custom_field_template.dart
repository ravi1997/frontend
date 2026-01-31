import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_question.dart';

part 'custom_field_template.freezed.dart';
part 'custom_field_template.g.dart';

@freezed
abstract class CustomFieldTemplate with _$CustomFieldTemplate {
  const factory CustomFieldTemplate({
    required String id,
    required String name,
    required String category,
    required FormQuestion question,
  }) = _CustomFieldTemplate;

  factory CustomFieldTemplate.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldTemplateFromJson(json);
}
