//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_projects_project_id_forms_form_id_responses_filter_post_request_filters_inner.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner {
  /// Returns a new [MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner] instance.
  MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner({

    required  this.field,

    required  this.fieldType,

     this.isMeta,

    required  this.operator_,

     this.value,
  });

  @JsonKey(
    
    name: r'field',
    required: true,
    includeIfNull: false,
  )


  final String field;



  @JsonKey(
    
    name: r'field_type',
    required: true,
    includeIfNull: false,
  )


  final MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInnerFieldTypeEnum fieldType;



  @JsonKey(
    
    name: r'is_meta',
    required: false,
    includeIfNull: false,
  )


  final bool? isMeta;



  @JsonKey(
    
    name: r'operator',
    required: true,
    includeIfNull: false,
  )


  final String operator_;



  @JsonKey(
    
    name: r'value',
    required: false,
    includeIfNull: false,
  )


  final Object? value;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner &&
      other.field == field &&
      other.fieldType == fieldType &&
      other.isMeta == isMeta &&
      other.operator_ == operator_ &&
      other.value == value;

    @override
    int get hashCode =>
        field.hashCode +
        fieldType.hashCode +
        isMeta.hashCode +
        operator_.hashCode +
        value.hashCode;

  factory MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInnerFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInnerToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInnerFieldTypeEnum {
@JsonValue(r'string')
string(r'string'),
@JsonValue(r'number')
number(r'number'),
@JsonValue(r'date')
date(r'date'),
@JsonValue(r'boolean')
boolean(r'boolean');

const MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInnerFieldTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


