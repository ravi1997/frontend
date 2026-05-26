// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenPayload _$TokenPayloadFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokenPayload', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['exp', 'iat', 'jti', 'sub']);
      final val = TokenPayload(
        exp: $checkedConvert('exp', (v) => (v as num).toInt()),
        iat: $checkedConvert('iat', (v) => (v as num).toInt()),
        jti: $checkedConvert('jti', (v) => v as String),
        roles: $checkedConvert(
          'roles',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        sub: $checkedConvert('sub', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TokenPayloadToJson(TokenPayload instance) =>
    <String, dynamic>{
      'exp': instance.exp,
      'iat': instance.iat,
      'jti': instance.jti,
      'roles': ?instance.roles,
      'sub': instance.sub,
    };
