// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_version_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormVersionSchema _$FormVersionSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FormVersionSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['form', 'version']);
        final val = FormVersionSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          form: $checkedConvert('form', (v) => v as String),
          sections: $checkedConvert(
            'sections',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
          status: $checkedConvert(
            'status',
            (v) =>
                $enumDecodeNullable(_$FormVersionSchemaStatusEnumEnumMap, v) ??
                'draft',
          ),
          translations: $checkedConvert('translations', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          version: $checkedConvert('version', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$FormVersionSchemaToJson(FormVersionSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'form': instance.form,
      'sections': ?instance.sections,
      'status': ?_$FormVersionSchemaStatusEnumEnumMap[instance.status],
      'translations': ?instance.translations,
      'updated_at': ?instance.updatedAt,
      'version': instance.version,
    };

const _$FormVersionSchemaStatusEnumEnumMap = {
  FormVersionSchemaStatusEnum.draft: 'draft',
  FormVersionSchemaStatusEnum.published: 'published',
  FormVersionSchemaStatusEnum.archived: 'archived',
};
