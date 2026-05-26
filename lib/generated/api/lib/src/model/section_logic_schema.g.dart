// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_logic_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionLogicSchema _$SectionLogicSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'SectionLogicSchema',
  json,
  ($checkedConvert) {
    final val = SectionLogicSchema(
      id: $checkedConvert('_id', (v) => v),
      actionConfig: $checkedConvert('action_config', (v) => v),
      conditionalLogic: $checkedConvert('conditional_logic', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      customScript: $checkedConvert('custom_script', (v) => v),
      fieldApiCall: $checkedConvert('field_api_call', (v) => v),
      isDisabled: $checkedConvert('is_disabled', (v) => v as bool? ?? false),
      isRepeatable: $checkedConvert(
        'is_repeatable',
        (v) => v as bool? ?? false,
      ),
      onChange: $checkedConvert('on_change', (v) => v),
      repeatMax: $checkedConvert('repeat_max', (v) => v),
      repeatMin: $checkedConvert('repeat_min', (v) => (v as num?)?.toInt()),
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
    'conditionalLogic': 'conditional_logic',
    'createdAt': 'created_at',
    'customScript': 'custom_script',
    'fieldApiCall': 'field_api_call',
    'isDisabled': 'is_disabled',
    'isRepeatable': 'is_repeatable',
    'onChange': 'on_change',
    'repeatMax': 'repeat_max',
    'repeatMin': 'repeat_min',
    'updatedAt': 'updated_at',
    'visibilityCondition': 'visibility_condition',
  },
);

Map<String, dynamic> _$SectionLogicSchemaToJson(SectionLogicSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'action_config': ?instance.actionConfig,
      'conditional_logic': ?instance.conditionalLogic,
      'created_at': ?instance.createdAt,
      'custom_script': ?instance.customScript,
      'field_api_call': ?instance.fieldApiCall,
      'is_disabled': ?instance.isDisabled,
      'is_repeatable': ?instance.isRepeatable,
      'on_change': ?instance.onChange,
      'repeat_max': ?instance.repeatMax,
      'repeat_min': ?instance.repeatMin,
      'triggers': ?instance.triggers,
      'updated_at': ?instance.updatedAt,
      'visibility_condition': ?instance.visibilityCondition,
    };
