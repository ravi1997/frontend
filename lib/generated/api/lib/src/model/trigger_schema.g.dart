// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TriggerSchema _$TriggerSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TriggerSchema',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['action_type', 'event_type', 'name'],
        );
        final val = TriggerSchema(
          id: $checkedConvert('_id', (v) => v),
          actionConfig: $checkedConvert('action_config', (v) => v),
          actionType: $checkedConvert(
            'action_type',
            (v) => $enumDecode(_$TriggerSchemaActionTypeEnumEnumMap, v),
          ),
          condition: $checkedConvert('condition', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          customScript: $checkedConvert('custom_script', (v) => v),
          eventType: $checkedConvert(
            'event_type',
            (v) => $enumDecode(_$TriggerSchemaEventTypeEnumEnumMap, v),
          ),
          isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
          metaData: $checkedConvert('meta_data', (v) => v),
          name: $checkedConvert('name', (v) => v as String),
          order: $checkedConvert('order', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'actionConfig': 'action_config',
        'actionType': 'action_type',
        'createdAt': 'created_at',
        'customScript': 'custom_script',
        'eventType': 'event_type',
        'isActive': 'is_active',
        'metaData': 'meta_data',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$TriggerSchemaToJson(TriggerSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'action_config': ?instance.actionConfig,
      'action_type': _$TriggerSchemaActionTypeEnumEnumMap[instance.actionType]!,
      'condition': ?instance.condition,
      'created_at': ?instance.createdAt,
      'custom_script': ?instance.customScript,
      'event_type': _$TriggerSchemaEventTypeEnumEnumMap[instance.eventType]!,
      'is_active': ?instance.isActive,
      'meta_data': ?instance.metaData,
      'name': instance.name,
      'order': ?instance.order,
      'updated_at': ?instance.updatedAt,
    };

const _$TriggerSchemaActionTypeEnumEnumMap = {
  TriggerSchemaActionTypeEnum.webhook: 'webhook',
  TriggerSchemaActionTypeEnum.email: 'email',
  TriggerSchemaActionTypeEnum.sms: 'sms',
  TriggerSchemaActionTypeEnum.notification: 'notification',
  TriggerSchemaActionTypeEnum.updateField: 'update_field',
  TriggerSchemaActionTypeEnum.executeScript: 'execute_script',
  TriggerSchemaActionTypeEnum.hideShow: 'hide_show',
  TriggerSchemaActionTypeEnum.enableDisable: 'enable_disable',
  TriggerSchemaActionTypeEnum.validationError: 'validation_error',
  TriggerSchemaActionTypeEnum.calculation: 'calculation',
  TriggerSchemaActionTypeEnum.apiCall: 'api_call',
};

const _$TriggerSchemaEventTypeEnumEnumMap = {
  TriggerSchemaEventTypeEnum.load: 'on_load',
  TriggerSchemaEventTypeEnum.submit: 'on_submit',
  TriggerSchemaEventTypeEnum.change: 'on_change',
  TriggerSchemaEventTypeEnum.statusChange: 'on_status_change',
  TriggerSchemaEventTypeEnum.validate: 'on_validate',
  TriggerSchemaEventTypeEnum.approvalStep: 'on_approval_step',
  TriggerSchemaEventTypeEnum.creation: 'on_creation',
};
