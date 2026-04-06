// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get username; String get email; List<String> get roles;@JsonKey(name: 'user_type') String get userType;@JsonKey(name: 'employee_id') String? get employeeId;@JsonKey(name: 'mobile') String? get mobile; String? get department;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'tenant_id') String get tenantId;// Extra fields returned by the admin detail endpoint
@JsonKey(name: 'is_admin') bool get isAdminFlag;@JsonKey(name: 'is_email_verified') bool get isEmailVerified;@JsonKey(name: 'failed_login_attempts') int get failedLoginAttempts;@JsonKey(name: 'otp_resend_count') int get otpResendCount;@JsonKey(name: 'lock_until') String? get lockUntil;@JsonKey(name: 'last_login') String? get lastLogin;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;@JsonKey(name: 'password_expiration') String? get passwordExpiration;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.department, department) || other.department == department)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.isAdminFlag, isAdminFlag) || other.isAdminFlag == isAdminFlag)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.failedLoginAttempts, failedLoginAttempts) || other.failedLoginAttempts == failedLoginAttempts)&&(identical(other.otpResendCount, otpResendCount) || other.otpResendCount == otpResendCount)&&(identical(other.lockUntil, lockUntil) || other.lockUntil == lockUntil)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.passwordExpiration, passwordExpiration) || other.passwordExpiration == passwordExpiration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,const DeepCollectionEquality().hash(roles),userType,employeeId,mobile,department,isActive,tenantId,isAdminFlag,isEmailVerified,failedLoginAttempts,otpResendCount,lockUntil,lastLogin,createdAt,updatedAt,passwordExpiration]);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, roles: $roles, userType: $userType, employeeId: $employeeId, mobile: $mobile, department: $department, isActive: $isActive, tenantId: $tenantId, isAdminFlag: $isAdminFlag, isEmailVerified: $isEmailVerified, failedLoginAttempts: $failedLoginAttempts, otpResendCount: $otpResendCount, lockUntil: $lockUntil, lastLogin: $lastLogin, createdAt: $createdAt, updatedAt: $updatedAt, passwordExpiration: $passwordExpiration)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String username, String email, List<String> roles,@JsonKey(name: 'user_type') String userType,@JsonKey(name: 'employee_id') String? employeeId,@JsonKey(name: 'mobile') String? mobile, String? department,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'tenant_id') String tenantId,@JsonKey(name: 'is_admin') bool isAdminFlag,@JsonKey(name: 'is_email_verified') bool isEmailVerified,@JsonKey(name: 'failed_login_attempts') int failedLoginAttempts,@JsonKey(name: 'otp_resend_count') int otpResendCount,@JsonKey(name: 'lock_until') String? lockUntil,@JsonKey(name: 'last_login') String? lastLogin,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'password_expiration') String? passwordExpiration
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? roles = null,Object? userType = null,Object? employeeId = freezed,Object? mobile = freezed,Object? department = freezed,Object? isActive = null,Object? tenantId = null,Object? isAdminFlag = null,Object? isEmailVerified = null,Object? failedLoginAttempts = null,Object? otpResendCount = null,Object? lockUntil = freezed,Object? lastLogin = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? passwordExpiration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,isAdminFlag: null == isAdminFlag ? _self.isAdminFlag : isAdminFlag // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,failedLoginAttempts: null == failedLoginAttempts ? _self.failedLoginAttempts : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
as int,otpResendCount: null == otpResendCount ? _self.otpResendCount : otpResendCount // ignore: cast_nullable_to_non_nullable
as int,lockUntil: freezed == lockUntil ? _self.lockUntil : lockUntil // ignore: cast_nullable_to_non_nullable
as String?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,passwordExpiration: freezed == passwordExpiration ? _self.passwordExpiration : passwordExpiration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String email,  List<String> roles, @JsonKey(name: 'user_type')  String userType, @JsonKey(name: 'employee_id')  String? employeeId, @JsonKey(name: 'mobile')  String? mobile,  String? department, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'tenant_id')  String tenantId, @JsonKey(name: 'is_admin')  bool isAdminFlag, @JsonKey(name: 'is_email_verified')  bool isEmailVerified, @JsonKey(name: 'failed_login_attempts')  int failedLoginAttempts, @JsonKey(name: 'otp_resend_count')  int otpResendCount, @JsonKey(name: 'lock_until')  String? lockUntil, @JsonKey(name: 'last_login')  String? lastLogin, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'password_expiration')  String? passwordExpiration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.roles,_that.userType,_that.employeeId,_that.mobile,_that.department,_that.isActive,_that.tenantId,_that.isAdminFlag,_that.isEmailVerified,_that.failedLoginAttempts,_that.otpResendCount,_that.lockUntil,_that.lastLogin,_that.createdAt,_that.updatedAt,_that.passwordExpiration);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String email,  List<String> roles, @JsonKey(name: 'user_type')  String userType, @JsonKey(name: 'employee_id')  String? employeeId, @JsonKey(name: 'mobile')  String? mobile,  String? department, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'tenant_id')  String tenantId, @JsonKey(name: 'is_admin')  bool isAdminFlag, @JsonKey(name: 'is_email_verified')  bool isEmailVerified, @JsonKey(name: 'failed_login_attempts')  int failedLoginAttempts, @JsonKey(name: 'otp_resend_count')  int otpResendCount, @JsonKey(name: 'lock_until')  String? lockUntil, @JsonKey(name: 'last_login')  String? lastLogin, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'password_expiration')  String? passwordExpiration)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.username,_that.email,_that.roles,_that.userType,_that.employeeId,_that.mobile,_that.department,_that.isActive,_that.tenantId,_that.isAdminFlag,_that.isEmailVerified,_that.failedLoginAttempts,_that.otpResendCount,_that.lockUntil,_that.lastLogin,_that.createdAt,_that.updatedAt,_that.passwordExpiration);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String email,  List<String> roles, @JsonKey(name: 'user_type')  String userType, @JsonKey(name: 'employee_id')  String? employeeId, @JsonKey(name: 'mobile')  String? mobile,  String? department, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'tenant_id')  String tenantId, @JsonKey(name: 'is_admin')  bool isAdminFlag, @JsonKey(name: 'is_email_verified')  bool isEmailVerified, @JsonKey(name: 'failed_login_attempts')  int failedLoginAttempts, @JsonKey(name: 'otp_resend_count')  int otpResendCount, @JsonKey(name: 'lock_until')  String? lockUntil, @JsonKey(name: 'last_login')  String? lastLogin, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt, @JsonKey(name: 'password_expiration')  String? passwordExpiration)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.roles,_that.userType,_that.employeeId,_that.mobile,_that.department,_that.isActive,_that.tenantId,_that.isAdminFlag,_that.isEmailVerified,_that.failedLoginAttempts,_that.otpResendCount,_that.lockUntil,_that.lastLogin,_that.createdAt,_that.updatedAt,_that.passwordExpiration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.id, required this.username, required this.email, final  List<String> roles = const [], @JsonKey(name: 'user_type') required this.userType, @JsonKey(name: 'employee_id') this.employeeId, @JsonKey(name: 'mobile') this.mobile, this.department, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'tenant_id') this.tenantId = 'default_tenant', @JsonKey(name: 'is_admin') this.isAdminFlag = false, @JsonKey(name: 'is_email_verified') this.isEmailVerified = false, @JsonKey(name: 'failed_login_attempts') this.failedLoginAttempts = 0, @JsonKey(name: 'otp_resend_count') this.otpResendCount = 0, @JsonKey(name: 'lock_until') this.lockUntil, @JsonKey(name: 'last_login') this.lastLogin, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'password_expiration') this.passwordExpiration}): _roles = roles,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String username;
@override final  String email;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey(name: 'user_type') final  String userType;
@override@JsonKey(name: 'employee_id') final  String? employeeId;
@override@JsonKey(name: 'mobile') final  String? mobile;
@override final  String? department;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'tenant_id') final  String tenantId;
// Extra fields returned by the admin detail endpoint
@override@JsonKey(name: 'is_admin') final  bool isAdminFlag;
@override@JsonKey(name: 'is_email_verified') final  bool isEmailVerified;
@override@JsonKey(name: 'failed_login_attempts') final  int failedLoginAttempts;
@override@JsonKey(name: 'otp_resend_count') final  int otpResendCount;
@override@JsonKey(name: 'lock_until') final  String? lockUntil;
@override@JsonKey(name: 'last_login') final  String? lastLogin;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override@JsonKey(name: 'password_expiration') final  String? passwordExpiration;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.department, department) || other.department == department)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.isAdminFlag, isAdminFlag) || other.isAdminFlag == isAdminFlag)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.failedLoginAttempts, failedLoginAttempts) || other.failedLoginAttempts == failedLoginAttempts)&&(identical(other.otpResendCount, otpResendCount) || other.otpResendCount == otpResendCount)&&(identical(other.lockUntil, lockUntil) || other.lockUntil == lockUntil)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.passwordExpiration, passwordExpiration) || other.passwordExpiration == passwordExpiration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,const DeepCollectionEquality().hash(_roles),userType,employeeId,mobile,department,isActive,tenantId,isAdminFlag,isEmailVerified,failedLoginAttempts,otpResendCount,lockUntil,lastLogin,createdAt,updatedAt,passwordExpiration]);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, roles: $roles, userType: $userType, employeeId: $employeeId, mobile: $mobile, department: $department, isActive: $isActive, tenantId: $tenantId, isAdminFlag: $isAdminFlag, isEmailVerified: $isEmailVerified, failedLoginAttempts: $failedLoginAttempts, otpResendCount: $otpResendCount, lockUntil: $lockUntil, lastLogin: $lastLogin, createdAt: $createdAt, updatedAt: $updatedAt, passwordExpiration: $passwordExpiration)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String email, List<String> roles,@JsonKey(name: 'user_type') String userType,@JsonKey(name: 'employee_id') String? employeeId,@JsonKey(name: 'mobile') String? mobile, String? department,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'tenant_id') String tenantId,@JsonKey(name: 'is_admin') bool isAdminFlag,@JsonKey(name: 'is_email_verified') bool isEmailVerified,@JsonKey(name: 'failed_login_attempts') int failedLoginAttempts,@JsonKey(name: 'otp_resend_count') int otpResendCount,@JsonKey(name: 'lock_until') String? lockUntil,@JsonKey(name: 'last_login') String? lastLogin,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt,@JsonKey(name: 'password_expiration') String? passwordExpiration
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? roles = null,Object? userType = null,Object? employeeId = freezed,Object? mobile = freezed,Object? department = freezed,Object? isActive = null,Object? tenantId = null,Object? isAdminFlag = null,Object? isEmailVerified = null,Object? failedLoginAttempts = null,Object? otpResendCount = null,Object? lockUntil = freezed,Object? lastLogin = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? passwordExpiration = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,isAdminFlag: null == isAdminFlag ? _self.isAdminFlag : isAdminFlag // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,failedLoginAttempts: null == failedLoginAttempts ? _self.failedLoginAttempts : failedLoginAttempts // ignore: cast_nullable_to_non_nullable
as int,otpResendCount: null == otpResendCount ? _self.otpResendCount : otpResendCount // ignore: cast_nullable_to_non_nullable
as int,lockUntil: freezed == lockUntil ? _self.lockUntil : lockUntil // ignore: cast_nullable_to_non_nullable
as String?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,passwordExpiration: freezed == passwordExpiration ? _self.passwordExpiration : passwordExpiration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
