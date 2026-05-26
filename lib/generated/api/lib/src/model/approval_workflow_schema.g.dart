// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_workflow_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalWorkflowSchema _$ApprovalWorkflowSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ApprovalWorkflowSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['name']);
    final val = ApprovalWorkflowSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      description: $checkedConvert('description', (v) => v),
      initiatorGroups: $checkedConvert(
        'initiator_groups',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
      metaData: $checkedConvert('meta_data', (v) => v),
      name: $checkedConvert('name', (v) => v as String),
      steps: $checkedConvert(
        'steps',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'initiatorGroups': 'initiator_groups',
    'isActive': 'is_active',
    'metaData': 'meta_data',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ApprovalWorkflowSchemaToJson(
  ApprovalWorkflowSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'description': ?instance.description,
  'initiator_groups': ?instance.initiatorGroups,
  'is_active': ?instance.isActive,
  'meta_data': ?instance.metaData,
  'name': instance.name,
  'steps': ?instance.steps,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
};
