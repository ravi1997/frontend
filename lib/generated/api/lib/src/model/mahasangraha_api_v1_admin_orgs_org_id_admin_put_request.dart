//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_admin_orgs_org_id_admin_put_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest {
  /// Returns a new [MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest] instance.
  MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest({

    required  this.adminUserId,
  });

  @JsonKey(
    
    name: r'admin_user_id',
    required: true,
    includeIfNull: false,
  )


  final String adminUserId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest &&
      other.adminUserId == adminUserId;

    @override
    int get hashCode =>
        adminUserId.hashCode;

  factory MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AdminOrgsOrgIdAdminPutRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

