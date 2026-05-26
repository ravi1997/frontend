// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_auth_login_post200_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1AuthLoginPost200Response _$FormApiV1AuthLoginPost200ResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('FormApiV1AuthLoginPost200Response', json, (
  $checkedConvert,
) {
  final val = FormApiV1AuthLoginPost200Response(
    data: $checkedConvert(
      'data',
      (v) => v == null
          ? null
          : FormApiV1AuthLoginPost200ResponseData.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
    success: $checkedConvert('success', (v) => v as bool?),
  );
  return val;
});

Map<String, dynamic> _$FormApiV1AuthLoginPost200ResponseToJson(
  FormApiV1AuthLoginPost200Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'success': ?instance.success,
};
