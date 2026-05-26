// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditional_validation_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConditionalValidationSchema _$ConditionalValidationSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ConditionalValidationSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['error_message']);
    final val = ConditionalValidationSchema(
      id: $checkedConvert('_id', (v) => v),
      conditions: $checkedConvert(
        'conditions',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      createdAt: $checkedConvert('created_at', (v) => v),
      errorMessage: $checkedConvert('error_message', (v) => v as String),
      logicalOperator: $checkedConvert(
        'logical_operator',
        (v) => v as String? ?? 'AND',
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'errorMessage': 'error_message',
    'logicalOperator': 'logical_operator',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ConditionalValidationSchemaToJson(
  ConditionalValidationSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'conditions': ?instance.conditions,
  'created_at': ?instance.createdAt,
  'error_message': instance.errorMessage,
  'logical_operator': ?instance.logicalOperator,
  'updated_at': ?instance.updatedAt,
};
