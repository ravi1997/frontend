// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormDto _$FormDtoFromJson(Map<String, dynamic> json) => _FormDto(
  id: _readId(json, 'id') as String,
  title: json['title'] as String? ?? 'Untitled Form',
  status: json['status'] as String? ?? 'draft',
  activeVersion: json['active_version'] as String?,
  versions:
      (json['versions'] as List<dynamic>?)
          ?.map((e) => FormVersionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: _dateTimeFromJson(json['created_at'] as String?),
  updatedAt: _dateTimeFromJson(json['updated_at'] as String?),
  workflows: json['workflows'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$FormDtoToJson(_FormDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': instance.status,
  'active_version': instance.activeVersion,
  'versions': instance.versions,
  'created_at': _dateTimeToJson(instance.createdAt),
  'updated_at': _dateTimeToJson(instance.updatedAt),
  'workflows': instance.workflows,
};

_FormVersionDto _$FormVersionDtoFromJson(Map<String, dynamic> json) =>
    _FormVersionDto(
      version: json['version'] as String? ?? '1.0',
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      createdAt: _dateTimeFromJson(json['created_at'] as String?),
    );

Map<String, dynamic> _$FormVersionDtoToJson(_FormVersionDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'sections': instance.sections,
      'created_at': _dateTimeToJson(instance.createdAt),
    };
