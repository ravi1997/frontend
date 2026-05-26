// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TokenResponse',
      json,
      ($checkedConvert) {
        $checkKeys(json, requiredKeys: const ['access_token', 'expires_in']);
        final val = TokenResponse(
          accessToken: $checkedConvert('access_token', (v) => v as String),
          expiresIn: $checkedConvert('expires_in', (v) => (v as num).toInt()),
          refreshToken: $checkedConvert('refresh_token', (v) => v),
          tokenType: $checkedConvert(
            'token_type',
            (v) => v as String? ?? 'bearer',
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'expiresIn': 'expires_in',
        'refreshToken': 'refresh_token',
        'tokenType': 'token_type',
      },
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'refresh_token': ?instance.refreshToken,
      'token_type': ?instance.tokenType,
    };
