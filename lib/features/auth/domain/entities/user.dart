// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    @Default([]) List<String> roles,
    @JsonKey(name: 'user_type') String? userType,
    @JsonKey(name: 'employee_id') String? employeeId,
    @JsonKey(name: 'mobile') String? mobile,
    String? department,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'organization_id') String? organizationId,
    // Extra fields returned by the admin detail endpoint
    @JsonKey(name: 'is_admin') @Default(false) bool isAdminFlag,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'failed_login_attempts') @Default(0) int failedLoginAttempts,
    @JsonKey(name: 'otp_resend_count') @Default(0) int otpResendCount,
    @JsonKey(name: 'lock_until') String? lockUntil,
    @JsonKey(name: 'last_login') String? lastLogin,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @JsonKey(name: 'password_expiration') String? passwordExpiration,
  }) = _User;

  const User._();

  bool get isAdmin =>
      roles.contains('admin') || roles.contains('superadmin') || isAdminFlag;

  bool get isLocked {
    if (lockUntil == null) return false;
    try {
      return DateTime.parse(lockUntil!).isAfter(DateTime.now().toUtc());
    } catch (_) {
      return false;
    }
  }

  bool get isPasswordExpired {
    if (passwordExpiration == null) return false;
    try {
      return DateTime.parse(
        passwordExpiration!,
      ).isBefore(DateTime.now().toUtc());
    } catch (_) {
      return false;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
