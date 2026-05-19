// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/id_reader.dart';
import 'question_type.dart';
import 'form_style.dart';
import 'form_question_option.dart';

part 'form_question.freezed.dart';
part 'form_question.g.dart';

@freezed
abstract class FormQuestion with _$FormQuestion {
  const FormQuestion._();
  const factory FormQuestion({
    @JsonKey(readValue: IdReader.readIdCallback) required String id,
    @JsonKey(name: 'variable_name') String? variableName,
    required Object? label,
    @JsonKey(name: 'field_type', fromJson: _questionTypeFromJson)
    required QuestionType type,
    @JsonKey(name: 'help_text') Object? helperText,
    @JsonKey(includeToJson: false) Object? placeholder,
    @JsonKey(name: 'default_value') Object? defaultValue,
    @JsonKey(name: 'validation', includeToJson: false)
    Map<String, dynamic>? validation,
    @JsonKey(name: 'is_required', includeToJson: false)
    @Default(false)
    bool isRequired,
    List<FormQuestionOption>? options,
    @JsonKey(name: 'is_read_only') @Default(false) bool isReadOnly,
    @JsonKey(name: 'is_hidden') @Default(false) bool isHidden,
    @JsonKey(name: 'is_repeatable') @Default(false) bool isRepeatable,
    @JsonKey(name: 'repeat_min') int? repeatMin,
    @JsonKey(name: 'repeat_max') int? repeatMax,
    @JsonKey(name: 'keep_last_value') @Default(false) bool keepLastValue,
    @JsonKey(includeToJson: false) String? validationRegex,
    @JsonKey(includeToJson: false) int? minLength,
    @JsonKey(includeToJson: false) int? maxLength,
    @JsonKey(includeToJson: false) num? minValue,
    @JsonKey(includeToJson: false) num? maxValue,
    @JsonKey(includeToJson: false) String? inputMask,
    @JsonKey(includeToJson: false) String? customErrorMessage,

    // Advanced Validation
    @JsonKey(includeToJson: false) DateTime? dateMin,
    @JsonKey(includeToJson: false) DateTime? dateMax,
    @JsonKey(includeToJson: false) List<String>? allowedFileTypes,
    @JsonKey(includeToJson: false) int? maxFileSize, // in MB
    @JsonKey(includeToJson: false) int? maxFiles,
    @JsonKey(includeToJson: false) bool? isUnique,
    @JsonKey(includeToJson: false) bool? requiresConfirmation,

    // Checkbox / Select Limits
    @JsonKey(includeToJson: false) int? minSelection,
    @JsonKey(includeToJson: false) int? maxSelection,

    // Word Count (Paragraph)
    @JsonKey(includeToJson: false) int? minWordCount,
    @JsonKey(includeToJson: false) int? maxWordCount,

    // Date Constraints
    @JsonKey(includeToJson: false) bool? disablePastDates,
    @JsonKey(includeToJson: false) bool? disableFutureDates,
    @JsonKey(includeToJson: false) bool? disableWeekends,

    @JsonKey(name: 'conditional_logic', includeToJson: false)
    Map<String, dynamic>? conditionalLogic,
    @JsonKey(name: 'action_config', includeToJson: false)
    Map<String, dynamic>? actionConfig,
    @JsonKey(name: 'meta_data') Map<String, dynamic>? metadata,
    @JsonKey(includeToJson: false)
    @Default(QuestionStyle())
    QuestionStyle style,
  }) = _FormQuestion;

  factory FormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionFromJson(json);
}

QuestionType _questionTypeFromJson(Object? value) {
  final raw = value?.toString().trim().toLowerCase();
  switch (raw) {
    case 'short_text':
    case 'input':
      return QuestionType.shortText;
    case 'paragraph':
    case 'textarea':
      return QuestionType.paragraph;
    case 'password':
      return QuestionType.password;
    case 'dropdown':
    case 'select':
      return QuestionType.dropdown;
    case 'checkbox':
    case 'checkboxes':
      return QuestionType.checkboxes;
    case 'multi_select':
      return QuestionType.multiSelect;
    case 'radio':
    case 'multiple_choice':
      return QuestionType.multipleChoice;
    case 'file_upload':
      return QuestionType.fileUpload;
    case 'multi-file_upload':
      return QuestionType.multiFileUpload;
    case 'file_picker':
      return QuestionType.filePicker;
    case 'file_list':
      return QuestionType.fileList;
    case 'email':
      return QuestionType.email;
    case 'mobile':
      return QuestionType.mobile;
    case 'tel':
      return QuestionType.tel;
    case 'url':
      return QuestionType.url;
    case 'rating':
      return QuestionType.rating;
    case 'signature':
    case 'signature_pad':
      return QuestionType.signature;
    case 'slider':
      return QuestionType.slider;
    case 'image':
      return QuestionType.image;
    case 'image_gallery':
      return QuestionType.imageGallery;
    case 'note':
    case 'divider':
      return QuestionType.divider;
    case 'hidden':
    case 'spacer':
      return QuestionType.spacer;
    case 'matrix_choice':
      return QuestionType.matrixChoice;
    case 'number':
      return QuestionType.number;
    case 'date':
      return QuestionType.date;
    case 'time':
      return QuestionType.time;
    case 'calculate':
    case 'calculated':
      return QuestionType.calculate;
    case 'boolean':
      return QuestionType.booleanValue;
    case 'map_location':
      return QuestionType.mapLocation;
    case 'address':
      return QuestionType.address;
    case 'address_lookup':
      return QuestionType.addressLookup;
    case 'otp':
      return QuestionType.otp;
    case 'rich_text':
      return QuestionType.richText;
    case 'markdown_editor':
      return QuestionType.markdownEditor;
    case 'custom_field':
      return QuestionType.customField;
    case 'color_picker':
      return QuestionType.colorPicker;
    case 'range':
      return QuestionType.range;
    case 'date_range':
      return QuestionType.dateRange;
    case 'time_range':
      return QuestionType.timeRange;
    case 'stepper':
      return QuestionType.stepper;
    case 'country_select':
      return QuestionType.countrySelect;
    case 'state_select':
      return QuestionType.stateSelect;
    case 'city_select':
      return QuestionType.citySelect;
    case 'social_media_handle':
      return QuestionType.socialMediaHandle;
    case 'website_url':
      return QuestionType.websiteUrl;
    case 'phone_number':
      return QuestionType.phoneNumber;
    case 'captcha':
      return QuestionType.captcha;
    case 'unit_select':
      return QuestionType.unitSelect;
    case 'price':
      return QuestionType.price;
    case 'age':
      return QuestionType.age;
    case 'toggle':
      return QuestionType.toggle;
    case 'multi_checkbox':
      return QuestionType.multiCheckbox;
    case 'email_list':
      return QuestionType.emailList;
    case 'qr_code_scan':
      return QuestionType.qrCodeScan;
    case 'search':
      return QuestionType.search;
    case 'file':
      return QuestionType.file;
    default:
      throw ArgumentError(
        '`field_type` is not one of the supported values: $raw',
      );
  }
}
