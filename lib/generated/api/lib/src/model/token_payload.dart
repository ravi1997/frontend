//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'token_payload.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokenPayload {
  /// Returns a new [TokenPayload] instance.
  TokenPayload({

    required  this.exp,

    required  this.iat,

    required  this.jti,

     this.roles,

    required  this.sub,
  });

  @JsonKey(
    
    name: r'exp',
    required: true,
    includeIfNull: false
  )


  final int exp;



  @JsonKey(
    
    name: r'iat',
    required: true,
    includeIfNull: false
  )


  final int iat;



  @JsonKey(
    
    name: r'jti',
    required: true,
    includeIfNull: false
  )


  final String jti;



  @JsonKey(
    
    name: r'roles',
    required: false,
    includeIfNull: false
  )


  final List<String>? roles;



  @JsonKey(
    
    name: r'sub',
    required: true,
    includeIfNull: false
  )


  final String sub;



  @override
  bool operator ==(Object other) => identical(this, other) || other is TokenPayload &&
     other.exp == exp &&
     other.iat == iat &&
     other.jti == jti &&
     other.roles == roles &&
     other.sub == sub;

  @override
  int get hashCode =>
    exp.hashCode +
    iat.hashCode +
    jti.hashCode +
    roles.hashCode +
    sub.hashCode;

  factory TokenPayload.fromJson(Map<String, dynamic> json) => _$TokenPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$TokenPayloadToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

