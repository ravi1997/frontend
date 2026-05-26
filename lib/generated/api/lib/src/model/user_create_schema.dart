//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_create_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserCreateSchema {
  /// Returns a new [UserCreateSchema] instance.
  UserCreateSchema({

     this.id,

     this.createdAt,

     this.deletedAt,

     this.department,

     this.email,

     this.employeeId,

     this.failedLoginAttempts,

     this.isActive = true,

     this.isAdmin = false,

     this.isDeleted = false,

     this.isEmailVerified = false,

     this.lastLogin,

     this.lockUntil,

     this.mobile,

     this.organizationId,

     this.otpResendCount,

    required  this.password,

     this.roles,

     this.updatedAt,

    required  this.userType,

     this.username,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'deleted_at',
    required: false,
    includeIfNull: false
  )


  final Object? deletedAt;



  @JsonKey(
    
    name: r'department',
    required: false,
    includeIfNull: false
  )


  final Object? department;



  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false
  )


  final Object? email;



  @JsonKey(
    
    name: r'employee_id',
    required: false,
    includeIfNull: false
  )


  final Object? employeeId;



  @JsonKey(
    
    name: r'failed_login_attempts',
    required: false,
    includeIfNull: false
  )


  final int? failedLoginAttempts;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false
  )


  final bool? isActive;



  @JsonKey(
    defaultValue: false,
    name: r'is_admin',
    required: false,
    includeIfNull: false
  )


  final bool? isAdmin;



  @JsonKey(
    defaultValue: false,
    name: r'is_deleted',
    required: false,
    includeIfNull: false
  )


  final bool? isDeleted;



  @JsonKey(
    defaultValue: false,
    name: r'is_email_verified',
    required: false,
    includeIfNull: false
  )


  final bool? isEmailVerified;



  @JsonKey(
    
    name: r'last_login',
    required: false,
    includeIfNull: false
  )


  final Object? lastLogin;



  @JsonKey(
    
    name: r'lock_until',
    required: false,
    includeIfNull: false
  )


  final Object? lockUntil;



  @JsonKey(
    
    name: r'mobile',
    required: false,
    includeIfNull: false
  )


  final Object? mobile;



  @JsonKey(
    
    name: r'organization_id',
    required: false,
    includeIfNull: false
  )


  final Object? organizationId;



  @JsonKey(
    
    name: r'otp_resend_count',
    required: false,
    includeIfNull: false
  )


  final int? otpResendCount;



  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false
  )


  final String password;



  @JsonKey(
    
    name: r'roles',
    required: false,
    includeIfNull: false
  )


  final List<UserCreateSchemaRolesEnum>? roles;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @JsonKey(
    
    name: r'user_type',
    required: true,
    includeIfNull: false
  )


  final UserCreateSchemaUserTypeEnum userType;



  @JsonKey(
    
    name: r'username',
    required: false,
    includeIfNull: false
  )


  final Object? username;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UserCreateSchema &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.deletedAt == deletedAt &&
     other.department == department &&
     other.email == email &&
     other.employeeId == employeeId &&
     other.failedLoginAttempts == failedLoginAttempts &&
     other.isActive == isActive &&
     other.isAdmin == isAdmin &&
     other.isDeleted == isDeleted &&
     other.isEmailVerified == isEmailVerified &&
     other.lastLogin == lastLogin &&
     other.lockUntil == lockUntil &&
     other.mobile == mobile &&
     other.organizationId == organizationId &&
     other.otpResendCount == otpResendCount &&
     other.password == password &&
     other.roles == roles &&
     other.updatedAt == updatedAt &&
     other.userType == userType &&
     other.username == username;

  @override
  int get hashCode =>
    id.hashCode +
    createdAt.hashCode +
    deletedAt.hashCode +
    department.hashCode +
    email.hashCode +
    employeeId.hashCode +
    failedLoginAttempts.hashCode +
    isActive.hashCode +
    isAdmin.hashCode +
    isDeleted.hashCode +
    isEmailVerified.hashCode +
    lastLogin.hashCode +
    lockUntil.hashCode +
    mobile.hashCode +
    organizationId.hashCode +
    otpResendCount.hashCode +
    password.hashCode +
    roles.hashCode +
    updatedAt.hashCode +
    userType.hashCode +
    username.hashCode;

  factory UserCreateSchema.fromJson(Map<String, dynamic> json) => _$UserCreateSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum UserUpdateSchemaRolesEnum {
  @JsonValue(r'superadmin')
  superadmin,
  @JsonValue(r'admin')
  admin,
  @JsonValue(r'user')
  user,
  @JsonValue(r'creator')
  creator,
  @JsonValue(r'editor')
  editor,
  @JsonValue(r'publisher')
  publisher,
  @JsonValue(r'deo')
  deo,
  @JsonValue(r'manager')
  manager,
  @JsonValue(r'general')
  general,
}



enum UserCreateSchemaUserTypeEnum {
  @JsonValue(r'employee')
  employee,
  @JsonValue(r'general')
  general,
}


