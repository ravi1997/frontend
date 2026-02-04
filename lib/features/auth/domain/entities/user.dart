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
    @JsonKey(name: 'user_type') required String userType,
    @JsonKey(name: 'employee_id') String? employeeId,
    @JsonKey(name: 'mobile') String? mobile,
  }) = _User;

  const User._();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
