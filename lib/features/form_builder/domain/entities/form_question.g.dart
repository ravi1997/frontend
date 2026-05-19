// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormQuestion _$FormQuestionFromJson(Map<String, dynamic> json) =>
    _FormQuestion(
      id: IdReader.readIdCallback(json, 'id') as String,
      variableName: json['variable_name'] as String?,
      label: json['label'],
      type: _questionTypeFromJson(json['field_type']),
      helperText: json['help_text'],
      placeholder: json['placeholder'],
      defaultValue: json['default_value'],
      validation: json['validation'] as Map<String, dynamic>?,
      isRequired: json['is_required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => FormQuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReadOnly: json['is_read_only'] as bool? ?? false,
      isHidden: json['is_hidden'] as bool? ?? false,
      isRepeatable: json['is_repeatable'] as bool? ?? false,
      repeatMin: (json['repeat_min'] as num?)?.toInt(),
      repeatMax: (json['repeat_max'] as num?)?.toInt(),
      keepLastValue: json['keep_last_value'] as bool? ?? false,
      validationRegex: json['validationRegex'] as String?,
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLength: (json['maxLength'] as num?)?.toInt(),
      minValue: json['minValue'] as num?,
      maxValue: json['maxValue'] as num?,
      inputMask: json['inputMask'] as String?,
      customErrorMessage: json['customErrorMessage'] as String?,
      dateMin: json['dateMin'] == null
          ? null
          : DateTime.parse(json['dateMin'] as String),
      dateMax: json['dateMax'] == null
          ? null
          : DateTime.parse(json['dateMax'] as String),
      allowedFileTypes: (json['allowedFileTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxFileSize: (json['maxFileSize'] as num?)?.toInt(),
      maxFiles: (json['maxFiles'] as num?)?.toInt(),
      isUnique: json['isUnique'] as bool?,
      requiresConfirmation: json['requiresConfirmation'] as bool?,
      minSelection: (json['minSelection'] as num?)?.toInt(),
      maxSelection: (json['maxSelection'] as num?)?.toInt(),
      minWordCount: (json['minWordCount'] as num?)?.toInt(),
      maxWordCount: (json['maxWordCount'] as num?)?.toInt(),
      disablePastDates: json['disablePastDates'] as bool?,
      disableFutureDates: json['disableFutureDates'] as bool?,
      disableWeekends: json['disableWeekends'] as bool?,
      conditionalLogic: json['conditional_logic'] as Map<String, dynamic>?,
      actionConfig: json['action_config'] as Map<String, dynamic>?,
      metadata: json['meta_data'] as Map<String, dynamic>?,
      style: json['style'] == null
          ? const QuestionStyle()
          : QuestionStyle.fromJson(json['style'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormQuestionToJson(_FormQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variable_name': instance.variableName,
      'label': instance.label,
      'field_type': _$QuestionTypeEnumMap[instance.type]!,
      'help_text': instance.helperText,
      'default_value': instance.defaultValue,
      'options': instance.options,
      'is_read_only': instance.isReadOnly,
      'is_hidden': instance.isHidden,
      'is_repeatable': instance.isRepeatable,
      'repeat_min': instance.repeatMin,
      'repeat_max': instance.repeatMax,
      'keep_last_value': instance.keepLastValue,
      'meta_data': instance.metadata,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.shortText: 'input',
  QuestionType.paragraph: 'textarea',
  QuestionType.number: 'number',
  QuestionType.password: 'password',
  QuestionType.date: 'date',
  QuestionType.time: 'time',
  QuestionType.tel: 'tel',
  QuestionType.calculate: 'calculate',
  QuestionType.dropdown: 'select',
  QuestionType.checkboxes: 'checkboxes',
  QuestionType.multipleChoice: 'radio',
  QuestionType.fileUpload: 'file_upload',
  QuestionType.multiFileUpload: 'multi-file_upload',
  QuestionType.filePicker: 'file_picker',
  QuestionType.fileList: 'file_list',
  QuestionType.email: 'email',
  QuestionType.mobile: 'mobile',
  QuestionType.url: 'url',
  QuestionType.rating: 'rating',
  QuestionType.signature: 'signature',
  QuestionType.signaturePad: 'signature_pad',
  QuestionType.slider: 'slider',
  QuestionType.image: 'image',
  QuestionType.imageGallery: 'image_gallery',
  QuestionType.divider: 'note',
  QuestionType.spacer: 'hidden',
  QuestionType.matrixChoice: 'matrix_choice',
  QuestionType.mapLocation: 'map_location',
  QuestionType.address: 'address',
  QuestionType.addressLookup: 'address_lookup',
  QuestionType.otp: 'otp',
  QuestionType.richText: 'rich_text',
  QuestionType.markdownEditor: 'markdown_editor',
  QuestionType.booleanValue: 'boolean',
  QuestionType.multiSelect: 'multi_select',
  QuestionType.calculated: 'calculated',
  QuestionType.customField: 'custom_field',
  QuestionType.colorPicker: 'color_picker',
  QuestionType.range: 'range',
  QuestionType.dateRange: 'date_range',
  QuestionType.timeRange: 'time_range',
  QuestionType.stepper: 'stepper',
  QuestionType.countrySelect: 'country_select',
  QuestionType.stateSelect: 'state_select',
  QuestionType.citySelect: 'city_select',
  QuestionType.socialMediaHandle: 'social_media_handle',
  QuestionType.websiteUrl: 'website_url',
  QuestionType.phoneNumber: 'phone_number',
  QuestionType.captcha: 'captcha',
  QuestionType.unitSelect: 'unit_select',
  QuestionType.price: 'price',
  QuestionType.age: 'age',
  QuestionType.toggle: 'toggle',
  QuestionType.multiCheckbox: 'multi_checkbox',
  QuestionType.emailList: 'email_list',
  QuestionType.qrCodeScan: 'qr_code_scan',
  QuestionType.search: 'search',
  QuestionType.file: 'file',
};
