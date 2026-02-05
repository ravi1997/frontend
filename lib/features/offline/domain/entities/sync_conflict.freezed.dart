// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_conflict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncConflict {

 String get id; String get localId; String? get remoteId; ConflictType get type; DateTime get localTimestamp; DateTime get remoteTimestamp; Map<String, dynamic> get localData; Map<String, dynamic> get remoteData; String get entityType; String? get entityId; ConflictStatus get status; String? get resolutionNote; int get retryCount;
/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncConflictCopyWith<SyncConflict> get copyWith => _$SyncConflictCopyWithImpl<SyncConflict>(this as SyncConflict, _$identity);

  /// Serializes this SyncConflict to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncConflict&&(identical(other.id, id) || other.id == id)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.type, type) || other.type == type)&&(identical(other.localTimestamp, localTimestamp) || other.localTimestamp == localTimestamp)&&(identical(other.remoteTimestamp, remoteTimestamp) || other.remoteTimestamp == remoteTimestamp)&&const DeepCollectionEquality().equals(other.localData, localData)&&const DeepCollectionEquality().equals(other.remoteData, remoteData)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.resolutionNote, resolutionNote) || other.resolutionNote == resolutionNote)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,localId,remoteId,type,localTimestamp,remoteTimestamp,const DeepCollectionEquality().hash(localData),const DeepCollectionEquality().hash(remoteData),entityType,entityId,status,resolutionNote,retryCount);

@override
String toString() {
  return 'SyncConflict(id: $id, localId: $localId, remoteId: $remoteId, type: $type, localTimestamp: $localTimestamp, remoteTimestamp: $remoteTimestamp, localData: $localData, remoteData: $remoteData, entityType: $entityType, entityId: $entityId, status: $status, resolutionNote: $resolutionNote, retryCount: $retryCount)';
}


}

/// @nodoc
abstract mixin class $SyncConflictCopyWith<$Res>  {
  factory $SyncConflictCopyWith(SyncConflict value, $Res Function(SyncConflict) _then) = _$SyncConflictCopyWithImpl;
@useResult
$Res call({
 String id, String localId, String? remoteId, ConflictType type, DateTime localTimestamp, DateTime remoteTimestamp, Map<String, dynamic> localData, Map<String, dynamic> remoteData, String entityType, String? entityId, ConflictStatus status, String? resolutionNote, int retryCount
});




}
/// @nodoc
class _$SyncConflictCopyWithImpl<$Res>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._self, this._then);

  final SyncConflict _self;
  final $Res Function(SyncConflict) _then;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? localId = null,Object? remoteId = freezed,Object? type = null,Object? localTimestamp = null,Object? remoteTimestamp = null,Object? localData = null,Object? remoteData = null,Object? entityType = null,Object? entityId = freezed,Object? status = null,Object? resolutionNote = freezed,Object? retryCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConflictType,localTimestamp: null == localTimestamp ? _self.localTimestamp : localTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,remoteTimestamp: null == remoteTimestamp ? _self.remoteTimestamp : remoteTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,localData: null == localData ? _self.localData : localData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remoteData: null == remoteData ? _self.remoteData : remoteData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConflictStatus,resolutionNote: freezed == resolutionNote ? _self.resolutionNote : resolutionNote // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncConflict].
extension SyncConflictPatterns on SyncConflict {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncConflict value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncConflict value)  $default,){
final _that = this;
switch (_that) {
case _SyncConflict():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncConflict value)?  $default,){
final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String localId,  String? remoteId,  ConflictType type,  DateTime localTimestamp,  DateTime remoteTimestamp,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  String entityType,  String? entityId,  ConflictStatus status,  String? resolutionNote,  int retryCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
return $default(_that.id,_that.localId,_that.remoteId,_that.type,_that.localTimestamp,_that.remoteTimestamp,_that.localData,_that.remoteData,_that.entityType,_that.entityId,_that.status,_that.resolutionNote,_that.retryCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String localId,  String? remoteId,  ConflictType type,  DateTime localTimestamp,  DateTime remoteTimestamp,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  String entityType,  String? entityId,  ConflictStatus status,  String? resolutionNote,  int retryCount)  $default,) {final _that = this;
switch (_that) {
case _SyncConflict():
return $default(_that.id,_that.localId,_that.remoteId,_that.type,_that.localTimestamp,_that.remoteTimestamp,_that.localData,_that.remoteData,_that.entityType,_that.entityId,_that.status,_that.resolutionNote,_that.retryCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String localId,  String? remoteId,  ConflictType type,  DateTime localTimestamp,  DateTime remoteTimestamp,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  String entityType,  String? entityId,  ConflictStatus status,  String? resolutionNote,  int retryCount)?  $default,) {final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
return $default(_that.id,_that.localId,_that.remoteId,_that.type,_that.localTimestamp,_that.remoteTimestamp,_that.localData,_that.remoteData,_that.entityType,_that.entityId,_that.status,_that.resolutionNote,_that.retryCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncConflict implements SyncConflict {
  const _SyncConflict({required this.id, required this.localId, this.remoteId, required this.type, required this.localTimestamp, required this.remoteTimestamp, required final  Map<String, dynamic> localData, required final  Map<String, dynamic> remoteData, required this.entityType, this.entityId, required this.status, this.resolutionNote, this.retryCount = 0}): _localData = localData,_remoteData = remoteData;
  factory _SyncConflict.fromJson(Map<String, dynamic> json) => _$SyncConflictFromJson(json);

@override final  String id;
@override final  String localId;
@override final  String? remoteId;
@override final  ConflictType type;
@override final  DateTime localTimestamp;
@override final  DateTime remoteTimestamp;
 final  Map<String, dynamic> _localData;
@override Map<String, dynamic> get localData {
  if (_localData is EqualUnmodifiableMapView) return _localData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_localData);
}

 final  Map<String, dynamic> _remoteData;
@override Map<String, dynamic> get remoteData {
  if (_remoteData is EqualUnmodifiableMapView) return _remoteData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_remoteData);
}

@override final  String entityType;
@override final  String? entityId;
@override final  ConflictStatus status;
@override final  String? resolutionNote;
@override@JsonKey() final  int retryCount;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncConflictCopyWith<_SyncConflict> get copyWith => __$SyncConflictCopyWithImpl<_SyncConflict>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncConflictToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncConflict&&(identical(other.id, id) || other.id == id)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.type, type) || other.type == type)&&(identical(other.localTimestamp, localTimestamp) || other.localTimestamp == localTimestamp)&&(identical(other.remoteTimestamp, remoteTimestamp) || other.remoteTimestamp == remoteTimestamp)&&const DeepCollectionEquality().equals(other._localData, _localData)&&const DeepCollectionEquality().equals(other._remoteData, _remoteData)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.status, status) || other.status == status)&&(identical(other.resolutionNote, resolutionNote) || other.resolutionNote == resolutionNote)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,localId,remoteId,type,localTimestamp,remoteTimestamp,const DeepCollectionEquality().hash(_localData),const DeepCollectionEquality().hash(_remoteData),entityType,entityId,status,resolutionNote,retryCount);

@override
String toString() {
  return 'SyncConflict(id: $id, localId: $localId, remoteId: $remoteId, type: $type, localTimestamp: $localTimestamp, remoteTimestamp: $remoteTimestamp, localData: $localData, remoteData: $remoteData, entityType: $entityType, entityId: $entityId, status: $status, resolutionNote: $resolutionNote, retryCount: $retryCount)';
}


}

/// @nodoc
abstract mixin class _$SyncConflictCopyWith<$Res> implements $SyncConflictCopyWith<$Res> {
  factory _$SyncConflictCopyWith(_SyncConflict value, $Res Function(_SyncConflict) _then) = __$SyncConflictCopyWithImpl;
@override @useResult
$Res call({
 String id, String localId, String? remoteId, ConflictType type, DateTime localTimestamp, DateTime remoteTimestamp, Map<String, dynamic> localData, Map<String, dynamic> remoteData, String entityType, String? entityId, ConflictStatus status, String? resolutionNote, int retryCount
});




}
/// @nodoc
class __$SyncConflictCopyWithImpl<$Res>
    implements _$SyncConflictCopyWith<$Res> {
  __$SyncConflictCopyWithImpl(this._self, this._then);

  final _SyncConflict _self;
  final $Res Function(_SyncConflict) _then;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? localId = null,Object? remoteId = freezed,Object? type = null,Object? localTimestamp = null,Object? remoteTimestamp = null,Object? localData = null,Object? remoteData = null,Object? entityType = null,Object? entityId = freezed,Object? status = null,Object? resolutionNote = freezed,Object? retryCount = null,}) {
  return _then(_SyncConflict(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConflictType,localTimestamp: null == localTimestamp ? _self.localTimestamp : localTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,remoteTimestamp: null == remoteTimestamp ? _self.remoteTimestamp : remoteTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,localData: null == localData ? _self._localData : localData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remoteData: null == remoteData ? _self._remoteData : remoteData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConflictStatus,resolutionNote: freezed == resolutionNote ? _self.resolutionNote : resolutionNote // ignore: cast_nullable_to_non_nullable
as String?,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
