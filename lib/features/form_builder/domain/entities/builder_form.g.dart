// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BuilderForm _$BuilderFormFromJson(Map<String, dynamic> json) => _BuilderForm(
  id: json['id'] as String,
  title: json['title'],
  status: json['status'] as String? ?? 'draft',
  isPublished: json['isPublished'] as bool? ?? false,
  version: json['version'] as String? ?? '1.0.0',
  isLatest: json['isLatest'] as bool? ?? true,
  sections: (json['sections'] as List<dynamic>)
      .map((e) => FormSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  layout:
      $enumDecodeNullable(_$FormLayoutTypeEnumMap, json['layout']) ??
      FormLayoutType.singleColumn,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  style: json['style'] == null
      ? const FormStyle()
      : FormStyle.fromJson(json['style'] as Map<String, dynamic>),
  versionHistory:
      (json['versionHistory'] as List<dynamic>?)
          ?.map((e) => FormVersionHistory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  workflows: json['workflows'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$BuilderFormToJson(_BuilderForm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'isPublished': instance.isPublished,
      'version': instance.version,
      'isLatest': instance.isLatest,
      'sections': instance.sections,
      'layout': _$FormLayoutTypeEnumMap[instance.layout]!,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'style': instance.style,
      'versionHistory': instance.versionHistory,
      'workflows': instance.workflows,
    };

const _$FormLayoutTypeEnumMap = {
  FormLayoutType.singleColumn: 'single_column',
  FormLayoutType.twoColumns: 'two_columns',
  FormLayoutType.threeColumns: 'three_columns',
};
