// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_state_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsStateSchema _$AnalyticsStateSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'AnalyticsStateSchema',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'action_type',
        'event_timestamp',
        'flattened_fields',
        'form_id',
        'response_id',
        'tenant_id',
      ],
    );
    final val = AnalyticsStateSchema(
      actionType: $checkedConvert('action_type', (v) => v as String),
      eventTimestamp: $checkedConvert('event_timestamp', (v) => v as num),
      flattenedFields: $checkedConvert('flattened_fields', (v) => v as Object),
      formId: $checkedConvert('form_id', (v) => v as String),
      responseId: $checkedConvert('response_id', (v) => v as String),
      tenantId: $checkedConvert('tenant_id', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'actionType': 'action_type',
    'eventTimestamp': 'event_timestamp',
    'flattenedFields': 'flattened_fields',
    'formId': 'form_id',
    'responseId': 'response_id',
    'tenantId': 'tenant_id',
  },
);

Map<String, dynamic> _$AnalyticsStateSchemaToJson(
  AnalyticsStateSchema instance,
) => <String, dynamic>{
  'action_type': instance.actionType,
  'event_timestamp': instance.eventTimestamp,
  'flattened_fields': instance.flattenedFields,
  'form_id': instance.formId,
  'response_id': instance.responseId,
  'tenant_id': instance.tenantId,
};
