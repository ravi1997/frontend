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
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'roles': instance.roles,
  'user_type': instance.userType,
  'employee_id': instance.employeeId,
  'mobile': instance.mobile,
};
