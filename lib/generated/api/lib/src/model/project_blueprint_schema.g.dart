// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_blueprint_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectBlueprintSchema _$ProjectBlueprintSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ProjectBlueprintSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['name']);
    final val = ProjectBlueprintSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      formBlueprints: $checkedConvert(
        'form_blueprints',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      hierarchyDefinition: $checkedConvert('hierarchy_definition', (v) => v),
      isTemplate: $checkedConvert('is_template', (v) => v as bool? ?? true),
      metaData: $checkedConvert('meta_data', (v) => v),
      name: $checkedConvert('name', (v) => v as String),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'formBlueprints': 'form_blueprints',
    'hierarchyDefinition': 'hierarchy_definition',
    'isTemplate': 'is_template',
    'metaData': 'meta_data',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ProjectBlueprintSchemaToJson(
  ProjectBlueprintSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'description': ?instance.description,
  'form_blueprints': ?instance.formBlueprints,
  'hierarchy_definition': ?instance.hierarchyDefinition,
  'is_template': ?instance.isTemplate,
  'meta_data': ?instance.metaData,
  'name': instance.name,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
};
