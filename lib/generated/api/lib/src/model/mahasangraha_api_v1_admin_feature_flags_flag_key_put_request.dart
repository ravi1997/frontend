//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_admin_feature_flags_flag_key_put_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest {
  /// Returns a new [MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest] instance.
  MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest({

    required  this.isEnabled,
  });

  @JsonKey(
    
    name: r'is_enabled',
    required: true,
    includeIfNull: false,
  )


  final bool isEnabled;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest &&
      other.isEnabled == isEnabled;

    @override
    int get hashCode =>
        isEnabled.hashCode;

  factory MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AdminFeatureFlagsFlagKeyPutRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

