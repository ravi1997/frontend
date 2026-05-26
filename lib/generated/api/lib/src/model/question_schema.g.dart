// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionSchema _$QuestionSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'QuestionSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['field_type', 'label']);
        final val = QuestionSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          defaultValue: $checkedConvert('default_value', (v) => v),
          fieldType: $checkedConvert(
            'field_type',
            (v) => $enumDecode(_$QuestionSchemaFieldTypeEnumEnumMap, v),
          ),
          helpText: $checkedConvert('help_text', (v) => v),
          isHidden: $checkedConvert('is_hidden', (v) => v as bool? ?? false),
          isReadOnly: $checkedConvert(
            'is_read_only',
            (v) => v as bool? ?? false,
          ),
          isRepeatable: $checkedConvert(
            'is_repeatable',
            (v) => v as bool? ?? false,
          ),
          keepLastValue: $checkedConvert(
            'keep_last_value',
            (v) => v as bool? ?? false,
          ),
          label: $checkedConvert('label', (v) => v as String),
          logic: $checkedConvert('logic', (v) => v),
          metaData: $checkedConvert('meta_data', (v) => v),
          options: $checkedConvert(
            'options',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
          order: $checkedConvert('order', (v) => (v as num?)?.toInt()),
          repeatMax: $checkedConvert('repeat_max', (v) => v),
          repeatMin: $checkedConvert('repeat_min', (v) => (v as num?)?.toInt()),
          responseTemplates: $checkedConvert(
            'response_templates',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
          tags: $checkedConvert(
            'tags',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          ui: $checkedConvert('ui', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          validation: $checkedConvert('validation', (v) => v),
          variableName: $checkedConvert('variable_name', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'defaultValue': 'default_value',
        'fieldType': 'field_type',
        'helpText': 'help_text',
        'isHidden': 'is_hidden',
        'isReadOnly': 'is_read_only',
        'isRepeatable': 'is_repeatable',
        'keepLastValue': 'keep_last_value',
        'metaData': 'meta_data',
        'repeatMax': 'repeat_max',
        'repeatMin': 'repeat_min',
        'responseTemplates': 'response_templates',
        'updatedAt': 'updated_at',
        'variableName': 'variable_name',
      },
    );

Map<String, dynamic> _$QuestionSchemaToJson(QuestionSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'default_value': ?instance.defaultValue,
      'field_type': _$QuestionSchemaFieldTypeEnumEnumMap[instance.fieldType]!,
      'help_text': ?instance.helpText,
      'is_hidden': ?instance.isHidden,
      'is_read_only': ?instance.isReadOnly,
      'is_repeatable': ?instance.isRepeatable,
      'keep_last_value': ?instance.keepLastValue,
      'label': instance.label,
      'logic': ?instance.logic,
      'meta_data': ?instance.metaData,
      'options': ?instance.options,
      'order': ?instance.order,
      'repeat_max': ?instance.repeatMax,
      'repeat_min': ?instance.repeatMin,
      'response_templates': ?instance.responseTemplates,
      'tags': ?instance.tags,
      'ui': ?instance.ui,
      'updated_at': ?instance.updatedAt,
      'validation': ?instance.validation,
      'variable_name': ?instance.variableName,
    };

const _$QuestionSchemaFieldTypeEnumEnumMap = {
  QuestionSchemaFieldTypeEnum.input: 'input',
  QuestionSchemaFieldTypeEnum.textarea: 'textarea',
  QuestionSchemaFieldTypeEnum.number: 'number',
  QuestionSchemaFieldTypeEnum.email: 'email',
  QuestionSchemaFieldTypeEnum.mobile: 'mobile',
  QuestionSchemaFieldTypeEnum.url: 'url',
  QuestionSchemaFieldTypeEnum.password: 'password',
};
