//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokenResponse {
  /// Returns a new [TokenResponse] instance.
  TokenResponse({

    required  this.accessToken,

    required  this.expiresIn,

     this.refreshToken,

     this.tokenType = 'bearer',
  });

  @JsonKey(
    
    name: r'access_token',
    required: true,
    includeIfNull: false
  )


  final String accessToken;



  @JsonKey(
    
    name: r'expires_in',
    required: true,
    includeIfNull: false
  )


  final int expiresIn;



  @JsonKey(
    
    name: r'refresh_token',
    required: false,
    includeIfNull: false
  )


  final Object? refreshToken;



  @JsonKey(
    defaultValue: 'bearer',
    name: r'token_type',
    required: false,
    includeIfNull: false
  )


  final String? tokenType;



  @override
  bool operator ==(Object other) => identical(this, other) || other is TokenResponse &&
     other.accessToken == accessToken &&
     other.expiresIn == expiresIn &&
     other.refreshToken == refreshToken &&
     other.tokenType == tokenType;

  @override
  int get hashCode =>
    accessToken.hashCode +
    expiresIn.hashCode +
    refreshToken.hashCode +
    tokenType.hashCode;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

