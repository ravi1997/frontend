// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_entry_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessEntrySchema _$AccessEntrySchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AccessEntrySchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['grantee_type']);
        final val = AccessEntrySchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          granteeGroup: $checkedConvert('grantee_group', (v) => v),
          granteeType: $checkedConvert(
            'grantee_type',
            (v) => $enumDecode(_$AccessEntrySchemaGranteeTypeEnumEnumMap, v),
          ),
          granteeUser: $checkedConvert('grantee_user', (v) => v),
          permissions: $checkedConvert(
            'permissions',
            (v) => (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      $enumDecode(_$AccessEntrySchemaPermissionsEnumEnumMap, e),
                )
                .toList(),
          ),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'granteeGroup': 'grantee_group',
        'granteeType': 'grantee_type',
        'granteeUser': 'grantee_user',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$AccessEntrySchemaToJson(AccessEntrySchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'grantee_group': ?instance.granteeGroup,
      'grantee_type':
          _$AccessEntrySchemaGranteeTypeEnumEnumMap[instance.granteeType]!,
      'grantee_user': ?instance.granteeUser,
      'permissions': ?instance.permissions
          ?.map((e) => _$AccessEntrySchemaPermissionsEnumEnumMap[e]!)
          .toList(),
      'updated_at': ?instance.updatedAt,
    };

const _$AccessEntrySchemaGranteeTypeEnumEnumMap = {
  AccessEntrySchemaGranteeTypeEnum.user: 'user',
  AccessEntrySchemaGranteeTypeEnum.group: 'group',
};

const _$AccessEntrySchemaPermissionsEnumEnumMap = {
  AccessEntrySchemaPermissionsEnum.view: 'view',
  AccessEntrySchemaPermissionsEnum.edit: 'edit',
  AccessEntrySchemaPermissionsEnum.delete: 'delete',
  AccessEntrySchemaPermissionsEnum.publish: 'publish',
  AccessEntrySchemaPermissionsEnum.exportData: 'export_data',
  AccessEntrySchemaPermissionsEnum.manageAccess: 'manage_access',
  AccessEntrySchemaPermissionsEnum.approveSubmissions: 'approve_submissions',
};
