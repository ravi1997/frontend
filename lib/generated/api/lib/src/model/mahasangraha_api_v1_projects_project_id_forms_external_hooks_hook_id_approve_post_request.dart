//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_projects_project_id_forms_external_hooks_hook_id_approve_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest {
  /// Returns a new [MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest] instance.
  MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest({

     this.status,
  });

  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequestStatusEnum? status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest &&
      other.status == status;

    @override
    int get hashCode =>
        status.hashCode;

  factory MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequestStatusEnum {
@JsonValue(r'approved')
approved(r'approved'),
@JsonValue(r'rejected')
rejected(r'rejected');

const MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequestStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


