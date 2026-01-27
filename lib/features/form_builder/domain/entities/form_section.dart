import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_question.dart';

part 'form_section.freezed.dart';
part 'form_section.g.dart';

@freezed
abstract class FormSection with _$FormSection {
  const FormSection._();
  const factory FormSection({
    required String id,
    required String title,
    String? description,
    required List<FormQuestion> questions,
  }) = _FormSection;

  factory FormSection.fromJson(Map<String, dynamic> json) =>
      _$FormSectionFromJson(json);
}
