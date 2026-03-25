// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalFilter {

 String get id; String get label; String get type;// date_range, category, status
 String? get fieldId; dynamic get value; bool get isActive;
/// Create a copy of GlobalFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalFilterCopyWith<GlobalFilter> get copyWith => _$GlobalFilterCopyWithImpl<GlobalFilter>(this as GlobalFilter, _$identity);

  /// Serializes this GlobalFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalFilter&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,fieldId,const DeepCollectionEquality().hash(value),isActive);

@override
String toString() {
  return 'GlobalFilter(id: $id, label: $label, type: $type, fieldId: $fieldId, value: $value, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $GlobalFilterCopyWith<$Res>  {
  factory $GlobalFilterCopyWith(GlobalFilter value, $Res Function(GlobalFilter) _then) = _$GlobalFilterCopyWithImpl;
@useResult
$Res call({
 String id, String label, String type, String? fieldId, dynamic value, bool isActive
});




}
/// @nodoc
class _$GlobalFilterCopyWithImpl<$Res>
    implements $GlobalFilterCopyWith<$Res> {
  _$GlobalFilterCopyWithImpl(this._self, this._then);

  final GlobalFilter _self;
  final $Res Function(GlobalFilter) _then;

/// Create a copy of GlobalFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? type = null,Object? fieldId = freezed,Object? value = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,fieldId: freezed == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalFilter].
extension GlobalFilterPatterns on GlobalFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalFilter value)  $default,){
final _that = this;
switch (_that) {
case _GlobalFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalFilter value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String type,  String? fieldId,  dynamic value,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalFilter() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.fieldId,_that.value,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String type,  String? fieldId,  dynamic value,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _GlobalFilter():
return $default(_that.id,_that.label,_that.type,_that.fieldId,_that.value,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String type,  String? fieldId,  dynamic value,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _GlobalFilter() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.fieldId,_that.value,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalFilter implements GlobalFilter {
  const _GlobalFilter({required this.id, required this.label, required this.type, this.fieldId, this.value, this.isActive = true});
  factory _GlobalFilter.fromJson(Map<String, dynamic> json) => _$GlobalFilterFromJson(json);

@override final  String id;
@override final  String label;
@override final  String type;
// date_range, category, status
@override final  String? fieldId;
@override final  dynamic value;
@override@JsonKey() final  bool isActive;

/// Create a copy of GlobalFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalFilterCopyWith<_GlobalFilter> get copyWith => __$GlobalFilterCopyWithImpl<_GlobalFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalFilter&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,fieldId,const DeepCollectionEquality().hash(value),isActive);

@override
String toString() {
  return 'GlobalFilter(id: $id, label: $label, type: $type, fieldId: $fieldId, value: $value, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$GlobalFilterCopyWith<$Res> implements $GlobalFilterCopyWith<$Res> {
  factory _$GlobalFilterCopyWith(_GlobalFilter value, $Res Function(_GlobalFilter) _then) = __$GlobalFilterCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String type, String? fieldId, dynamic value, bool isActive
});




}
/// @nodoc
class __$GlobalFilterCopyWithImpl<$Res>
    implements _$GlobalFilterCopyWith<$Res> {
  __$GlobalFilterCopyWithImpl(this._self, this._then);

  final _GlobalFilter _self;
  final $Res Function(_GlobalFilter) _then;

/// Create a copy of GlobalFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? type = null,Object? fieldId = freezed,Object? value = freezed,Object? isActive = null,}) {
  return _then(_GlobalFilter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,fieldId: freezed == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
