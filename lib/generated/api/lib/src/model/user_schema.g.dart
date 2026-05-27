// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSchema _$UserSchemaFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UserSchema',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['user_type']);
    final val = UserSchema(
      id: $checkedConvert('_id', (v) => v),
      createdAt: $checkedConvert('created_at', (v) => v),
      deletedAt: $checkedConvert('deleted_at', (v) => v),
      department: $checkedConvert('department', (v) => v),
      email: $checkedConvert('email', (v) => v),
      employeeId: $checkedConvert('employee_id', (v) => v),
      failedLoginAttempts: $checkedConvert(
        'failed_login_attempts',
        (v) => (v as num?)?.toInt(),
      ),
      isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
      isAdmin: $checkedConvert('is_admin', (v) => v as bool? ?? false),
      isDeleted: $checkedConvert('is_deleted', (v) => v as bool? ?? false),
      isEmailVerified: $checkedConvert(
        'is_email_verified',
        (v) => v as bool? ?? false,
      ),
      lastLogin: $checkedConvert('last_login', (v) => v),
      lockUntil: $checkedConvert('lock_until', (v) => v),
      mobile: $checkedConvert('mobile', (v) => v),
      organizationId: $checkedConvert('organization_id', (v) => v),
      otpResendCount: $checkedConvert(
        'otp_resend_count',
        (v) => (v as num?)?.toInt(),
      ),
      roles: $checkedConvert(
        'roles',
        (v) => (v as List<dynamic>?)
            ?.map((e) => $enumDecode(_$UserSchemaRolesEnumEnumMap, e))
            .toList(),
      ),
      updatedAt: $checkedConvert('updated_at', (v) => v),
      userType: $checkedConvert(
        'user_type',
        (v) => $enumDecode(_$UserSchemaUserTypeEnumEnumMap, v),
      ),
      username: $checkedConvert('username', (v) => v),
    );
    return val;
  },
  fieldKeyMap: const {
    'id': '_id',
    'createdAt': 'created_at',
    'deletedAt': 'deleted_at',
    'employeeId': 'employee_id',
    'failedLoginAttempts': 'failed_login_attempts',
    'isActive': 'is_active',
    'isAdmin': 'is_admin',
    'isDeleted': 'is_deleted',
    'isEmailVerified': 'is_email_verified',
    'lastLogin': 'last_login',
    'lockUntil': 'lock_until',
    'organizationId': 'organization_id',
    'otpResendCount': 'otp_resend_count',
    'updatedAt': 'updated_at',
    'userType': 'user_type',
  },
);

Map<String, dynamic> _$UserSchemaToJson(UserSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'created_at': ?instance.createdAt,
      'deleted_at': ?instance.deletedAt,
      'department': ?instance.department,
      'email': ?instance.email,
      'employee_id': ?instance.employeeId,
      'failed_login_attempts': ?instance.failedLoginAttempts,
      'is_active': ?instance.isActive,
      'is_admin': ?instance.isAdmin,
      'is_deleted': ?instance.isDeleted,
      'is_email_verified': ?instance.isEmailVerified,
      'last_login': ?instance.lastLogin,
      'lock_until': ?instance.lockUntil,
      'mobile': ?instance.mobile,
      'organization_id': ?instance.organizationId,
      'otp_resend_count': ?instance.otpResendCount,
      'roles': ?instance.roles
          ?.map((e) => _$UserSchemaRolesEnumEnumMap[e]!)
          .toList(),
      'updated_at': ?instance.updatedAt,
      'user_type': _$UserSchemaUserTypeEnumEnumMap[instance.userType]!,
      'username': ?instance.username,
    };

const _$UserSchemaRolesEnumEnumMap = {
  UserSchemaRolesEnum.superadmin: 'superadmin',
  UserSchemaRolesEnum.admin: 'admin',
  UserSchemaRolesEnum.user: 'user',
  UserSchemaRolesEnum.creator: 'creator',
  UserSchemaRolesEnum.editor: 'editor',
  UserSchemaRolesEnum.publisher: 'publisher',
  UserSchemaRolesEnum.deo: 'deo',
  UserSchemaRolesEnum.manager: 'manager',
  UserSchemaRolesEnum.general: 'general',
};

const _$UserSchemaUserTypeEnumEnumMap = {
  UserSchemaUserTypeEnum.employee: 'employee',
  UserSchemaUserTypeEnum.general: 'general',
};
