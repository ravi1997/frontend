// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_auth_refresh_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1AuthRefreshPost200Response
_$FormApiV1AuthRefreshPost200ResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FormApiV1AuthRefreshPost200Response',
      json,
      ($checkedConvert) {
        final val = FormApiV1AuthRefreshPost200Response(
          accessToken: $checkedConvert('access_token', (v) => v as String?),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String?),
          success: $checkedConvert('success', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token',
      },
    );

Map<String, dynamic> _$FormApiV1AuthRefreshPost200ResponseToJson(
  FormApiV1AuthRefreshPost200Response instance,
) => <String, dynamic>{
  'access_token': ?instance.accessToken,
  'refresh_token': ?instance.refreshToken,
  'success': ?instance.success,
};
