// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'form_question.dart';
import 'section_layout_type.dart';
import 'form_style.dart';
import '../../../../core/utils/id_reader.dart';

part 'form_section.freezed.dart';
part 'form_section.g.dart';

@freezed
abstract class FormSection with _$FormSection {
  const FormSection._();
  const factory FormSection({
    @JsonKey(readValue: IdReader.readIdCallback) required String id,
    required Object? title,
    Object? description,
    @JsonKey(name: 'help_text') Object? helpText,
    @Default(0) int order,
    required List<FormQuestion> questions,
    @Default(SectionLayoutType.standard) SectionLayoutType layout,
    @JsonKey(name: 'grid_columns') @Default(2) int gridColumns,
    @JsonKey(name: 'is_hidden') @Default(false) bool isHidden,
    @JsonKey(name: 'is_repeatable') @Default(false) bool isRepeatable,
    @JsonKey(name: 'repeat_min') int? repeatMin,
    @JsonKey(name: 'repeat_max') int? repeatMax,
    @JsonKey(name: 'conditional_logic') Map<String, dynamic>? conditionalLogic,
    Map<String, dynamic>? logic,
    @JsonKey(name: 'sections') @Default(<FormSection>[]) List<FormSection> sections,
    @JsonKey(name: 'response_templates')
    @Default(<Map<String, dynamic>>[])
    List<Map<String, dynamic>> responseTemplates,
    @Default(<String>[]) List<String> tags,
    @Default(SectionStyle()) SectionStyle style,
    @JsonKey(name: 'meta_data') @Default({}) Map<String, dynamic> metaData,
  }) = _FormSection;

  factory FormSection.fromJson(Map<String, dynamic> json) =>
      _$FormSectionFromJson(json);
}
