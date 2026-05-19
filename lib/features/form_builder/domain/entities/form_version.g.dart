// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormVersion _$FormVersionFromJson(Map<String, dynamic> json) => _FormVersion(
  id: json['id'] as String,
  versionNumber: json['versionNumber'] as String,
  sections: (json['sections'] as List<dynamic>)
      .map((e) => FormSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  style: json['style'] == null
      ? const FormStyle()
      : FormStyle.fromJson(json['style'] as Map<String, dynamic>),
  layout:
      $enumDecodeNullable(_$FormLayoutTypeEnumMap, json['layout']) ??
      FormLayoutType.singleColumn,
  createdAt: DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
);

Map<String, dynamic> _$FormVersionToJson(_FormVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionNumber': instance.versionNumber,
      'sections': instance.sections,
      'style': instance.style,
      'layout': _$FormLayoutTypeEnumMap[instance.layout]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };

const _$FormLayoutTypeEnumMap = {
  FormLayoutType.singleColumn: 'flex',
  FormLayoutType.twoColumns: 'grid-cols-2',
  FormLayoutType.threeColumns: 'grid-cols-3',
};
