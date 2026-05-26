// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_version_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectVersionSchema _$ProjectVersionSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ProjectVersionSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['project', 'version']);
    final val = ProjectVersionSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      forms: $checkedConvert(
        'forms',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      project: $checkedConvert('project', (v) => v as String),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$ProjectVersionSchemaStatusEnumEnumMap, v) ??
            'draft',
      ),
      subProjects: $checkedConvert(
        'sub_projects',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      version: $checkedConvert('version', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'subProjects': 'sub_projects',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ProjectVersionSchemaToJson(
  ProjectVersionSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'forms': ?instance.forms,
  'project': instance.project,
  'status': ?_$ProjectVersionSchemaStatusEnumEnumMap[instance.status],
  'sub_projects': ?instance.subProjects,
  'updated_at': ?instance.updatedAt,
  'version': instance.version,
};

const _$ProjectVersionSchemaStatusEnumEnumMap = {
  ProjectVersionSchemaStatusEnum.draft: 'draft',
  ProjectVersionSchemaStatusEnum.published: 'published',
  ProjectVersionSchemaStatusEnum.archived: 'archived',
};
