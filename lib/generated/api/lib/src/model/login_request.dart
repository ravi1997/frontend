//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginRequest {
  /// Returns a new [LoginRequest] instance.
  LoginRequest({

     this.identifier,

     this.mobile,

     this.otp,

     this.password,
  });

      /// Username, email, or employee ID (for password login)
  @JsonKey(
    
    name: r'identifier',
    required: false,
    includeIfNull: false,
  )


  final Object? identifier;



      /// Mobile number (for OTP login)
  @JsonKey(
    
    name: r'mobile',
    required: false,
    includeIfNull: false,
  )


  final Object? mobile;



      /// OTP (for OTP login)
  @JsonKey(
    
    name: r'otp',
    required: false,
    includeIfNull: false,
  )


  final Object? otp;



      /// Password (for password login)
  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final Object? password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LoginRequest &&
      other.identifier == identifier &&
      other.mobile == mobile &&
      other.otp == otp &&
      other.password == password;

    @override
    int get hashCode =>
        identifier.hashCode +
        mobile.hashCode +
        otp.hashCode +
        password.hashCode;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

