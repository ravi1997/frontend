// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormQuestion {

@JsonKey(readValue: IdReader.readIdCallback) String get id;@JsonKey(name: 'variable_name') String? get variableName; Object? get label;@JsonKey(name: 'field_type') QuestionType get type;@JsonKey(name: 'help_text') Object? get helperText;@JsonKey(includeToJson: false) Object? get placeholder;@JsonKey(name: 'default_value') Object? get defaultValue;@JsonKey(name: 'validation', includeToJson: false) Map<String, dynamic>? get validation;@JsonKey(name: 'is_required', includeToJson: false) bool get isRequired; List<FormQuestionOption>? get options;@JsonKey(name: 'is_read_only') bool get isReadOnly;@JsonKey(name: 'is_hidden') bool get isHidden;@JsonKey(includeToJson: false) String? get validationRegex;@JsonKey(includeToJson: false) int? get minLength;@JsonKey(includeToJson: false) int? get maxLength;@JsonKey(includeToJson: false) num? get minValue;@JsonKey(includeToJson: false) num? get maxValue;@JsonKey(includeToJson: false) String? get inputMask;@JsonKey(includeToJson: false) String? get customErrorMessage;// Advanced Validation
@JsonKey(includeToJson: false) DateTime? get dateMin;@JsonKey(includeToJson: false) DateTime? get dateMax;@JsonKey(includeToJson: false) List<String>? get allowedFileTypes;@JsonKey(includeToJson: false) int? get maxFileSize;// in MB
@JsonKey(includeToJson: false) int? get maxFiles;@JsonKey(includeToJson: false) bool? get isUnique;@JsonKey(includeToJson: false) bool? get requiresConfirmation;// Checkbox / Select Limits
@JsonKey(includeToJson: false) int? get minSelection;@JsonKey(includeToJson: false) int? get maxSelection;// Word Count (Paragraph)
@JsonKey(includeToJson: false) int? get minWordCount;@JsonKey(includeToJson: false) int? get maxWordCount;// Date Constraints
@JsonKey(includeToJson: false) bool? get disablePastDates;@JsonKey(includeToJson: false) bool? get disableFutureDates;@JsonKey(includeToJson: false) bool? get disableWeekends;@JsonKey(name: 'conditional_logic', includeToJson: false) Map<String, dynamic>? get conditionalLogic;@JsonKey(name: 'action_config', includeToJson: false) Map<String, dynamic>? get actionConfig;@JsonKey(name: 'meta_data') Map<String, dynamic>? get metadata;@JsonKey(includeToJson: false) QuestionStyle get style;
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormQuestionCopyWith<FormQuestion> get copyWith => _$FormQuestionCopyWithImpl<FormQuestion>(this as FormQuestion, _$identity);

  /// Serializes this FormQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&const DeepCollectionEquality().equals(other.label, label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.helperText, helperText)&&const DeepCollectionEquality().equals(other.placeholder, placeholder)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&const DeepCollectionEquality().equals(other.validation, validation)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&(identical(other.dateMin, dateMin) || other.dateMin == dateMin)&&(identical(other.dateMax, dateMax) || other.dateMax == dateMax)&&const DeepCollectionEquality().equals(other.allowedFileTypes, allowedFileTypes)&&(identical(other.maxFileSize, maxFileSize) || other.maxFileSize == maxFileSize)&&(identical(other.maxFiles, maxFiles) || other.maxFiles == maxFiles)&&(identical(other.isUnique, isUnique) || other.isUnique == isUnique)&&(identical(other.requiresConfirmation, requiresConfirmation) || other.requiresConfirmation == requiresConfirmation)&&(identical(other.minSelection, minSelection) || other.minSelection == minSelection)&&(identical(other.maxSelection, maxSelection) || other.maxSelection == maxSelection)&&(identical(other.minWordCount, minWordCount) || other.minWordCount == minWordCount)&&(identical(other.maxWordCount, maxWordCount) || other.maxWordCount == maxWordCount)&&(identical(other.disablePastDates, disablePastDates) || other.disablePastDates == disablePastDates)&&(identical(other.disableFutureDates, disableFutureDates) || other.disableFutureDates == disableFutureDates)&&(identical(other.disableWeekends, disableWeekends) || other.disableWeekends == disableWeekends)&&const DeepCollectionEquality().equals(other.conditionalLogic, conditionalLogic)&&const DeepCollectionEquality().equals(other.actionConfig, actionConfig)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,variableName,const DeepCollectionEquality().hash(label),type,const DeepCollectionEquality().hash(helperText),const DeepCollectionEquality().hash(placeholder),const DeepCollectionEquality().hash(defaultValue),const DeepCollectionEquality().hash(validation),isRequired,const DeepCollectionEquality().hash(options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,dateMin,dateMax,const DeepCollectionEquality().hash(allowedFileTypes),maxFileSize,maxFiles,isUnique,requiresConfirmation,minSelection,maxSelection,minWordCount,maxWordCount,disablePastDates,disableFutureDates,disableWeekends,const DeepCollectionEquality().hash(conditionalLogic),const DeepCollectionEquality().hash(actionConfig),const DeepCollectionEquality().hash(metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, variableName: $variableName, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, defaultValue: $defaultValue, validation: $validation, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, dateMin: $dateMin, dateMax: $dateMax, allowedFileTypes: $allowedFileTypes, maxFileSize: $maxFileSize, maxFiles: $maxFiles, isUnique: $isUnique, requiresConfirmation: $requiresConfirmation, minSelection: $minSelection, maxSelection: $maxSelection, minWordCount: $minWordCount, maxWordCount: $maxWordCount, disablePastDates: $disablePastDates, disableFutureDates: $disableFutureDates, disableWeekends: $disableWeekends, conditionalLogic: $conditionalLogic, actionConfig: $actionConfig, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class $FormQuestionCopyWith<$Res>  {
  factory $FormQuestionCopyWith(FormQuestion value, $Res Function(FormQuestion) _then) = _$FormQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: IdReader.readIdCallback) String id,@JsonKey(name: 'variable_name') String? variableName, Object? label,@JsonKey(name: 'field_type') QuestionType type,@JsonKey(name: 'help_text') Object? helperText,@JsonKey(includeToJson: false) Object? placeholder,@JsonKey(name: 'default_value') Object? defaultValue,@JsonKey(name: 'validation', includeToJson: false) Map<String, dynamic>? validation,@JsonKey(name: 'is_required', includeToJson: false) bool isRequired, List<FormQuestionOption>? options,@JsonKey(name: 'is_read_only') bool isReadOnly,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(includeToJson: false) String? validationRegex,@JsonKey(includeToJson: false) int? minLength,@JsonKey(includeToJson: false) int? maxLength,@JsonKey(includeToJson: false) num? minValue,@JsonKey(includeToJson: false) num? maxValue,@JsonKey(includeToJson: false) String? inputMask,@JsonKey(includeToJson: false) String? customErrorMessage,@JsonKey(includeToJson: false) DateTime? dateMin,@JsonKey(includeToJson: false) DateTime? dateMax,@JsonKey(includeToJson: false) List<String>? allowedFileTypes,@JsonKey(includeToJson: false) int? maxFileSize,@JsonKey(includeToJson: false) int? maxFiles,@JsonKey(includeToJson: false) bool? isUnique,@JsonKey(includeToJson: false) bool? requiresConfirmation,@JsonKey(includeToJson: false) int? minSelection,@JsonKey(includeToJson: false) int? maxSelection,@JsonKey(includeToJson: false) int? minWordCount,@JsonKey(includeToJson: false) int? maxWordCount,@JsonKey(includeToJson: false) bool? disablePastDates,@JsonKey(includeToJson: false) bool? disableFutureDates,@JsonKey(includeToJson: false) bool? disableWeekends,@JsonKey(name: 'conditional_logic', includeToJson: false) Map<String, dynamic>? conditionalLogic,@JsonKey(name: 'action_config', includeToJson: false) Map<String, dynamic>? actionConfig,@JsonKey(name: 'meta_data') Map<String, dynamic>? metadata,@JsonKey(includeToJson: false) QuestionStyle style
});


$QuestionStyleCopyWith<$Res> get style;

}
/// @nodoc
class _$FormQuestionCopyWithImpl<$Res>
    implements $FormQuestionCopyWith<$Res> {
  _$FormQuestionCopyWithImpl(this._self, this._then);

  final FormQuestion _self;
  final $Res Function(FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variableName = freezed,Object? label = freezed,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? defaultValue = freezed,Object? validation = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? dateMin = freezed,Object? dateMax = freezed,Object? allowedFileTypes = freezed,Object? maxFileSize = freezed,Object? maxFiles = freezed,Object? isUnique = freezed,Object? requiresConfirmation = freezed,Object? minSelection = freezed,Object? maxSelection = freezed,Object? minWordCount = freezed,Object? maxWordCount = freezed,Object? disablePastDates = freezed,Object? disableFutureDates = freezed,Object? disableWeekends = freezed,Object? conditionalLogic = freezed,Object? actionConfig = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText ,placeholder: freezed == placeholder ? _self.placeholder : placeholder ,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<FormQuestionOption>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,dateMin: freezed == dateMin ? _self.dateMin : dateMin // ignore: cast_nullable_to_non_nullable
as DateTime?,dateMax: freezed == dateMax ? _self.dateMax : dateMax // ignore: cast_nullable_to_non_nullable
as DateTime?,allowedFileTypes: freezed == allowedFileTypes ? _self.allowedFileTypes : allowedFileTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,maxFileSize: freezed == maxFileSize ? _self.maxFileSize : maxFileSize // ignore: cast_nullable_to_non_nullable
as int?,maxFiles: freezed == maxFiles ? _self.maxFiles : maxFiles // ignore: cast_nullable_to_non_nullable
as int?,isUnique: freezed == isUnique ? _self.isUnique : isUnique // ignore: cast_nullable_to_non_nullable
as bool?,requiresConfirmation: freezed == requiresConfirmation ? _self.requiresConfirmation : requiresConfirmation // ignore: cast_nullable_to_non_nullable
as bool?,minSelection: freezed == minSelection ? _self.minSelection : minSelection // ignore: cast_nullable_to_non_nullable
as int?,maxSelection: freezed == maxSelection ? _self.maxSelection : maxSelection // ignore: cast_nullable_to_non_nullable
as int?,minWordCount: freezed == minWordCount ? _self.minWordCount : minWordCount // ignore: cast_nullable_to_non_nullable
as int?,maxWordCount: freezed == maxWordCount ? _self.maxWordCount : maxWordCount // ignore: cast_nullable_to_non_nullable
as int?,disablePastDates: freezed == disablePastDates ? _self.disablePastDates : disablePastDates // ignore: cast_nullable_to_non_nullable
as bool?,disableFutureDates: freezed == disableFutureDates ? _self.disableFutureDates : disableFutureDates // ignore: cast_nullable_to_non_nullable
as bool?,disableWeekends: freezed == disableWeekends ? _self.disableWeekends : disableWeekends // ignore: cast_nullable_to_non_nullable
as bool?,conditionalLogic: freezed == conditionalLogic ? _self.conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionConfig: freezed == actionConfig ? _self.actionConfig : actionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as QuestionStyle,
  ));
}
/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStyleCopyWith<$Res> get style {
  
  return $QuestionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}


/// Adds pattern-matching-related methods to [FormQuestion].
extension FormQuestionPatterns on FormQuestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormQuestion value)  $default,){
final _that = this;
switch (_that) {
case _FormQuestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: IdReader.readIdCallback)  String id, @JsonKey(name: 'variable_name')  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type, @JsonKey(name: 'help_text')  Object? helperText, @JsonKey(includeToJson: false)  Object? placeholder, @JsonKey(name: 'default_value')  Object? defaultValue, @JsonKey(name: 'validation', includeToJson: false)  Map<String, dynamic>? validation, @JsonKey(name: 'is_required', includeToJson: false)  bool isRequired,  List<FormQuestionOption>? options, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(includeToJson: false)  String? validationRegex, @JsonKey(includeToJson: false)  int? minLength, @JsonKey(includeToJson: false)  int? maxLength, @JsonKey(includeToJson: false)  num? minValue, @JsonKey(includeToJson: false)  num? maxValue, @JsonKey(includeToJson: false)  String? inputMask, @JsonKey(includeToJson: false)  String? customErrorMessage, @JsonKey(includeToJson: false)  DateTime? dateMin, @JsonKey(includeToJson: false)  DateTime? dateMax, @JsonKey(includeToJson: false)  List<String>? allowedFileTypes, @JsonKey(includeToJson: false)  int? maxFileSize, @JsonKey(includeToJson: false)  int? maxFiles, @JsonKey(includeToJson: false)  bool? isUnique, @JsonKey(includeToJson: false)  bool? requiresConfirmation, @JsonKey(includeToJson: false)  int? minSelection, @JsonKey(includeToJson: false)  int? maxSelection, @JsonKey(includeToJson: false)  int? minWordCount, @JsonKey(includeToJson: false)  int? maxWordCount, @JsonKey(includeToJson: false)  bool? disablePastDates, @JsonKey(includeToJson: false)  bool? disableFutureDates, @JsonKey(includeToJson: false)  bool? disableWeekends, @JsonKey(name: 'conditional_logic', includeToJson: false)  Map<String, dynamic>? conditionalLogic, @JsonKey(name: 'action_config', includeToJson: false)  Map<String, dynamic>? actionConfig, @JsonKey(name: 'meta_data')  Map<String, dynamic>? metadata, @JsonKey(includeToJson: false)  QuestionStyle style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.validation,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: IdReader.readIdCallback)  String id, @JsonKey(name: 'variable_name')  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type, @JsonKey(name: 'help_text')  Object? helperText, @JsonKey(includeToJson: false)  Object? placeholder, @JsonKey(name: 'default_value')  Object? defaultValue, @JsonKey(name: 'validation', includeToJson: false)  Map<String, dynamic>? validation, @JsonKey(name: 'is_required', includeToJson: false)  bool isRequired,  List<FormQuestionOption>? options, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(includeToJson: false)  String? validationRegex, @JsonKey(includeToJson: false)  int? minLength, @JsonKey(includeToJson: false)  int? maxLength, @JsonKey(includeToJson: false)  num? minValue, @JsonKey(includeToJson: false)  num? maxValue, @JsonKey(includeToJson: false)  String? inputMask, @JsonKey(includeToJson: false)  String? customErrorMessage, @JsonKey(includeToJson: false)  DateTime? dateMin, @JsonKey(includeToJson: false)  DateTime? dateMax, @JsonKey(includeToJson: false)  List<String>? allowedFileTypes, @JsonKey(includeToJson: false)  int? maxFileSize, @JsonKey(includeToJson: false)  int? maxFiles, @JsonKey(includeToJson: false)  bool? isUnique, @JsonKey(includeToJson: false)  bool? requiresConfirmation, @JsonKey(includeToJson: false)  int? minSelection, @JsonKey(includeToJson: false)  int? maxSelection, @JsonKey(includeToJson: false)  int? minWordCount, @JsonKey(includeToJson: false)  int? maxWordCount, @JsonKey(includeToJson: false)  bool? disablePastDates, @JsonKey(includeToJson: false)  bool? disableFutureDates, @JsonKey(includeToJson: false)  bool? disableWeekends, @JsonKey(name: 'conditional_logic', includeToJson: false)  Map<String, dynamic>? conditionalLogic, @JsonKey(name: 'action_config', includeToJson: false)  Map<String, dynamic>? actionConfig, @JsonKey(name: 'meta_data')  Map<String, dynamic>? metadata, @JsonKey(includeToJson: false)  QuestionStyle style)  $default,) {final _that = this;
switch (_that) {
case _FormQuestion():
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.validation,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: IdReader.readIdCallback)  String id, @JsonKey(name: 'variable_name')  String? variableName,  Object? label, @JsonKey(name: 'field_type')  QuestionType type, @JsonKey(name: 'help_text')  Object? helperText, @JsonKey(includeToJson: false)  Object? placeholder, @JsonKey(name: 'default_value')  Object? defaultValue, @JsonKey(name: 'validation', includeToJson: false)  Map<String, dynamic>? validation, @JsonKey(name: 'is_required', includeToJson: false)  bool isRequired,  List<FormQuestionOption>? options, @JsonKey(name: 'is_read_only')  bool isReadOnly, @JsonKey(name: 'is_hidden')  bool isHidden, @JsonKey(includeToJson: false)  String? validationRegex, @JsonKey(includeToJson: false)  int? minLength, @JsonKey(includeToJson: false)  int? maxLength, @JsonKey(includeToJson: false)  num? minValue, @JsonKey(includeToJson: false)  num? maxValue, @JsonKey(includeToJson: false)  String? inputMask, @JsonKey(includeToJson: false)  String? customErrorMessage, @JsonKey(includeToJson: false)  DateTime? dateMin, @JsonKey(includeToJson: false)  DateTime? dateMax, @JsonKey(includeToJson: false)  List<String>? allowedFileTypes, @JsonKey(includeToJson: false)  int? maxFileSize, @JsonKey(includeToJson: false)  int? maxFiles, @JsonKey(includeToJson: false)  bool? isUnique, @JsonKey(includeToJson: false)  bool? requiresConfirmation, @JsonKey(includeToJson: false)  int? minSelection, @JsonKey(includeToJson: false)  int? maxSelection, @JsonKey(includeToJson: false)  int? minWordCount, @JsonKey(includeToJson: false)  int? maxWordCount, @JsonKey(includeToJson: false)  bool? disablePastDates, @JsonKey(includeToJson: false)  bool? disableFutureDates, @JsonKey(includeToJson: false)  bool? disableWeekends, @JsonKey(name: 'conditional_logic', includeToJson: false)  Map<String, dynamic>? conditionalLogic, @JsonKey(name: 'action_config', includeToJson: false)  Map<String, dynamic>? actionConfig, @JsonKey(name: 'meta_data')  Map<String, dynamic>? metadata, @JsonKey(includeToJson: false)  QuestionStyle style)?  $default,) {final _that = this;
switch (_that) {
case _FormQuestion() when $default != null:
return $default(_that.id,_that.variableName,_that.label,_that.type,_that.helperText,_that.placeholder,_that.defaultValue,_that.validation,_that.isRequired,_that.options,_that.isReadOnly,_that.isHidden,_that.validationRegex,_that.minLength,_that.maxLength,_that.minValue,_that.maxValue,_that.inputMask,_that.customErrorMessage,_that.dateMin,_that.dateMax,_that.allowedFileTypes,_that.maxFileSize,_that.maxFiles,_that.isUnique,_that.requiresConfirmation,_that.minSelection,_that.maxSelection,_that.minWordCount,_that.maxWordCount,_that.disablePastDates,_that.disableFutureDates,_that.disableWeekends,_that.conditionalLogic,_that.actionConfig,_that.metadata,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormQuestion extends FormQuestion {
  const _FormQuestion({@JsonKey(readValue: IdReader.readIdCallback) required this.id, @JsonKey(name: 'variable_name') this.variableName, required this.label, @JsonKey(name: 'field_type') required this.type, @JsonKey(name: 'help_text') this.helperText, @JsonKey(includeToJson: false) this.placeholder, @JsonKey(name: 'default_value') this.defaultValue, @JsonKey(name: 'validation', includeToJson: false) final  Map<String, dynamic>? validation, @JsonKey(name: 'is_required', includeToJson: false) this.isRequired = false, final  List<FormQuestionOption>? options, @JsonKey(name: 'is_read_only') this.isReadOnly = false, @JsonKey(name: 'is_hidden') this.isHidden = false, @JsonKey(includeToJson: false) this.validationRegex, @JsonKey(includeToJson: false) this.minLength, @JsonKey(includeToJson: false) this.maxLength, @JsonKey(includeToJson: false) this.minValue, @JsonKey(includeToJson: false) this.maxValue, @JsonKey(includeToJson: false) this.inputMask, @JsonKey(includeToJson: false) this.customErrorMessage, @JsonKey(includeToJson: false) this.dateMin, @JsonKey(includeToJson: false) this.dateMax, @JsonKey(includeToJson: false) final  List<String>? allowedFileTypes, @JsonKey(includeToJson: false) this.maxFileSize, @JsonKey(includeToJson: false) this.maxFiles, @JsonKey(includeToJson: false) this.isUnique, @JsonKey(includeToJson: false) this.requiresConfirmation, @JsonKey(includeToJson: false) this.minSelection, @JsonKey(includeToJson: false) this.maxSelection, @JsonKey(includeToJson: false) this.minWordCount, @JsonKey(includeToJson: false) this.maxWordCount, @JsonKey(includeToJson: false) this.disablePastDates, @JsonKey(includeToJson: false) this.disableFutureDates, @JsonKey(includeToJson: false) this.disableWeekends, @JsonKey(name: 'conditional_logic', includeToJson: false) final  Map<String, dynamic>? conditionalLogic, @JsonKey(name: 'action_config', includeToJson: false) final  Map<String, dynamic>? actionConfig, @JsonKey(name: 'meta_data') final  Map<String, dynamic>? metadata, @JsonKey(includeToJson: false) this.style = const QuestionStyle()}): _validation = validation,_options = options,_allowedFileTypes = allowedFileTypes,_conditionalLogic = conditionalLogic,_actionConfig = actionConfig,_metadata = metadata,super._();
  factory _FormQuestion.fromJson(Map<String, dynamic> json) => _$FormQuestionFromJson(json);

@override@JsonKey(readValue: IdReader.readIdCallback) final  String id;
@override@JsonKey(name: 'variable_name') final  String? variableName;
@override final  Object? label;
@override@JsonKey(name: 'field_type') final  QuestionType type;
@override@JsonKey(name: 'help_text') final  Object? helperText;
@override@JsonKey(includeToJson: false) final  Object? placeholder;
@override@JsonKey(name: 'default_value') final  Object? defaultValue;
 final  Map<String, dynamic>? _validation;
@override@JsonKey(name: 'validation', includeToJson: false) Map<String, dynamic>? get validation {
  final value = _validation;
  if (value == null) return null;
  if (_validation is EqualUnmodifiableMapView) return _validation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'is_required', includeToJson: false) final  bool isRequired;
 final  List<FormQuestionOption>? _options;
@override List<FormQuestionOption>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'is_read_only') final  bool isReadOnly;
@override@JsonKey(name: 'is_hidden') final  bool isHidden;
@override@JsonKey(includeToJson: false) final  String? validationRegex;
@override@JsonKey(includeToJson: false) final  int? minLength;
@override@JsonKey(includeToJson: false) final  int? maxLength;
@override@JsonKey(includeToJson: false) final  num? minValue;
@override@JsonKey(includeToJson: false) final  num? maxValue;
@override@JsonKey(includeToJson: false) final  String? inputMask;
@override@JsonKey(includeToJson: false) final  String? customErrorMessage;
// Advanced Validation
@override@JsonKey(includeToJson: false) final  DateTime? dateMin;
@override@JsonKey(includeToJson: false) final  DateTime? dateMax;
 final  List<String>? _allowedFileTypes;
@override@JsonKey(includeToJson: false) List<String>? get allowedFileTypes {
  final value = _allowedFileTypes;
  if (value == null) return null;
  if (_allowedFileTypes is EqualUnmodifiableListView) return _allowedFileTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(includeToJson: false) final  int? maxFileSize;
// in MB
@override@JsonKey(includeToJson: false) final  int? maxFiles;
@override@JsonKey(includeToJson: false) final  bool? isUnique;
@override@JsonKey(includeToJson: false) final  bool? requiresConfirmation;
// Checkbox / Select Limits
@override@JsonKey(includeToJson: false) final  int? minSelection;
@override@JsonKey(includeToJson: false) final  int? maxSelection;
// Word Count (Paragraph)
@override@JsonKey(includeToJson: false) final  int? minWordCount;
@override@JsonKey(includeToJson: false) final  int? maxWordCount;
// Date Constraints
@override@JsonKey(includeToJson: false) final  bool? disablePastDates;
@override@JsonKey(includeToJson: false) final  bool? disableFutureDates;
@override@JsonKey(includeToJson: false) final  bool? disableWeekends;
 final  Map<String, dynamic>? _conditionalLogic;
@override@JsonKey(name: 'conditional_logic', includeToJson: false) Map<String, dynamic>? get conditionalLogic {
  final value = _conditionalLogic;
  if (value == null) return null;
  if (_conditionalLogic is EqualUnmodifiableMapView) return _conditionalLogic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _actionConfig;
@override@JsonKey(name: 'action_config', includeToJson: false) Map<String, dynamic>? get actionConfig {
  final value = _actionConfig;
  if (value == null) return null;
  if (_actionConfig is EqualUnmodifiableMapView) return _actionConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _metadata;
@override@JsonKey(name: 'meta_data') Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(includeToJson: false) final  QuestionStyle style;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormQuestionCopyWith<_FormQuestion> get copyWith => __$FormQuestionCopyWithImpl<_FormQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.variableName, variableName) || other.variableName == variableName)&&const DeepCollectionEquality().equals(other.label, label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.helperText, helperText)&&const DeepCollectionEquality().equals(other.placeholder, placeholder)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&const DeepCollectionEquality().equals(other._validation, _validation)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.isReadOnly, isReadOnly) || other.isReadOnly == isReadOnly)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.validationRegex, validationRegex) || other.validationRegex == validationRegex)&&(identical(other.minLength, minLength) || other.minLength == minLength)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.inputMask, inputMask) || other.inputMask == inputMask)&&(identical(other.customErrorMessage, customErrorMessage) || other.customErrorMessage == customErrorMessage)&&(identical(other.dateMin, dateMin) || other.dateMin == dateMin)&&(identical(other.dateMax, dateMax) || other.dateMax == dateMax)&&const DeepCollectionEquality().equals(other._allowedFileTypes, _allowedFileTypes)&&(identical(other.maxFileSize, maxFileSize) || other.maxFileSize == maxFileSize)&&(identical(other.maxFiles, maxFiles) || other.maxFiles == maxFiles)&&(identical(other.isUnique, isUnique) || other.isUnique == isUnique)&&(identical(other.requiresConfirmation, requiresConfirmation) || other.requiresConfirmation == requiresConfirmation)&&(identical(other.minSelection, minSelection) || other.minSelection == minSelection)&&(identical(other.maxSelection, maxSelection) || other.maxSelection == maxSelection)&&(identical(other.minWordCount, minWordCount) || other.minWordCount == minWordCount)&&(identical(other.maxWordCount, maxWordCount) || other.maxWordCount == maxWordCount)&&(identical(other.disablePastDates, disablePastDates) || other.disablePastDates == disablePastDates)&&(identical(other.disableFutureDates, disableFutureDates) || other.disableFutureDates == disableFutureDates)&&(identical(other.disableWeekends, disableWeekends) || other.disableWeekends == disableWeekends)&&const DeepCollectionEquality().equals(other._conditionalLogic, _conditionalLogic)&&const DeepCollectionEquality().equals(other._actionConfig, _actionConfig)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,variableName,const DeepCollectionEquality().hash(label),type,const DeepCollectionEquality().hash(helperText),const DeepCollectionEquality().hash(placeholder),const DeepCollectionEquality().hash(defaultValue),const DeepCollectionEquality().hash(_validation),isRequired,const DeepCollectionEquality().hash(_options),isReadOnly,isHidden,validationRegex,minLength,maxLength,minValue,maxValue,inputMask,customErrorMessage,dateMin,dateMax,const DeepCollectionEquality().hash(_allowedFileTypes),maxFileSize,maxFiles,isUnique,requiresConfirmation,minSelection,maxSelection,minWordCount,maxWordCount,disablePastDates,disableFutureDates,disableWeekends,const DeepCollectionEquality().hash(_conditionalLogic),const DeepCollectionEquality().hash(_actionConfig),const DeepCollectionEquality().hash(_metadata),style]);

@override
String toString() {
  return 'FormQuestion(id: $id, variableName: $variableName, label: $label, type: $type, helperText: $helperText, placeholder: $placeholder, defaultValue: $defaultValue, validation: $validation, isRequired: $isRequired, options: $options, isReadOnly: $isReadOnly, isHidden: $isHidden, validationRegex: $validationRegex, minLength: $minLength, maxLength: $maxLength, minValue: $minValue, maxValue: $maxValue, inputMask: $inputMask, customErrorMessage: $customErrorMessage, dateMin: $dateMin, dateMax: $dateMax, allowedFileTypes: $allowedFileTypes, maxFileSize: $maxFileSize, maxFiles: $maxFiles, isUnique: $isUnique, requiresConfirmation: $requiresConfirmation, minSelection: $minSelection, maxSelection: $maxSelection, minWordCount: $minWordCount, maxWordCount: $maxWordCount, disablePastDates: $disablePastDates, disableFutureDates: $disableFutureDates, disableWeekends: $disableWeekends, conditionalLogic: $conditionalLogic, actionConfig: $actionConfig, metadata: $metadata, style: $style)';
}


}

/// @nodoc
abstract mixin class _$FormQuestionCopyWith<$Res> implements $FormQuestionCopyWith<$Res> {
  factory _$FormQuestionCopyWith(_FormQuestion value, $Res Function(_FormQuestion) _then) = __$FormQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: IdReader.readIdCallback) String id,@JsonKey(name: 'variable_name') String? variableName, Object? label,@JsonKey(name: 'field_type') QuestionType type,@JsonKey(name: 'help_text') Object? helperText,@JsonKey(includeToJson: false) Object? placeholder,@JsonKey(name: 'default_value') Object? defaultValue,@JsonKey(name: 'validation', includeToJson: false) Map<String, dynamic>? validation,@JsonKey(name: 'is_required', includeToJson: false) bool isRequired, List<FormQuestionOption>? options,@JsonKey(name: 'is_read_only') bool isReadOnly,@JsonKey(name: 'is_hidden') bool isHidden,@JsonKey(includeToJson: false) String? validationRegex,@JsonKey(includeToJson: false) int? minLength,@JsonKey(includeToJson: false) int? maxLength,@JsonKey(includeToJson: false) num? minValue,@JsonKey(includeToJson: false) num? maxValue,@JsonKey(includeToJson: false) String? inputMask,@JsonKey(includeToJson: false) String? customErrorMessage,@JsonKey(includeToJson: false) DateTime? dateMin,@JsonKey(includeToJson: false) DateTime? dateMax,@JsonKey(includeToJson: false) List<String>? allowedFileTypes,@JsonKey(includeToJson: false) int? maxFileSize,@JsonKey(includeToJson: false) int? maxFiles,@JsonKey(includeToJson: false) bool? isUnique,@JsonKey(includeToJson: false) bool? requiresConfirmation,@JsonKey(includeToJson: false) int? minSelection,@JsonKey(includeToJson: false) int? maxSelection,@JsonKey(includeToJson: false) int? minWordCount,@JsonKey(includeToJson: false) int? maxWordCount,@JsonKey(includeToJson: false) bool? disablePastDates,@JsonKey(includeToJson: false) bool? disableFutureDates,@JsonKey(includeToJson: false) bool? disableWeekends,@JsonKey(name: 'conditional_logic', includeToJson: false) Map<String, dynamic>? conditionalLogic,@JsonKey(name: 'action_config', includeToJson: false) Map<String, dynamic>? actionConfig,@JsonKey(name: 'meta_data') Map<String, dynamic>? metadata,@JsonKey(includeToJson: false) QuestionStyle style
});


@override $QuestionStyleCopyWith<$Res> get style;

}
/// @nodoc
class __$FormQuestionCopyWithImpl<$Res>
    implements _$FormQuestionCopyWith<$Res> {
  __$FormQuestionCopyWithImpl(this._self, this._then);

  final _FormQuestion _self;
  final $Res Function(_FormQuestion) _then;

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variableName = freezed,Object? label = freezed,Object? type = null,Object? helperText = freezed,Object? placeholder = freezed,Object? defaultValue = freezed,Object? validation = freezed,Object? isRequired = null,Object? options = freezed,Object? isReadOnly = null,Object? isHidden = null,Object? validationRegex = freezed,Object? minLength = freezed,Object? maxLength = freezed,Object? minValue = freezed,Object? maxValue = freezed,Object? inputMask = freezed,Object? customErrorMessage = freezed,Object? dateMin = freezed,Object? dateMax = freezed,Object? allowedFileTypes = freezed,Object? maxFileSize = freezed,Object? maxFiles = freezed,Object? isUnique = freezed,Object? requiresConfirmation = freezed,Object? minSelection = freezed,Object? maxSelection = freezed,Object? minWordCount = freezed,Object? maxWordCount = freezed,Object? disablePastDates = freezed,Object? disableFutureDates = freezed,Object? disableWeekends = freezed,Object? conditionalLogic = freezed,Object? actionConfig = freezed,Object? metadata = freezed,Object? style = null,}) {
  return _then(_FormQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variableName: freezed == variableName ? _self.variableName : variableName // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label ,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,helperText: freezed == helperText ? _self.helperText : helperText ,placeholder: freezed == placeholder ? _self.placeholder : placeholder ,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue ,validation: freezed == validation ? _self._validation : validation // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<FormQuestionOption>?,isReadOnly: null == isReadOnly ? _self.isReadOnly : isReadOnly // ignore: cast_nullable_to_non_nullable
as bool,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,validationRegex: freezed == validationRegex ? _self.validationRegex : validationRegex // ignore: cast_nullable_to_non_nullable
as String?,minLength: freezed == minLength ? _self.minLength : minLength // ignore: cast_nullable_to_non_nullable
as int?,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as num?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as num?,inputMask: freezed == inputMask ? _self.inputMask : inputMask // ignore: cast_nullable_to_non_nullable
as String?,customErrorMessage: freezed == customErrorMessage ? _self.customErrorMessage : customErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,dateMin: freezed == dateMin ? _self.dateMin : dateMin // ignore: cast_nullable_to_non_nullable
as DateTime?,dateMax: freezed == dateMax ? _self.dateMax : dateMax // ignore: cast_nullable_to_non_nullable
as DateTime?,allowedFileTypes: freezed == allowedFileTypes ? _self._allowedFileTypes : allowedFileTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,maxFileSize: freezed == maxFileSize ? _self.maxFileSize : maxFileSize // ignore: cast_nullable_to_non_nullable
as int?,maxFiles: freezed == maxFiles ? _self.maxFiles : maxFiles // ignore: cast_nullable_to_non_nullable
as int?,isUnique: freezed == isUnique ? _self.isUnique : isUnique // ignore: cast_nullable_to_non_nullable
as bool?,requiresConfirmation: freezed == requiresConfirmation ? _self.requiresConfirmation : requiresConfirmation // ignore: cast_nullable_to_non_nullable
as bool?,minSelection: freezed == minSelection ? _self.minSelection : minSelection // ignore: cast_nullable_to_non_nullable
as int?,maxSelection: freezed == maxSelection ? _self.maxSelection : maxSelection // ignore: cast_nullable_to_non_nullable
as int?,minWordCount: freezed == minWordCount ? _self.minWordCount : minWordCount // ignore: cast_nullable_to_non_nullable
as int?,maxWordCount: freezed == maxWordCount ? _self.maxWordCount : maxWordCount // ignore: cast_nullable_to_non_nullable
as int?,disablePastDates: freezed == disablePastDates ? _self.disablePastDates : disablePastDates // ignore: cast_nullable_to_non_nullable
as bool?,disableFutureDates: freezed == disableFutureDates ? _self.disableFutureDates : disableFutureDates // ignore: cast_nullable_to_non_nullable
as bool?,disableWeekends: freezed == disableWeekends ? _self.disableWeekends : disableWeekends // ignore: cast_nullable_to_non_nullable
as bool?,conditionalLogic: freezed == conditionalLogic ? _self._conditionalLogic : conditionalLogic // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionConfig: freezed == actionConfig ? _self._actionConfig : actionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as QuestionStyle,
  ));
}

/// Create a copy of FormQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStyleCopyWith<$Res> get style {
  
  return $QuestionStyleCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}

// dart format on
