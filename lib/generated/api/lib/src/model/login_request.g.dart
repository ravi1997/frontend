// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginRequest', json, ($checkedConvert) {
      final val = LoginRequest(
        identifier: $checkedConvert('identifier', (v) => v),
        mobile: $checkedConvert('mobile', (v) => v),
        otp: $checkedConvert('otp', (v) => v),
        password: $checkedConvert('password', (v) => v),
      );
      return val;
    });

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'identifier': ?instance.identifier,
      'mobile': ?instance.mobile,
      'otp': ?instance.otp,
      'password': ?instance.password,
    };
