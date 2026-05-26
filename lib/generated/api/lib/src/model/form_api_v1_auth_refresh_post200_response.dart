//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'form_api_v1_auth_refresh_post200_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FormApiV1AuthRefreshPost200Response {
  /// Returns a new [FormApiV1AuthRefreshPost200Response] instance.
  FormApiV1AuthRefreshPost200Response({

     this.accessToken,

     this.refreshToken,

     this.success,
  });

  @JsonKey(
    
    name: r'access_token',
    required: false,
    includeIfNull: false
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'refresh_token',
    required: false,
    includeIfNull: false
  )


  final String? refreshToken;



  @JsonKey(
    
    name: r'success',
    required: false,
    includeIfNull: false
  )


  final bool? success;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FormApiV1AuthRefreshPost200Response &&
     other.accessToken == accessToken &&
     other.refreshToken == refreshToken &&
     other.success == success;

  @override
  int get hashCode =>
    accessToken.hashCode +
    refreshToken.hashCode +
    success.hashCode;

  factory FormApiV1AuthRefreshPost200Response.fromJson(Map<String, dynamic> json) => _$FormApiV1AuthRefreshPost200ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FormApiV1AuthRefreshPost200ResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

