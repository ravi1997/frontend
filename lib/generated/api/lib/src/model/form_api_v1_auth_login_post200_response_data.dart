//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ridp_api/src/model/user_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_api_v1_auth_login_post200_response_data.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormApiV1AuthLoginPost200ResponseData {
  /// Returns a new [FormApiV1AuthLoginPost200ResponseData] instance.
  FormApiV1AuthLoginPost200ResponseData({

     this.accessToken,

     this.refreshToken,

     this.user,
  });

  @JsonKey(
    
    name: r'access_token',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'refresh_token',
    required: false,
    includeIfNull: false,
  )


  final String? refreshToken;



  @JsonKey(
    
    name: r'user',
    required: false,
    includeIfNull: false,
  )


  final UserOut? user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FormApiV1AuthLoginPost200ResponseData &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.user == user;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        user.hashCode;

  factory FormApiV1AuthLoginPost200ResponseData.fromJson(Map<String, dynamic> json) => _$FormApiV1AuthLoginPost200ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormApiV1AuthLoginPost200ResponseDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

