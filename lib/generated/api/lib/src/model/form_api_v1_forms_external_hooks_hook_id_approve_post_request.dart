//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'form_api_v1_forms_external_hooks_hook_id_approve_post_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormApiV1FormsExternalHooksHookIdApprovePostRequest {
  /// Returns a new [FormApiV1FormsExternalHooksHookIdApprovePostRequest] instance.
  FormApiV1FormsExternalHooksHookIdApprovePostRequest({

     this.status,
  });

  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false
  )


  final FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnum? status;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FormApiV1FormsExternalHooksHookIdApprovePostRequest &&
     other.status == status;

  @override
  int get hashCode =>
    status.hashCode;

  factory FormApiV1FormsExternalHooksHookIdApprovePostRequest.fromJson(Map<String, dynamic> json) => _$FormApiV1FormsExternalHooksHookIdApprovePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FormApiV1FormsExternalHooksHookIdApprovePostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum FormApiV1FormsExternalHooksHookIdApprovePostRequestStatusEnum {
  @JsonValue(r'approved')
  approved,
  @JsonValue(r'rejected')
  rejected,
}


