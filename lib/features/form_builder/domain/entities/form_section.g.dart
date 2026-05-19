// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormSection _$FormSectionFromJson(Map<String, dynamic> json) => _FormSection(
  id: IdReader.readIdCallback(json, 'id') as String,
  title: json['title'],
  description: json['description'],
  helpText: json['help_text'],
  order: (json['order'] as num?)?.toInt() ?? 0,
  questions: (json['questions'] as List<dynamic>)
      .map((e) => FormQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  layout: json['layout'] == null
      ? SectionLayoutType.standard
      : _sectionLayoutTypeFromJson(json['layout']),
  gridColumns: (json['grid_columns'] as num?)?.toInt() ?? 2,
  isHidden: json['is_hidden'] as bool? ?? false,
  isRepeatable: json['is_repeatable'] as bool? ?? false,
  repeatMin: (json['repeat_min'] as num?)?.toInt(),
  repeatMax: (json['repeat_max'] as num?)?.toInt(),
  conditionalLogic: json['conditional_logic'] as Map<String, dynamic>?,
  logic: json['logic'] as Map<String, dynamic>?,
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map((e) => FormSection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FormSection>[],
  responseTemplates:
      (json['response_templates'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const <Map<String, dynamic>>[],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  style: json['style'] == null
      ? const SectionStyle()
      : SectionStyle.fromJson(json['style'] as Map<String, dynamic>),
  metaData: json['meta_data'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$FormSectionToJson(_FormSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'help_text': instance.helpText,
      'order': instance.order,
      'questions': instance.questions,
      'layout': _$SectionLayoutTypeEnumMap[instance.layout]!,
      'grid_columns': instance.gridColumns,
      'is_hidden': instance.isHidden,
      'is_repeatable': instance.isRepeatable,
      'repeat_min': instance.repeatMin,
      'repeat_max': instance.repeatMax,
      'conditional_logic': instance.conditionalLogic,
      'logic': instance.logic,
      'sections': instance.sections,
      'response_templates': instance.responseTemplates,
      'tags': instance.tags,
      'style': instance.style,
      'meta_data': instance.metaData,
    };

const _$SectionLayoutTypeEnumMap = {
  SectionLayoutType.standard: 'flex',
  SectionLayoutType.grid: 'grid-cols-2',
  SectionLayoutType.threeColumns: 'grid-cols-3',
  SectionLayoutType.fullWidth: 'full-width',
  SectionLayoutType.list: 'list',
  SectionLayoutType.sidebar: 'sidebar',
  SectionLayoutType.accordion: 'split',
  SectionLayoutType.tabbed: 'tabbed',
  SectionLayoutType.custom: 'custom',
  SectionLayoutType.overlay: 'overlay',
  SectionLayoutType.dashboard: 'dashboard',
  SectionLayoutType.centered: 'centered',
  SectionLayoutType.wizard: 'stacked',
  SectionLayoutType.masonry: 'masonry',
  SectionLayoutType.fixed: 'fixed',
  SectionLayoutType.card: 'card',
};
