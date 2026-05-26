// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_schema_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionSchemaStruct _$SectionSchemaStructFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SectionSchemaStruct',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['title']);
        final val = SectionSchemaStruct(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          description: $checkedConvert('description', (v) => v),
          helpText: $checkedConvert('help_text', (v) => v),
          logic: $checkedConvert('logic', (v) => v),
          metaData: $checkedConvert('meta_data', (v) => v),
          order: $checkedConvert('order', (v) => v),
          questions: $checkedConvert(
            'questions',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
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
          title: $checkedConvert('title', (v) => v as String),
          ui: $checkedConvert('ui', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'helpText': 'help_text',
        'metaData': 'meta_data',
        'responseTemplates': 'response_templates',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$SectionSchemaStructToJson(
  SectionSchemaStruct instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'description': ?instance.description,
  'help_text': ?instance.helpText,
  'logic': ?instance.logic,
  'meta_data': ?instance.metaData,
  'order': ?instance.order,
  'questions': ?instance.questions,
  'response_templates': ?instance.responseTemplates,
  'sections': ?instance.sections,
  'tags': ?instance.tags,
  'title': instance.title,
  'ui': ?instance.ui,
  'updated_at': ?instance.updatedAt,
};
