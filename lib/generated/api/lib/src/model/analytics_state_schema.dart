//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytics_state_schema.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AnalyticsStateSchema {
  /// Returns a new [AnalyticsStateSchema] instance.
  AnalyticsStateSchema({

    required  this.actionType,

    required  this.eventTimestamp,

    required  this.flattenedFields,

    required  this.formId,

    required  this.responseId,

    required  this.tenantId,
  });

  @JsonKey(
    
    name: r'action_type',
    required: true,
    includeIfNull: false,
  )


  final String actionType;



  @JsonKey(
    
    name: r'event_timestamp',
    required: true,
    includeIfNull: false,
  )


  final num eventTimestamp;



  @JsonKey(
    
    name: r'flattened_fields',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> flattenedFields;



  @JsonKey(
    
    name: r'form_id',
    required: true,
    includeIfNull: false,
  )


  final String formId;



  @JsonKey(
    
    name: r'response_id',
    required: true,
    includeIfNull: false,
  )


  final String responseId;



  @JsonKey(
    
    name: r'tenant_id',
    required: true,
    includeIfNull: false,
  )


  final String tenantId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AnalyticsStateSchema &&
      other.actionType == actionType &&
      other.eventTimestamp == eventTimestamp &&
      other.flattenedFields == flattenedFields &&
      other.formId == formId &&
      other.responseId == responseId &&
      other.tenantId == tenantId;

    @override
    int get hashCode =>
        actionType.hashCode +
        eventTimestamp.hashCode +
        flattenedFields.hashCode +
        formId.hashCode +
        responseId.hashCode +
        tenantId.hashCode;

  factory AnalyticsStateSchema.fromJson(Map<String, dynamic> json) => _$AnalyticsStateSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsStateSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

