// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_logic_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionLogicSchema _$QuestionLogicSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'QuestionLogicSchema',
  json,
  ($checkedConvert) {
    final val = QuestionLogicSchema(
      id: $checkedConvert('_id', (v) => v),
      actionConfig: $checkedConvert('action_config', (v) => v),
      calculatedValue: $checkedConvert('calculated_value', (v) => v),
      conditionalLogic: $checkedConvert('conditional_logic', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      customScript: $checkedConvert('custom_script', (v) => v),
      fieldApiCall: $checkedConvert('field_api_call', (v) => v),
      isDisabled: $checkedConvert('is_disabled', (v) => v as bool? ?? false),
      onChange: $checkedConvert('on_change', (v) => v),
      triggers: $checkedConvert(
        'triggers',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      visibilityCondition: $checkedConvert('visibility_condition', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'actionConfig': 'action_config',
    'calculatedValue': 'calculated_value',
    'conditionalLogic': 'conditional_logic',
    'createdAt': 'created_at',
    'customScript': 'custom_script',
    'fieldApiCall': 'field_api_call',
    'isDisabled': 'is_disabled',
    'onChange': 'on_change',
    'updatedAt': 'updated_at',
    'visibilityCondition': 'visibility_condition',
  },
);

Map<String, dynamic> _$QuestionLogicSchemaToJson(
  QuestionLogicSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'action_config': ?instance.actionConfig,
  'calculated_value': ?instance.calculatedValue,
  'conditional_logic': ?instance.conditionalLogic,
  'created_at': ?instance.createdAt,
  'custom_script': ?instance.customScript,
  'field_api_call': ?instance.fieldApiCall,
  'is_disabled': ?instance.isDisabled,
  'on_change': ?instance.onChange,
  'triggers': ?instance.triggers,
  'updated_at': ?instance.updatedAt,
  'visibility_condition': ?instance.visibilityCondition,
};
