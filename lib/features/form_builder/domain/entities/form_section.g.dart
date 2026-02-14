// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormSection _$FormSectionFromJson(Map<String, dynamic> json) => _FormSection(
  id: _readId(json, 'id') as String,
  title: json['title'],
  description: json['description'],
  questions: (json['questions'] as List<dynamic>)
      .map((e) => FormQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  layout:
      $enumDecodeNullable(_$SectionLayoutTypeEnumMap, json['layout']) ??
      SectionLayoutType.standard,
  gridColumns: (json['gridColumns'] as num?)?.toInt() ?? 2,
  isHidden: json['isHidden'] as bool? ?? false,
  conditionalLogic: json['conditionalLogic'] as Map<String, dynamic>?,
  style: json['style'] == null
      ? const SectionStyle()
      : SectionStyle.fromJson(json['style'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FormSectionToJson(_FormSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'questions': instance.questions,
      'layout': _$SectionLayoutTypeEnumMap[instance.layout]!,
      'gridColumns': instance.gridColumns,
      'isHidden': instance.isHidden,
      'conditionalLogic': instance.conditionalLogic,
      'style': instance.style,
    };

const _$SectionLayoutTypeEnumMap = {
  SectionLayoutType.standard: 'standard',
  SectionLayoutType.grid: 'grid',
  SectionLayoutType.accordion: 'accordion',
  SectionLayoutType.tabbed: 'tabbed',
  SectionLayoutType.wizard: 'wizard',
  SectionLayoutType.card: 'card',
};
