// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_view_definition_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicViewDefinitionSchema _$DynamicViewDefinitionSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'DynamicViewDefinitionSchema',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['organization_id', 'pipeline', 'view_name'],
    );
    final val = DynamicViewDefinitionSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      form: $checkedConvert('form', (v) => v),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      organizationId: $checkedConvert('organization_id', (v) => v as String),
      pipeline: $checkedConvert(
        'pipeline',
        (v) => (v as List<dynamic>).map((e) => e as Object).toList(),
      ),
      project: $checkedConvert('project', (v) => v),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      viewName: $checkedConvert('view_name', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'deletedAt': 'deleted_at',
    'isDeleted': 'is_deleted',
    'organizationId': 'organization_id',
    'updatedAt': 'updated_at',
    'viewName': 'view_name',
  },
);

Map<String, dynamic> _$DynamicViewDefinitionSchemaToJson(
  DynamicViewDefinitionSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'deleted_at': ?instance.deletedAt,
  'description': ?instance.description,
  'form': ?instance.form,
  'is_deleted': ?instance.isDeleted,
  'organization_id': instance.organizationId,
  'pipeline': instance.pipeline,
  'project': ?instance.project,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
  'view_name': instance.viewName,
};
