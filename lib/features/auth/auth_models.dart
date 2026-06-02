// lib/features/auth/auth_models.dart

class UserModel {
  final String id;
  final String username;
  final String email;
  final List<String> roles;
  final String? userType;
  final String? employeeId;
  final String? mobile;
  final String? department;
  final bool isActive;
  final String? organizationId;
  final bool isAdminFlag;
  final bool isDeleted;
  final bool isEmailVerified;
  final int failedLoginAttempts;
  final int otpResendCount;
  final String? lockUntil;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? passwordExpiration;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.roles = const [],
    this.userType,
    this.employeeId,
    this.mobile,
    this.department,
    this.isActive = true,
    this.organizationId,
    this.isAdminFlag = false,
    this.isDeleted = false,
    this.isEmailVerified = false,
    this.failedLoginAttempts = 0,
    this.otpResendCount = 0,
    this.lockUntil,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.passwordExpiration,
  });

  bool get isAdmin =>
      roles.contains('admin') || roles.contains('superadmin') || isAdminFlag;

  static const List<String> _roleOrder = <String>[
    'user',
    'manager',
    'admin',
    'superadmin',
  ];

  bool hasAtLeastRole(String role) {
    final requiredIndex = _roleOrder.indexOf(role);
    if (requiredIndex == -1) return false;

    for (final currentRole in roles) {
      final currentIndex = _roleOrder.indexOf(currentRole);
      if (currentIndex >= requiredIndex) {
        return true;
      }
    }

    return false;
  }

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
      return DateTime.parse(passwordExpiration!).isBefore(DateTime.now().toUtc());
    } catch (_) {
      return false;
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      userType: json['user_type'] as String?,
      employeeId: json['employee_id'] as String?,
      mobile: json['mobile'] as String?,
      department: json['department'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      organizationId: json['organization_id'] as String?,
      isAdminFlag: json['is_admin'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      failedLoginAttempts: json['failed_login_attempts'] as int? ?? 0,
      otpResendCount: json['otp_resend_count'] as int? ?? 0,
      lockUntil: json['lock_until'] as String?,
      lastLogin: json['last_login'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      passwordExpiration: json['password_expiration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
      'user_type': userType,
      'employee_id': employeeId,
      'mobile': mobile,
      'department': department,
      'is_active': isActive,
      'organization_id': organizationId,
      'is_admin': isAdminFlag,
      'is_deleted': isDeleted,
      'is_email_verified': isEmailVerified,
      'failed_login_attempts': failedLoginAttempts,
      'otp_resend_count': otpResendCount,
      'lock_until': lockUntil,
      'last_login': lastLogin,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'password_expiration': passwordExpiration,
    };
  }
}
