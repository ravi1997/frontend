// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userType: json['user_type'] as String,
  employeeId: json['employee_id'] as String?,
  mobile: json['mobile'] as String?,
  department: json['department'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  tenantId: json['tenant_id'] as String? ?? 'default_tenant',
  isAdminFlag: json['is_admin'] as bool? ?? false,
  isEmailVerified: json['is_email_verified'] as bool? ?? false,
  failedLoginAttempts: (json['failed_login_attempts'] as num?)?.toInt() ?? 0,
  otpResendCount: (json['otp_resend_count'] as num?)?.toInt() ?? 0,
  lockUntil: json['lock_until'] as String?,
  lastLogin: json['last_login'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  passwordExpiration: json['password_expiration'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'roles': instance.roles,
  'user_type': instance.userType,
  'employee_id': instance.employeeId,
  'mobile': instance.mobile,
  'department': instance.department,
  'is_active': instance.isActive,
  'tenant_id': instance.tenantId,
  'is_admin': instance.isAdminFlag,
  'is_email_verified': instance.isEmailVerified,
  'failed_login_attempts': instance.failedLoginAttempts,
  'otp_resend_count': instance.otpResendCount,
  'lock_until': instance.lockUntil,
  'last_login': instance.lastLogin,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'password_expiration': instance.passwordExpiration,
};
