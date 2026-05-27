// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_create_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreateSchema _$UserCreateSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserCreateSchema',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['password', 'user_type']);
        final val = UserCreateSchema(
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
          password: $checkedConvert('password', (v) => v as String),
          roles: $checkedConvert(
            'roles',
            (v) => (v as List<dynamic>?)
                ?.map((e) => $enumDecode(_$UserCreateSchemaRolesEnumEnumMap, e))
                .toList(),
          ),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          userType: $checkedConvert(
            'user_type',
            (v) => $enumDecode(_$UserCreateSchemaUserTypeEnumEnumMap, v),
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

Map<String, dynamic> _$UserCreateSchemaToJson(UserCreateSchema instance) =>
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
      'password': instance.password,
      'roles': ?instance.roles
          ?.map((e) => _$UserCreateSchemaRolesEnumEnumMap[e]!)
          .toList(),
      'updated_at': ?instance.updatedAt,
      'user_type': _$UserCreateSchemaUserTypeEnumEnumMap[instance.userType]!,
      'username': ?instance.username,
    };

const _$UserCreateSchemaRolesEnumEnumMap = {
  UserCreateSchemaRolesEnum.superadmin: 'superadmin',
  UserCreateSchemaRolesEnum.admin: 'admin',
  UserCreateSchemaRolesEnum.user: 'user',
  UserCreateSchemaRolesEnum.creator: 'creator',
  UserCreateSchemaRolesEnum.editor: 'editor',
  UserCreateSchemaRolesEnum.publisher: 'publisher',
  UserCreateSchemaRolesEnum.deo: 'deo',
  UserCreateSchemaRolesEnum.manager: 'manager',
  UserCreateSchemaRolesEnum.general: 'general',
};

const _$UserCreateSchemaUserTypeEnumEnumMap = {
  UserCreateSchemaUserTypeEnum.employee: 'employee',
  UserCreateSchemaUserTypeEnum.general: 'general',
};
