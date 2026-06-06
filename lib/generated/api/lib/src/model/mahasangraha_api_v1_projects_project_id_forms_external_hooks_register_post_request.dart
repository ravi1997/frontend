//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_projects_project_id_forms_external_hooks_register_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest {
  /// Returns a new [MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest] instance.
  MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest({

     this.headers,

     this.inputSchema,

     this.method = 'POST',

    required  this.name,

     this.outputSchema,

    required  this.url,
  });

  @JsonKey(
    
    name: r'headers',
    required: false,
    includeIfNull: false,
  )


  final Object? headers;



  @JsonKey(
    
    name: r'input_schema',
    required: false,
    includeIfNull: false,
  )


  final Object? inputSchema;



  @JsonKey(
    defaultValue: 'POST',
    name: r'method',
    required: false,
    includeIfNull: false,
  )


  final String? method;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'output_schema',
    required: false,
    includeIfNull: false,
  )


  final Object? outputSchema;



  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest &&
      other.headers == headers &&
      other.inputSchema == inputSchema &&
      other.method == method &&
      other.name == name &&
      other.outputSchema == outputSchema &&
      other.url == url;

    @override
    int get hashCode =>
        headers.hashCode +
        inputSchema.hashCode +
        method.hashCode +
        name.hashCode +
        outputSchema.hashCode +
        url.hashCode;

  factory MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

