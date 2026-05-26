// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroupSchema _$UserGroupSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserGroupSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['name']);
        final val = UserGroupSchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          description: $checkedConvert('description', (v) => v),
          isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
          members: $checkedConvert(
            'members',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          metaData: $checkedConvert('meta_data', (v) => v),
          name: $checkedConvert('name', (v) => v as String),
          organizationId: $checkedConvert('organization_id', (v) => v),
          owners: $checkedConvert(
            'owners',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
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
        'isActive': 'is_active',
        'metaData': 'meta_data',
        'organizationId': 'organization_id',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserGroupSchemaToJson(UserGroupSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'description': ?instance.description,
      'is_active': ?instance.isActive,
      'members': ?instance.members,
      'meta_data': ?instance.metaData,
      'name': instance.name,
      'organization_id': ?instance.organizationId,
      'owners': ?instance.owners,
      'tags': ?instance.tags,
      'updated_at': ?instance.updatedAt,
    };
