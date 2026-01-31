// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentForm {

 String get id; String get title; String get status; DateTime get updatedAt; DateTime? get createdAt;
/// Create a copy of RecentForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentFormCopyWith<RecentForm> get copyWith => _$RecentFormCopyWithImpl<RecentForm>(this as RecentForm, _$identity);

  /// Serializes this RecentForm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentForm&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,updatedAt,createdAt);

@override
String toString() {
  return 'RecentForm(id: $id, title: $title, status: $status, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RecentFormCopyWith<$Res>  {
  factory $RecentFormCopyWith(RecentForm value, $Res Function(RecentForm) _then) = _$RecentFormCopyWithImpl;
@useResult
$Res call({
 String id, String title, String status, DateTime updatedAt, DateTime? createdAt
});




}
/// @nodoc
class _$RecentFormCopyWithImpl<$Res>
    implements $RecentFormCopyWith<$Res> {
  _$RecentFormCopyWithImpl(this._self, this._then);

  final RecentForm _self;
  final $Res Function(RecentForm) _then;

/// Create a copy of RecentForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = null,Object? updatedAt = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentForm].
extension RecentFormPatterns on RecentForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentForm value)  $default,){
final _that = this;
switch (_that) {
case _RecentForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentForm value)?  $default,){
final _that = this;
switch (_that) {
case _RecentForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String status,  DateTime updatedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String status,  DateTime updatedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RecentForm():
return $default(_that.id,_that.title,_that.status,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String status,  DateTime updatedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RecentForm() when $default != null:
return $default(_that.id,_that.title,_that.status,_that.updatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentForm extends RecentForm {
  const _RecentForm({required this.id, required this.title, required this.status, required this.updatedAt, this.createdAt}): super._();
  factory _RecentForm.fromJson(Map<String, dynamic> json) => _$RecentFormFromJson(json);

@override final  String id;
@override final  String title;
@override final  String status;
@override final  DateTime updatedAt;
@override final  DateTime? createdAt;

/// Create a copy of RecentForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentFormCopyWith<_RecentForm> get copyWith => __$RecentFormCopyWithImpl<_RecentForm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentFormToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentForm&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status,updatedAt,createdAt);

@override
String toString() {
  return 'RecentForm(id: $id, title: $title, status: $status, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RecentFormCopyWith<$Res> implements $RecentFormCopyWith<$Res> {
  factory _$RecentFormCopyWith(_RecentForm value, $Res Function(_RecentForm) _then) = __$RecentFormCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String status, DateTime updatedAt, DateTime? createdAt
});




}
/// @nodoc
class __$RecentFormCopyWithImpl<$Res>
    implements _$RecentFormCopyWith<$Res> {
  __$RecentFormCopyWithImpl(this._self, this._then);

  final _RecentForm _self;
  final $Res Function(_RecentForm) _then;

/// Create a copy of RecentForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = null,Object? updatedAt = null,Object? createdAt = freezed,}) {
  return _then(_RecentForm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
