// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_access_control_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceAccessControlSchema _$ResourceAccessControlSchemaFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ResourceAccessControlSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['resource_id', 'resource_type']);
    final val = ResourceAccessControlSchema(
      id: $checkedConvert('_id', (v) => v),
      accessLevel: $checkedConvert(
        'access_level',
        (v) =>
            $enumDecodeNullable(
              _$ResourceAccessControlSchemaAccessLevelEnumEnumMap,
              v,
            ) ??
            'private',
      ),
      approvalWorkflow: $checkedConvert('approval_workflow', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      entries: $checkedConvert(
        'entries',
        (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
      ),
      isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
      metaData: $checkedConvert('meta_data', (v) => v),
      resourceId: $checkedConvert('resource_id', (v) => v as String),
      resourceType: $checkedConvert(
        'resource_type',
        (v) => $enumDecode(
          _$ResourceAccessControlSchemaResourceTypeEnumEnumMap,
          v,
        ),
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
    'accessLevel': 'access_level',
    'approvalWorkflow': 'approval_workflow',
    'createdAt': 'created_at',
    'isActive': 'is_active',
    'metaData': 'meta_data',
    'resourceId': 'resource_id',
    'resourceType': 'resource_type',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$ResourceAccessControlSchemaToJson(
  ResourceAccessControlSchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'access_level':
      ?_$ResourceAccessControlSchemaAccessLevelEnumEnumMap[instance
          .accessLevel],
  'approval_workflow': ?instance.approvalWorkflow,
  'created_at': ?instance.createdAt,
  'entries': ?instance.entries,
  'is_active': ?instance.isActive,
  'meta_data': ?instance.metaData,
  'resource_id': instance.resourceId,
  'resource_type':
      _$ResourceAccessControlSchemaResourceTypeEnumEnumMap[instance
          .resourceType]!,
  'tags': ?instance.tags,
  'updated_at': ?instance.updatedAt,
};

const _$ResourceAccessControlSchemaAccessLevelEnumEnumMap = {
  ResourceAccessControlSchemaAccessLevelEnum.private: 'private',
  ResourceAccessControlSchemaAccessLevelEnum.group: 'group',
  ResourceAccessControlSchemaAccessLevelEnum.organization: 'organization',
  ResourceAccessControlSchemaAccessLevelEnum.public: 'public',
};

const _$ResourceAccessControlSchemaResourceTypeEnumEnumMap = {
  ResourceAccessControlSchemaResourceTypeEnum.form: 'form',
  ResourceAccessControlSchemaResourceTypeEnum.project: 'project',
  ResourceAccessControlSchemaResourceTypeEnum.submission: 'submission',
  ResourceAccessControlSchemaResourceTypeEnum.view: 'view',
};
