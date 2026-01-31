// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_version_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormVersionHistory {

 String get version; DateTime get createdAt; String? get authorId; String? get changeLog;
/// Create a copy of FormVersionHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormVersionHistoryCopyWith<FormVersionHistory> get copyWith => _$FormVersionHistoryCopyWithImpl<FormVersionHistory>(this as FormVersionHistory, _$identity);

  /// Serializes this FormVersionHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormVersionHistory&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.changeLog, changeLog) || other.changeLog == changeLog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,createdAt,authorId,changeLog);

@override
String toString() {
  return 'FormVersionHistory(version: $version, createdAt: $createdAt, authorId: $authorId, changeLog: $changeLog)';
}


}

/// @nodoc
abstract mixin class $FormVersionHistoryCopyWith<$Res>  {
  factory $FormVersionHistoryCopyWith(FormVersionHistory value, $Res Function(FormVersionHistory) _then) = _$FormVersionHistoryCopyWithImpl;
@useResult
$Res call({
 String version, DateTime createdAt, String? authorId, String? changeLog
});




}
/// @nodoc
class _$FormVersionHistoryCopyWithImpl<$Res>
    implements $FormVersionHistoryCopyWith<$Res> {
  _$FormVersionHistoryCopyWithImpl(this._self, this._then);

  final FormVersionHistory _self;
  final $Res Function(FormVersionHistory) _then;

/// Create a copy of FormVersionHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? createdAt = null,Object? authorId = freezed,Object? changeLog = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,changeLog: freezed == changeLog ? _self.changeLog : changeLog // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FormVersionHistory].
extension FormVersionHistoryPatterns on FormVersionHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormVersionHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormVersionHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormVersionHistory value)  $default,){
final _that = this;
switch (_that) {
case _FormVersionHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormVersionHistory value)?  $default,){
final _that = this;
switch (_that) {
case _FormVersionHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  DateTime createdAt,  String? authorId,  String? changeLog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormVersionHistory() when $default != null:
return $default(_that.version,_that.createdAt,_that.authorId,_that.changeLog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  DateTime createdAt,  String? authorId,  String? changeLog)  $default,) {final _that = this;
switch (_that) {
case _FormVersionHistory():
return $default(_that.version,_that.createdAt,_that.authorId,_that.changeLog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  DateTime createdAt,  String? authorId,  String? changeLog)?  $default,) {final _that = this;
switch (_that) {
case _FormVersionHistory() when $default != null:
return $default(_that.version,_that.createdAt,_that.authorId,_that.changeLog);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormVersionHistory implements FormVersionHistory {
  const _FormVersionHistory({required this.version, required this.createdAt, this.authorId, this.changeLog});
  factory _FormVersionHistory.fromJson(Map<String, dynamic> json) => _$FormVersionHistoryFromJson(json);

@override final  String version;
@override final  DateTime createdAt;
@override final  String? authorId;
@override final  String? changeLog;

/// Create a copy of FormVersionHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormVersionHistoryCopyWith<_FormVersionHistory> get copyWith => __$FormVersionHistoryCopyWithImpl<_FormVersionHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormVersionHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormVersionHistory&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.changeLog, changeLog) || other.changeLog == changeLog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,createdAt,authorId,changeLog);

@override
String toString() {
  return 'FormVersionHistory(version: $version, createdAt: $createdAt, authorId: $authorId, changeLog: $changeLog)';
}


}

/// @nodoc
abstract mixin class _$FormVersionHistoryCopyWith<$Res> implements $FormVersionHistoryCopyWith<$Res> {
  factory _$FormVersionHistoryCopyWith(_FormVersionHistory value, $Res Function(_FormVersionHistory) _then) = __$FormVersionHistoryCopyWithImpl;
@override @useResult
$Res call({
 String version, DateTime createdAt, String? authorId, String? changeLog
});




}
/// @nodoc
class __$FormVersionHistoryCopyWithImpl<$Res>
    implements _$FormVersionHistoryCopyWith<$Res> {
  __$FormVersionHistoryCopyWithImpl(this._self, this._then);

  final _FormVersionHistory _self;
  final $Res Function(_FormVersionHistory) _then;

/// Create a copy of FormVersionHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? createdAt = null,Object? authorId = freezed,Object? changeLog = freezed,}) {
  return _then(_FormVersionHistory(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,changeLog: freezed == changeLog ? _self.changeLog : changeLog // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
