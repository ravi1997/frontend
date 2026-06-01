// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResponseHistory {

@JsonKey(readValue: _readId) String get id; String get responseId; String get formId; Map<String, dynamic> get dataBefore; Map<String, dynamic> get dataAfter; String get changedBy; DateTime get changedAt; String get changeType; String? get version;
/// Create a copy of ResponseHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseHistoryCopyWith<ResponseHistory> get copyWith => _$ResponseHistoryCopyWithImpl<ResponseHistory>(this as ResponseHistory, _$identity);

  /// Serializes this ResponseHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResponseHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.responseId, responseId) || other.responseId == responseId)&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other.dataBefore, dataBefore)&&const DeepCollectionEquality().equals(other.dataAfter, dataAfter)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,responseId,formId,const DeepCollectionEquality().hash(dataBefore),const DeepCollectionEquality().hash(dataAfter),changedBy,changedAt,changeType,version);

@override
String toString() {
  return 'ResponseHistory(id: $id, responseId: $responseId, formId: $formId, dataBefore: $dataBefore, dataAfter: $dataAfter, changedBy: $changedBy, changedAt: $changedAt, changeType: $changeType, version: $version)';
}


}

/// @nodoc
abstract mixin class $ResponseHistoryCopyWith<$Res>  {
  factory $ResponseHistoryCopyWith(ResponseHistory value, $Res Function(ResponseHistory) _then) = _$ResponseHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readId) String id, String responseId, String formId, Map<String, dynamic> dataBefore, Map<String, dynamic> dataAfter, String changedBy, DateTime changedAt, String changeType, String? version
});




}
/// @nodoc
class _$ResponseHistoryCopyWithImpl<$Res>
    implements $ResponseHistoryCopyWith<$Res> {
  _$ResponseHistoryCopyWithImpl(this._self, this._then);

  final ResponseHistory _self;
  final $Res Function(ResponseHistory) _then;

/// Create a copy of ResponseHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? responseId = null,Object? formId = null,Object? dataBefore = null,Object? dataAfter = null,Object? changedBy = null,Object? changedAt = null,Object? changeType = null,Object? version = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,responseId: null == responseId ? _self.responseId : responseId // ignore: cast_nullable_to_non_nullable
as String,formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,dataBefore: null == dataBefore ? _self.dataBefore : dataBefore // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,dataAfter: null == dataAfter ? _self.dataAfter : dataAfter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,changedBy: null == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResponseHistory].
extension ResponseHistoryPatterns on ResponseHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResponseHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResponseHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResponseHistory value)  $default,){
final _that = this;
switch (_that) {
case _ResponseHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResponseHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ResponseHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  String responseId,  String formId,  Map<String, dynamic> dataBefore,  Map<String, dynamic> dataAfter,  String changedBy,  DateTime changedAt,  String changeType,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResponseHistory() when $default != null:
return $default(_that.id,_that.responseId,_that.formId,_that.dataBefore,_that.dataAfter,_that.changedBy,_that.changedAt,_that.changeType,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  String id,  String responseId,  String formId,  Map<String, dynamic> dataBefore,  Map<String, dynamic> dataAfter,  String changedBy,  DateTime changedAt,  String changeType,  String? version)  $default,) {final _that = this;
switch (_that) {
case _ResponseHistory():
return $default(_that.id,_that.responseId,_that.formId,_that.dataBefore,_that.dataAfter,_that.changedBy,_that.changedAt,_that.changeType,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readId)  String id,  String responseId,  String formId,  Map<String, dynamic> dataBefore,  Map<String, dynamic> dataAfter,  String changedBy,  DateTime changedAt,  String changeType,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _ResponseHistory() when $default != null:
return $default(_that.id,_that.responseId,_that.formId,_that.dataBefore,_that.dataAfter,_that.changedBy,_that.changedAt,_that.changeType,_that.version);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ResponseHistory implements ResponseHistory {
  const _ResponseHistory({@JsonKey(readValue: _readId) required this.id, required this.responseId, required this.formId, required final  Map<String, dynamic> dataBefore, required final  Map<String, dynamic> dataAfter, required this.changedBy, required this.changedAt, required this.changeType, this.version}): _dataBefore = dataBefore,_dataAfter = dataAfter;
  factory _ResponseHistory.fromJson(Map<String, dynamic> json) => _$ResponseHistoryFromJson(json);

@override@JsonKey(readValue: _readId) final  String id;
@override final  String responseId;
@override final  String formId;
 final  Map<String, dynamic> _dataBefore;
@override Map<String, dynamic> get dataBefore {
  if (_dataBefore is EqualUnmodifiableMapView) return _dataBefore;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dataBefore);
}

 final  Map<String, dynamic> _dataAfter;
@override Map<String, dynamic> get dataAfter {
  if (_dataAfter is EqualUnmodifiableMapView) return _dataAfter;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dataAfter);
}

@override final  String changedBy;
@override final  DateTime changedAt;
@override final  String changeType;
@override final  String? version;

/// Create a copy of ResponseHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseHistoryCopyWith<_ResponseHistory> get copyWith => __$ResponseHistoryCopyWithImpl<_ResponseHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResponseHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.responseId, responseId) || other.responseId == responseId)&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other._dataBefore, _dataBefore)&&const DeepCollectionEquality().equals(other._dataAfter, _dataAfter)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,responseId,formId,const DeepCollectionEquality().hash(_dataBefore),const DeepCollectionEquality().hash(_dataAfter),changedBy,changedAt,changeType,version);

@override
String toString() {
  return 'ResponseHistory(id: $id, responseId: $responseId, formId: $formId, dataBefore: $dataBefore, dataAfter: $dataAfter, changedBy: $changedBy, changedAt: $changedAt, changeType: $changeType, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ResponseHistoryCopyWith<$Res> implements $ResponseHistoryCopyWith<$Res> {
  factory _$ResponseHistoryCopyWith(_ResponseHistory value, $Res Function(_ResponseHistory) _then) = __$ResponseHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readId) String id, String responseId, String formId, Map<String, dynamic> dataBefore, Map<String, dynamic> dataAfter, String changedBy, DateTime changedAt, String changeType, String? version
});




}
/// @nodoc
class __$ResponseHistoryCopyWithImpl<$Res>
    implements _$ResponseHistoryCopyWith<$Res> {
  __$ResponseHistoryCopyWithImpl(this._self, this._then);

  final _ResponseHistory _self;
  final $Res Function(_ResponseHistory) _then;

/// Create a copy of ResponseHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? responseId = null,Object? formId = null,Object? dataBefore = null,Object? dataAfter = null,Object? changedBy = null,Object? changedAt = null,Object? changeType = null,Object? version = freezed,}) {
  return _then(_ResponseHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,responseId: null == responseId ? _self.responseId : responseId // ignore: cast_nullable_to_non_nullable
as String,formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,dataBefore: null == dataBefore ? _self._dataBefore : dataBefore // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,dataAfter: null == dataAfter ? _self._dataAfter : dataAfter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,changedBy: null == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
