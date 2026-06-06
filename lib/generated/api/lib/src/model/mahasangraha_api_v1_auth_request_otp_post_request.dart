//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_auth_request_otp_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AuthRequestOtpPostRequest {
  /// Returns a new [MahasangrahaApiV1AuthRequestOtpPostRequest] instance.
  MahasangrahaApiV1AuthRequestOtpPostRequest({

     this.email,

     this.mobile,
  });

  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'mobile',
    required: false,
    includeIfNull: false,
  )


  final String? mobile;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AuthRequestOtpPostRequest &&
      other.email == email &&
      other.mobile == mobile;

    @override
    int get hashCode =>
        email.hashCode +
        mobile.hashCode;

  factory MahasangrahaApiV1AuthRequestOtpPostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AuthRequestOtpPostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AuthRequestOtpPostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

