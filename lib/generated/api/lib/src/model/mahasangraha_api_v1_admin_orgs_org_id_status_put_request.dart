//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_admin_orgs_org_id_status_put_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest {
  /// Returns a new [MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest] instance.
  MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest({

    required  this.status,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequestStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest &&
      other.status == status;

    @override
    int get hashCode =>
        status.hashCode;

  factory MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequestStatusEnum {
@JsonValue(r'active')
active(r'active'),
@JsonValue(r'suspended')
suspended(r'suspended');

const MahasangrahaApiV1AdminOrgsOrgIdStatusPutRequestStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


