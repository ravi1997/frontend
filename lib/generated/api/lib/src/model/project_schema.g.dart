// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectSchema _$ProjectSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ProjectSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['organization_id', 'title']);
    final val = ProjectSchema(
      id: $checkedConvert('_id', (v) => v),
      activeVersion: $checkedConvert('active_version', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      forms: $checkedConvert(
        'forms',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      helpText: $checkedConvert('help_text', (v) => v),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      organizationId: $checkedConvert('organization_id', (v) => v as String),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$ProjectSchemaStatusEnumEnumMap, v) ?? 'draft',
      ),
      subProjects: $checkedConvert(
        'sub_projects',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      title: $checkedConvert('title', (v) => v as String),
      triggers: $checkedConvert(
        'triggers',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'activeVersion': 'active_version',
    'createdAt': 'created_at',
    'deletedAt': 'deleted_at',
    'helpText': 'help_text',
    'isDeleted': 'is_deleted',
    'organizationId': 'organization_id',
    'subProjects': 'sub_projects',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ProjectSchemaToJson(ProjectSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'active_version': ?instance.activeVersion,
      'created_at': ?instance.createdAt,
      'deleted_at': ?instance.deletedAt,
      'description': ?instance.description,
      'forms': ?instance.forms,
      'help_text': ?instance.helpText,
      'is_deleted': ?instance.isDeleted,
      'organization_id': instance.organizationId,
      'status': ?_$ProjectSchemaStatusEnumEnumMap[instance.status],
      'sub_projects': ?instance.subProjects,
      'tags': ?instance.tags,
      'title': instance.title,
      'triggers': ?instance.triggers,
      'updated_at': ?instance.updatedAt,
    };

const _$ProjectSchemaStatusEnumEnumMap = {
  ProjectSchemaStatusEnum.draft: 'draft',
  ProjectSchemaStatusEnum.published: 'published',
  ProjectSchemaStatusEnum.archived: 'archived',
};
