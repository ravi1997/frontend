// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationSchema _$ValidationSchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ValidationSchema',
      json,
      ($checkedConvert) {
        final val = ValidationSchema(
          id: $checkedConvert('_id', (v) => v),
          allowedFileTypes: $checkedConvert(
            'allowed_file_types',
            (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
          ),
          createdAt: $checkedConvert('created_at', (v) => v),
          customValidations: $checkedConvert(
            'custom_validations',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
          dateMax: $checkedConvert('date_max', (v) => v),
          dateMin: $checkedConvert('date_min', (v) => v),
          disableFutureDates: $checkedConvert(
            'disable_future_dates',
            (v) => v as bool? ?? false,
          ),
          disablePastDates: $checkedConvert(
            'disable_past_dates',
            (v) => v as bool? ?? false,
          ),
          disableWeekends: $checkedConvert(
            'disable_weekends',
            (v) => v as bool? ?? false,
          ),
          errorMessage: $checkedConvert('error_message', (v) => v),
          inputMask: $checkedConvert('input_mask', (v) => v),
          isRequired: $checkedConvert(
            'is_required',
            (v) => v as bool? ?? false,
          ),
          isUnique: $checkedConvert('is_unique', (v) => v as bool? ?? false),
          logicalOperator: $checkedConvert(
            'logical_operator',
            (v) => v as String? ?? 'AND',
          ),
          maxFileSize: $checkedConvert('max_file_size', (v) => v),
          maxFiles: $checkedConvert('max_files', (v) => v),
          maxLength: $checkedConvert('max_length', (v) => v),
          maxSelection: $checkedConvert('max_selection', (v) => v),
          maxValue: $checkedConvert('max_value', (v) => v),
          maxWordCount: $checkedConvert('max_word_count', (v) => v),
          minLength: $checkedConvert('min_length', (v) => v),
          minSelection: $checkedConvert('min_selection', (v) => v),
          minValue: $checkedConvert('min_value', (v) => v),
          minWordCount: $checkedConvert('min_word_count', (v) => v),
          regex: $checkedConvert('regex', (v) => v),
          requiredConditions: $checkedConvert(
            'required_conditions',
            (v) => (v as List<dynamic>?)?.map((e) => e as Object).toList(),
          ),
          requiresConfirmation: $checkedConvert(
            'requires_confirmation',
            (v) => v as bool? ?? false,
          ),
          updatedAt: $checkedConvert('updated_at', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'allowedFileTypes': 'allowed_file_types',
        'createdAt': 'created_at',
        'customValidations': 'custom_validations',
        'dateMax': 'date_max',
        'dateMin': 'date_min',
        'disableFutureDates': 'disable_future_dates',
        'disablePastDates': 'disable_past_dates',
        'disableWeekends': 'disable_weekends',
        'errorMessage': 'error_message',
        'inputMask': 'input_mask',
        'isRequired': 'is_required',
        'isUnique': 'is_unique',
        'logicalOperator': 'logical_operator',
        'maxFileSize': 'max_file_size',
        'maxFiles': 'max_files',
        'maxLength': 'max_length',
        'maxSelection': 'max_selection',
        'maxValue': 'max_value',
        'maxWordCount': 'max_word_count',
        'minLength': 'min_length',
        'minSelection': 'min_selection',
        'minValue': 'min_value',
        'minWordCount': 'min_word_count',
        'requiredConditions': 'required_conditions',
        'requiresConfirmation': 'requires_confirmation',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$ValidationSchemaToJson(ValidationSchema instance) =>
    <String, dynamic>{
      '_id': ?instance.id,
      'allowed_file_types': ?instance.allowedFileTypes,
      'created_at': ?instance.createdAt,
      'custom_validations': ?instance.customValidations,
      'date_max': ?instance.dateMax,
      'date_min': ?instance.dateMin,
      'disable_future_dates': ?instance.disableFutureDates,
      'disable_past_dates': ?instance.disablePastDates,
      'disable_weekends': ?instance.disableWeekends,
      'error_message': ?instance.errorMessage,
      'input_mask': ?instance.inputMask,
      'is_required': ?instance.isRequired,
      'is_unique': ?instance.isUnique,
      'logical_operator': ?instance.logicalOperator,
      'max_file_size': ?instance.maxFileSize,
      'max_files': ?instance.maxFiles,
      'max_length': ?instance.maxLength,
      'max_selection': ?instance.maxSelection,
      'max_value': ?instance.maxValue,
      'max_word_count': ?instance.maxWordCount,
      'min_length': ?instance.minLength,
      'min_selection': ?instance.minSelection,
      'min_value': ?instance.minValue,
      'min_word_count': ?instance.minWordCount,
      'regex': ?instance.regex,
      'required_conditions': ?instance.requiredConditions,
      'requires_confirmation': ?instance.requiresConfirmation,
      'updated_at': ?instance.updatedAt,
    };
