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
    @JsonKey(
      name: 'layout',
      readValue: _readSectionLayout,
      fromJson: _sectionLayoutTypeFromJson,
    )
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

Object? _readSectionLayout(Map<dynamic, dynamic> json, String key) {
  final layout = json[key];
  if (layout != null) return layout;
  final ui = json['ui'];
  if (ui is Map) {
    return ui['layout_type'] ?? ui['layoutType'];
  }
  return null;
}

SectionLayoutType _sectionLayoutTypeFromJson(Object? value) {
  final raw = value?.toString().trim().toLowerCase();
  switch (raw) {
    case null:
    case '':
    case 'flex':
    case 'standard':
      return SectionLayoutType.standard;
    case 'grid':
    case 'grid-cols-2':
      return SectionLayoutType.grid;
    case 'grid-cols-3':
      return SectionLayoutType.threeColumns;
    case 'full-width':
      return SectionLayoutType.fullWidth;
    case 'list':
      return SectionLayoutType.list;
    case 'sidebar':
      return SectionLayoutType.sidebar;
    case 'accordion':
    case 'split':
      return SectionLayoutType.accordion;
    case 'tabbed':
      return SectionLayoutType.tabbed;
    case 'custom':
      return SectionLayoutType.custom;
    case 'overlay':
      return SectionLayoutType.overlay;
    case 'dashboard':
      return SectionLayoutType.dashboard;
    case 'centered':
      return SectionLayoutType.centered;
    case 'wizard':
    case 'stacked':
      return SectionLayoutType.wizard;
    case 'masonry':
      return SectionLayoutType.masonry;
    case 'fixed':
      return SectionLayoutType.fixed;
    case 'card':
      return SectionLayoutType.card;
    default:
      throw ArgumentError(
        '`layout` is not one of the supported values: $raw',
      );
  }
}
