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
    required List<FormQuestion> questions,
    @Default(SectionLayoutType.standard) SectionLayoutType layout,
    @Default(2) int gridColumns,
    @Default(false) bool isHidden,
    @Default(false) bool isRepeatable,
    int? repeatMin,
    int? repeatMax,
    Map<String, dynamic>? conditionalLogic,
    @Default(SectionStyle()) SectionStyle style,
    @Default({}) Map<String, dynamic> metadata,
  }) = _FormSection;

  factory FormSection.fromJson(Map<String, dynamic> json) =>
      _$FormSectionFromJson(json);
}
