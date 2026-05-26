// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_auth_login_post200_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1AuthLoginPost200ResponseData
_$FormApiV1AuthLoginPost200ResponseDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FormApiV1AuthLoginPost200ResponseData',
      json,
      ($checkedConvert) {
        final val = FormApiV1AuthLoginPost200ResponseData(
          accessToken: $checkedConvert('access_token', (v) => v as String?),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String?),
          user: $checkedConvert(
            'user',
            (v) =>
                v == null ? null : UserOut.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token',
      },
    );

Map<String, dynamic> _$FormApiV1AuthLoginPost200ResponseDataToJson(
  FormApiV1AuthLoginPost200ResponseData instance,
) => <String, dynamic>{
  'access_token': ?instance.accessToken,
  'refresh_token': ?instance.refreshToken,
  'user': ?instance.user?.toJson(),
};
