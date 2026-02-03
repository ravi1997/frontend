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
    required String userType,
    String? employeeId,
    String? mobile,
  }) = _User;

  const User._();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
