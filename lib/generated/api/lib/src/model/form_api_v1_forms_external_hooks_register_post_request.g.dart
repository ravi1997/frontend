// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_forms_external_hooks_register_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1FormsExternalHooksRegisterPostRequest
_$FormApiV1FormsExternalHooksRegisterPostRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'FormApiV1FormsExternalHooksRegisterPostRequest',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['name', 'url']);
    final val = FormApiV1FormsExternalHooksRegisterPostRequest(
      headers: $checkedConvert('headers', (v) => v),
      inputSchema: $checkedConvert('input_schema', (v) => v),
      method: $checkedConvert('method', (v) => v as String? ?? 'POST'),
      name: $checkedConvert('name', (v) => v as String),
      outputSchema: $checkedConvert('output_schema', (v) => v),
      url: $checkedConvert('url', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'inputSchema': 'input_schema',
    'outputSchema': 'output_schema',
  },
);

Map<String, dynamic> _$FormApiV1FormsExternalHooksRegisterPostRequestToJson(
  FormApiV1FormsExternalHooksRegisterPostRequest instance,
) => <String, dynamic>{
  'headers': ?instance.headers,
  'input_schema': ?instance.inputSchema,
  'method': ?instance.method,
  'name': instance.name,
  'output_schema': ?instance.outputSchema,
  'url': instance.url,
};
