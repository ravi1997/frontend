// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_auth_request_otp_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1AuthRequestOtpPostRequest _$FormApiV1AuthRequestOtpPostRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('FormApiV1AuthRequestOtpPostRequest', json, (
  $checkedConvert,
) {
  final val = FormApiV1AuthRequestOtpPostRequest(
    email: $checkedConvert('email', (v) => v as String?),
    mobile: $checkedConvert('mobile', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$FormApiV1AuthRequestOtpPostRequestToJson(
  FormApiV1AuthRequestOtpPostRequest instance,
) => <String, dynamic>{'email': ?instance.email, 'mobile': ?instance.mobile};
