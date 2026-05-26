// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionSchema _$OptionSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'OptionSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['option_label', 'option_value']);
    final val = OptionSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      isDefault: $checkedConvert('is_default', (v) => v as bool? ?? false),
      isDisabled: $checkedConvert('is_disabled', (v) => v as bool? ?? false),
      optionCode: $checkedConvert('option_code', (v) => v),
      optionLabel: $checkedConvert('option_label', (v) => v as String),
      optionValue: $checkedConvert('option_value', (v) => v as String),
      order: $checkedConvert('order', (v) => (v as num?)?.toInt()),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      visibilityCondition: $checkedConvert('visibility_condition', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'isDefault': 'is_default',
    'isDisabled': 'is_disabled',
    'optionCode': 'option_code',
    'optionLabel': 'option_label',
    'optionValue': 'option_value',
    'updatedAt': 'updated_at',
    'visibilityCondition': 'visibility_condition',
  },
);

Map<String, dynamic> _$OptionSchemaToJson(OptionSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'description': ?instance.description,
      'is_default': ?instance.isDefault,
      'is_disabled': ?instance.isDisabled,
      'option_code': ?instance.optionCode,
      'option_label': instance.optionLabel,
      'option_value': instance.optionValue,
      'order': ?instance.order,
      'updated_at': ?instance.updatedAt,
      'visibility_condition': ?instance.visibilityCondition,
    };
