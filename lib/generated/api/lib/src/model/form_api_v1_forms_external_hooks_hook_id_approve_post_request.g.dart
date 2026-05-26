// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_api_v1_forms_external_hooks_hook_id_approve_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormApiV1FormsExternalHooksHookIdApprovePostRequest
_$FormApiV1FormsExternalHooksHookIdApprovePostRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'FormApiV1FormsExternalHooksHookIdApprovePostRequest',
  json,
  ($checkedConvert) {
    final val = FormApiV1FormsExternalHooksHookIdApprovePostRequest(
      status: $checkedConvert(
        'status',
        (v) => $enumDecodeNullable(
          _$FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnumEnumMap,
          v,
        ),
      ),
    );
    return val;
  },
);

Map<String, dynamic>
_$FormApiV1FormsExternalHooksHookIdApprovePostRequestToJson(
  FormApiV1FormsExternalHooksHookIdApprovePostRequest instance,
) => <String, dynamic>{
  'status':
      ?_$FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnumEnumMap[instance
          .status],
};

const _$FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnumEnumMap = {
  FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnum.approved:
      'approved',
  FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnum.rejected:
      'rejected',
};
