// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormResponse {

@JsonKey(name: '_id') String get id;@JsonKey(name: 'form') String get formId;@JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601) DateTime? get submittedAt;@JsonKey(name: 'data') Map<String, dynamic> get answers;@JsonKey(name: 'ai_results') Map<String, dynamic> get aiResults; String get status;
/// Create a copy of FormResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormResponseCopyWith<FormResponse> get copyWith => _$FormResponseCopyWithImpl<FormResponse>(this as FormResponse, _$identity);

  /// Serializes this FormResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&const DeepCollectionEquality().equals(other.answers, answers)&&const DeepCollectionEquality().equals(other.aiResults, aiResults)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,formId,submittedAt,const DeepCollectionEquality().hash(answers),const DeepCollectionEquality().hash(aiResults),status);

@override
String toString() {
  return 'FormResponse(id: $id, formId: $formId, submittedAt: $submittedAt, answers: $answers, aiResults: $aiResults, status: $status)';
}


}

/// @nodoc
abstract mixin class $FormResponseCopyWith<$Res>  {
  factory $FormResponseCopyWith(FormResponse value, $Res Function(FormResponse) _then) = _$FormResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id,@JsonKey(name: 'form') String formId,@JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601) DateTime? submittedAt,@JsonKey(name: 'data') Map<String, dynamic> answers,@JsonKey(name: 'ai_results') Map<String, dynamic> aiResults, String status
});




}
/// @nodoc
class _$FormResponseCopyWithImpl<$Res>
    implements $FormResponseCopyWith<$Res> {
  _$FormResponseCopyWithImpl(this._self, this._then);

  final FormResponse _self;
  final $Res Function(FormResponse) _then;

/// Create a copy of FormResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? formId = null,Object? submittedAt = freezed,Object? answers = null,Object? aiResults = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,aiResults: null == aiResults ? _self.aiResults : aiResults // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FormResponse].
extension FormResponsePatterns on FormResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormResponse value)  $default,){
final _that = this;
switch (_that) {
case _FormResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FormResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'form')  String formId, @JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601)  DateTime? submittedAt, @JsonKey(name: 'data')  Map<String, dynamic> answers, @JsonKey(name: 'ai_results')  Map<String, dynamic> aiResults,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormResponse() when $default != null:
return $default(_that.id,_that.formId,_that.submittedAt,_that.answers,_that.aiResults,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'form')  String formId, @JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601)  DateTime? submittedAt, @JsonKey(name: 'data')  Map<String, dynamic> answers, @JsonKey(name: 'ai_results')  Map<String, dynamic> aiResults,  String status)  $default,) {final _that = this;
switch (_that) {
case _FormResponse():
return $default(_that.id,_that.formId,_that.submittedAt,_that.answers,_that.aiResults,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id, @JsonKey(name: 'form')  String formId, @JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601)  DateTime? submittedAt, @JsonKey(name: 'data')  Map<String, dynamic> answers, @JsonKey(name: 'ai_results')  Map<String, dynamic> aiResults,  String status)?  $default,) {final _that = this;
switch (_that) {
case _FormResponse() when $default != null:
return $default(_that.id,_that.formId,_that.submittedAt,_that.answers,_that.aiResults,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormResponse implements FormResponse {
  const _FormResponse({@JsonKey(name: '_id') required this.id, @JsonKey(name: 'form') required this.formId, @JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601) required this.submittedAt, @JsonKey(name: 'data') required final  Map<String, dynamic> answers, @JsonKey(name: 'ai_results') final  Map<String, dynamic> aiResults = const {}, this.status = 'pending'}): _answers = answers,_aiResults = aiResults;
  factory _FormResponse.fromJson(Map<String, dynamic> json) => _$FormResponseFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override@JsonKey(name: 'form') final  String formId;
@override@JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601) final  DateTime? submittedAt;
 final  Map<String, dynamic> _answers;
@override@JsonKey(name: 'data') Map<String, dynamic> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  Map<String, dynamic> _aiResults;
@override@JsonKey(name: 'ai_results') Map<String, dynamic> get aiResults {
  if (_aiResults is EqualUnmodifiableMapView) return _aiResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_aiResults);
}

@override@JsonKey() final  String status;

/// Create a copy of FormResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormResponseCopyWith<_FormResponse> get copyWith => __$FormResponseCopyWithImpl<_FormResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&const DeepCollectionEquality().equals(other._answers, _answers)&&const DeepCollectionEquality().equals(other._aiResults, _aiResults)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,formId,submittedAt,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_aiResults),status);

@override
String toString() {
  return 'FormResponse(id: $id, formId: $formId, submittedAt: $submittedAt, answers: $answers, aiResults: $aiResults, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FormResponseCopyWith<$Res> implements $FormResponseCopyWith<$Res> {
  factory _$FormResponseCopyWith(_FormResponse value, $Res Function(_FormResponse) _then) = __$FormResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id,@JsonKey(name: 'form') String formId,@JsonKey(name: 'submitted_at', fromJson: DateUtils.parse, toJson: DateUtils.toIso8601) DateTime? submittedAt,@JsonKey(name: 'data') Map<String, dynamic> answers,@JsonKey(name: 'ai_results') Map<String, dynamic> aiResults, String status
});




}
/// @nodoc
class __$FormResponseCopyWithImpl<$Res>
    implements _$FormResponseCopyWith<$Res> {
  __$FormResponseCopyWithImpl(this._self, this._then);

  final _FormResponse _self;
  final $Res Function(_FormResponse) _then;

/// Create a copy of FormResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? formId = null,Object? submittedAt = freezed,Object? answers = null,Object? aiResults = null,Object? status = null,}) {
  return _then(_FormResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,aiResults: null == aiResults ? _self._aiResults : aiResults // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
