// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow_instance_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkflowInstanceSchema _$WorkflowInstanceSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'WorkflowInstanceSchema',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'organization_id',
        'resource_id',
        'workflow_definition',
      ],
    );
    final val = WorkflowInstanceSchema(
      id: $checkedConvert('_id', (v) => v),
      completedAt: $checkedConvert('completed_at', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      currentStepOrder: $checkedConvert(
        'current_step_order',
        (v) => (v as num?)?.toInt(),
      ),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      history: $checkedConvert(
        'history',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      metaData: $checkedConvert('meta_data', (v) => v),
      organizationId: $checkedConvert('organization_id', (v) => v as String),
      resourceId: $checkedConvert('resource_id', (v) => v as String),
      resourceType: $checkedConvert(
        'resource_type',
        (v) => v as String? ?? 'form_response',
      ),
      startedAt: $checkedConvert('started_at', (v) => v),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$WorkflowInstanceSchemaStatusEnumEnumMap, v) ??
            'pending',
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      workflowDefinition: $checkedConvert(
        'workflow_definition',
        (v) => v as String,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'completedAt': 'completed_at',
    'createdAt': 'created_at',
    'currentStepOrder': 'current_step_order',
    'deletedAt': 'deleted_at',
    'isDeleted': 'is_deleted',
    'metaData': 'meta_data',
    'organizationId': 'organization_id',
    'resourceId': 'resource_id',
    'resourceType': 'resource_type',
    'startedAt': 'started_at',
    'updatedAt': 'updated_at',
    'workflowDefinition': 'workflow_definition',
  },
);

Map<String, dynamic> _$WorkflowInstanceSchemaToJson(
  WorkflowInstanceSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'completed_at': ?instance.completedAt,
  'created_at': ?instance.createdAt,
  'current_step_order': ?instance.currentStepOrder,
  'deleted_at': ?instance.deletedAt,
  'history': ?instance.history,
  'is_deleted': ?instance.isDeleted,
  'meta_data': ?instance.metaData,
  'organization_id': instance.organizationId,
  'resource_id': instance.resourceId,
  'resource_type': ?instance.resourceType,
  'started_at': ?instance.startedAt,
  'status': ?_$WorkflowInstanceSchemaStatusEnumEnumMap[instance.status],
  'updated_at': ?instance.updatedAt,
  'workflow_definition': instance.workflowDefinition,
};

const _$WorkflowInstanceSchemaStatusEnumEnumMap = {
  WorkflowInstanceSchemaStatusEnum.pending: 'pending',
  WorkflowInstanceSchemaStatusEnum.inReview: 'in_review',
  WorkflowInstanceSchemaStatusEnum.approved: 'approved',
  WorkflowInstanceSchemaStatusEnum.rejected: 'rejected',
  WorkflowInstanceSchemaStatusEnum.reverted: 'reverted',
};
