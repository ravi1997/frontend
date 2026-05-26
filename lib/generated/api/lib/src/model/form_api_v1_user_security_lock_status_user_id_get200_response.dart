//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'form_api_v1_user_security_lock_status_user_id_get200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormApiV1UserSecurityLockStatusUserIdGet200Response {
  /// Returns a new [FormApiV1UserSecurityLockStatusUserIdGet200Response] instance.
  FormApiV1UserSecurityLockStatusUserIdGet200Response({

     this.failedLoginAttempts,

     this.isLocked,

     this.lockUntil,
  });

  @JsonKey(
    
    name: r'failed_login_attempts',
    required: false,
    includeIfNull: false
  )


  final int? failedLoginAttempts;



  @JsonKey(
    
    name: r'is_locked',
    required: false,
    includeIfNull: false
  )


  final bool? isLocked;



  @JsonKey(
    
    name: r'lock_until',
    required: false,
    includeIfNull: false
  )


  final DateTime? lockUntil;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FormApiV1UserSecurityLockStatusUserIdGet200Response &&
     other.failedLoginAttempts == failedLoginAttempts &&
     other.isLocked == isLocked &&
     other.lockUntil == lockUntil;

  @override
  int get hashCode =>
    failedLoginAttempts.hashCode +
    isLocked.hashCode +
    lockUntil.hashCode;

  factory FormApiV1UserSecurityLockStatusUserIdGet200Response.fromJson(Map<String, dynamic> json) => _$FormApiV1UserSecurityLockStatusUserIdGet200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FormApiV1UserSecurityLockStatusUserIdGet200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

