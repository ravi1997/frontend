//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ridp_api/src/model/mahasangraha_api_v1_auth_login_post200_response_data.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_auth_login_post200_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AuthLoginPost200Response {
  /// Returns a new [MahasangrahaApiV1AuthLoginPost200Response] instance.
  MahasangrahaApiV1AuthLoginPost200Response({

     this.data,

     this.success,
  });

  @JsonKey(
    
    name: r'data',
    required: false,
    includeIfNull: false,
  )


  final MahasangrahaApiV1AuthLoginPost200ResponseData? data;



  @JsonKey(
    
    name: r'success',
    required: false,
    includeIfNull: false,
  )


  final bool? success;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AuthLoginPost200Response &&
      other.data == data &&
      other.success == success;

    @override
    int get hashCode =>
        data.hashCode +
        success.hashCode;

  factory MahasangrahaApiV1AuthLoginPost200Response.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AuthLoginPost200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AuthLoginPost200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

