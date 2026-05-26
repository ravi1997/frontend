//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'validation_schema.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ValidationSchema {
  /// Returns a new [ValidationSchema] instance.
  ValidationSchema({

     this.id,

     this.allowedFileTypes,

     this.createdAt,

     this.customValidations,

     this.dateMax,

     this.dateMin,

     this.disableFutureDates = false,

     this.disablePastDates = false,

     this.disableWeekends = false,

     this.errorMessage,

     this.inputMask,

     this.isRequired = false,

     this.isUnique = false,

     this.logicalOperator = 'AND',

     this.maxFileSize,

     this.maxFiles,

     this.maxLength,

     this.maxSelection,

     this.maxValue,

     this.maxWordCount,

     this.minLength,

     this.minSelection,

     this.minValue,

     this.minWordCount,

     this.regex,

     this.requiredConditions,

     this.requiresConfirmation = false,

     this.updatedAt,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final Object? id;



  @JsonKey(
    
    name: r'allowed_file_types',
    required: false,
    includeIfNull: false
  )


  final List<String>? allowedFileTypes;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final Object? createdAt;



  @JsonKey(
    
    name: r'custom_validations',
    required: false,
    includeIfNull: false
  )


  final List<Object>? customValidations;



  @JsonKey(
    
    name: r'date_max',
    required: false,
    includeIfNull: false
  )


  final Object? dateMax;



  @JsonKey(
    
    name: r'date_min',
    required: false,
    includeIfNull: false
  )


  final Object? dateMin;



  @JsonKey(
    defaultValue: false,
    name: r'disable_future_dates',
    required: false,
    includeIfNull: false
  )


  final bool? disableFutureDates;



  @JsonKey(
    defaultValue: false,
    name: r'disable_past_dates',
    required: false,
    includeIfNull: false
  )


  final bool? disablePastDates;



  @JsonKey(
    defaultValue: false,
    name: r'disable_weekends',
    required: false,
    includeIfNull: false
  )


  final bool? disableWeekends;



  @JsonKey(
    
    name: r'error_message',
    required: false,
    includeIfNull: false
  )


  final Object? errorMessage;



  @JsonKey(
    
    name: r'input_mask',
    required: false,
    includeIfNull: false
  )


  final Object? inputMask;



  @JsonKey(
    defaultValue: false,
    name: r'is_required',
    required: false,
    includeIfNull: false
  )


  final bool? isRequired;



  @JsonKey(
    defaultValue: false,
    name: r'is_unique',
    required: false,
    includeIfNull: false
  )


  final bool? isUnique;



  @JsonKey(
    defaultValue: 'AND',
    name: r'logical_operator',
    required: false,
    includeIfNull: false
  )


  final String? logicalOperator;



  @JsonKey(
    
    name: r'max_file_size',
    required: false,
    includeIfNull: false
  )


  final Object? maxFileSize;



  @JsonKey(
    
    name: r'max_files',
    required: false,
    includeIfNull: false
  )


  final Object? maxFiles;



  @JsonKey(
    
    name: r'max_length',
    required: false,
    includeIfNull: false
  )


  final Object? maxLength;



  @JsonKey(
    
    name: r'max_selection',
    required: false,
    includeIfNull: false
  )


  final Object? maxSelection;



  @JsonKey(
    
    name: r'max_value',
    required: false,
    includeIfNull: false
  )


  final Object? maxValue;



  @JsonKey(
    
    name: r'max_word_count',
    required: false,
    includeIfNull: false
  )


  final Object? maxWordCount;



  @JsonKey(
    
    name: r'min_length',
    required: false,
    includeIfNull: false
  )


  final Object? minLength;



  @JsonKey(
    
    name: r'min_selection',
    required: false,
    includeIfNull: false
  )


  final Object? minSelection;



  @JsonKey(
    
    name: r'min_value',
    required: false,
    includeIfNull: false
  )


  final Object? minValue;



  @JsonKey(
    
    name: r'min_word_count',
    required: false,
    includeIfNull: false
  )


  final Object? minWordCount;



  @JsonKey(
    
    name: r'regex',
    required: false,
    includeIfNull: false
  )


  final Object? regex;



  @JsonKey(
    
    name: r'required_conditions',
    required: false,
    includeIfNull: false
  )


  final List<Object>? requiredConditions;



  @JsonKey(
    defaultValue: false,
    name: r'requires_confirmation',
    required: false,
    includeIfNull: false
  )


  final bool? requiresConfirmation;



  @JsonKey(
    
    name: r'updated_at',
    required: false,
    includeIfNull: false
  )


  final Object? updatedAt;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ValidationSchema &&
     other.id == id &&
     other.allowedFileTypes == allowedFileTypes &&
     other.createdAt == createdAt &&
     other.customValidations == customValidations &&
     other.dateMax == dateMax &&
     other.dateMin == dateMin &&
     other.disableFutureDates == disableFutureDates &&
     other.disablePastDates == disablePastDates &&
     other.disableWeekends == disableWeekends &&
     other.errorMessage == errorMessage &&
     other.inputMask == inputMask &&
     other.isRequired == isRequired &&
     other.isUnique == isUnique &&
     other.logicalOperator == logicalOperator &&
     other.maxFileSize == maxFileSize &&
     other.maxFiles == maxFiles &&
     other.maxLength == maxLength &&
     other.maxSelection == maxSelection &&
     other.maxValue == maxValue &&
     other.maxWordCount == maxWordCount &&
     other.minLength == minLength &&
     other.minSelection == minSelection &&
     other.minValue == minValue &&
     other.minWordCount == minWordCount &&
     other.regex == regex &&
     other.requiredConditions == requiredConditions &&
     other.requiresConfirmation == requiresConfirmation &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    id.hashCode +
    allowedFileTypes.hashCode +
    createdAt.hashCode +
    customValidations.hashCode +
    dateMax.hashCode +
    dateMin.hashCode +
    disableFutureDates.hashCode +
    disablePastDates.hashCode +
    disableWeekends.hashCode +
    errorMessage.hashCode +
    inputMask.hashCode +
    isRequired.hashCode +
    isUnique.hashCode +
    logicalOperator.hashCode +
    maxFileSize.hashCode +
    maxFiles.hashCode +
    maxLength.hashCode +
    maxSelection.hashCode +
    maxValue.hashCode +
    maxWordCount.hashCode +
    minLength.hashCode +
    minSelection.hashCode +
    minValue.hashCode +
    minWordCount.hashCode +
    regex.hashCode +
    requiredConditions.hashCode +
    requiresConfirmation.hashCode +
    updatedAt.hashCode;

  factory ValidationSchema.fromJson(Map<String, dynamic> json) => _$ValidationSchemaFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationSchemaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

