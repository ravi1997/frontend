// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_template_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseTemplateSchema _$ResponseTemplateSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ResponseTemplateSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['name']);
    final val = ResponseTemplateSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      metaData: $checkedConvert('meta_data', (v) => v),
      name: $checkedConvert('name', (v) => v as String),
      structure: $checkedConvert('structure', (v) => v),
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
    'metaData': 'meta_data',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ResponseTemplateSchemaToJson(
  ResponseTemplateSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'description': ?instance.description,
  'meta_data': ?instance.metaData,
  'name': instance.name,
  'structure': ?instance.structure,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
};
