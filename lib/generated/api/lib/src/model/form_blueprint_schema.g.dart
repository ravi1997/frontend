// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_blueprint_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormBlueprintSchema _$FormBlueprintSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'FormBlueprintSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['name']);
    final val = FormBlueprintSchema(
      id: $checkedConvert('_id', (v) => v),
      category: $checkedConvert('category', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      estimatedCompletionTime: $checkedConvert(
        'estimated_completion_time',
        (v) => v,
      ),
      icon: $checkedConvert('icon', (v) => v),
      industry: $checkedConvert('industry', (v) => v),
      isOfficial: $checkedConvert('is_official', (v) => v as bool? ?? false),
      metaData: $checkedConvert('meta_data', (v) => v),
      name: $checkedConvert('name', (v) => v as String),
      responseTemplates: $checkedConvert(
        'response_templates',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      sections: $checkedConvert(
        'sections',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      usageCount: $checkedConvert('usage_count', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'estimatedCompletionTime': 'estimated_completion_time',
    'isOfficial': 'is_official',
    'metaData': 'meta_data',
    'responseTemplates': 'response_templates',
    'updatedAt': 'updated_at',
    'usageCount': 'usage_count',
  },
);

Map<String, dynamic> _$FormBlueprintSchemaToJson(
  FormBlueprintSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'category': ?instance.category,
  'created_at': ?instance.createdAt,
  'description': ?instance.description,
  'estimated_completion_time': ?instance.estimatedCompletionTime,
  'icon': ?instance.icon,
  'industry': ?instance.industry,
  'is_official': ?instance.isOfficial,
  'meta_data': ?instance.metaData,
  'name': instance.name,
  'response_templates': ?instance.responseTemplates,
  'sections': ?instance.sections,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
  'usage_count': ?instance.usageCount,
};
