// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormDto _$FormDtoFromJson(Map<String, dynamic> json) => _FormDto(
  id: IdReader.readIdWithSlugCallback(json, 'id') as String,
  title: json['title'] as String? ?? 'Untitled Form',
  status: json['status'] as String? ?? 'draft',
  uiType: json['ui_type'] as String?,
  activeVersion: json['active_version'] as String?,
  versions:
      (json['versions'] as List<dynamic>?)
          ?.map((e) => FormVersionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FormVersionDto>[],
  createdAt: AppDateUtils.parse(json['created_at']),
  updatedAt: AppDateUtils.parse(json['updated_at']),
  workflows:
      json['workflows'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  accessPolicy: json['accessPolicy'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$FormDtoToJson(_FormDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': instance.status,
  'ui_type': instance.uiType,
  'active_version': instance.activeVersion,
  'versions': instance.versions,
  'created_at': AppDateUtils.toIso8601(instance.createdAt),
  'updated_at': AppDateUtils.toIso8601(instance.updatedAt),
  'workflows': instance.workflows,
  'accessPolicy': instance.accessPolicy,
};

_FormVersionDto _$FormVersionDtoFromJson(Map<String, dynamic> json) =>
    _FormVersionDto(
      version: json['version'] as String? ?? '1.0',
      sections: json['sections'] == null
          ? const <Map<String, dynamic>>[]
          : _sectionsFromJson(json['sections']),
      createdAt: AppDateUtils.parse(json['created_at']),
    );

Map<String, dynamic> _$FormVersionDtoToJson(_FormVersionDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'sections': instance.sections,
      'created_at': AppDateUtils.toIso8601(instance.createdAt),
    };
