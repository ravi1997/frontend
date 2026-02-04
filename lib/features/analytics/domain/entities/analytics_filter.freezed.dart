// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsFilter {

 String get formId; TimeRange get timeRange; DateTime? get startDate; DateTime? get endDate; String? get status; String? get deviceType;
/// Create a copy of AnalyticsFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsFilterCopyWith<AnalyticsFilter> get copyWith => _$AnalyticsFilterCopyWithImpl<AnalyticsFilter>(this as AnalyticsFilter, _$identity);

  /// Serializes this AnalyticsFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsFilter&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,timeRange,startDate,endDate,status,deviceType);

@override
String toString() {
  return 'AnalyticsFilter(formId: $formId, timeRange: $timeRange, startDate: $startDate, endDate: $endDate, status: $status, deviceType: $deviceType)';
}


}

/// @nodoc
abstract mixin class $AnalyticsFilterCopyWith<$Res>  {
  factory $AnalyticsFilterCopyWith(AnalyticsFilter value, $Res Function(AnalyticsFilter) _then) = _$AnalyticsFilterCopyWithImpl;
@useResult
$Res call({
 String formId, TimeRange timeRange, DateTime? startDate, DateTime? endDate, String? status, String? deviceType
});




}
/// @nodoc
class _$AnalyticsFilterCopyWithImpl<$Res>
    implements $AnalyticsFilterCopyWith<$Res> {
  _$AnalyticsFilterCopyWithImpl(this._self, this._then);

  final AnalyticsFilter _self;
  final $Res Function(AnalyticsFilter) _then;

/// Create a copy of AnalyticsFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? timeRange = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = freezed,Object? deviceType = freezed,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as TimeRange,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsFilter].
extension AnalyticsFilterPatterns on AnalyticsFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsFilter value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  TimeRange timeRange,  DateTime? startDate,  DateTime? endDate,  String? status,  String? deviceType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsFilter() when $default != null:
return $default(_that.formId,_that.timeRange,_that.startDate,_that.endDate,_that.status,_that.deviceType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  TimeRange timeRange,  DateTime? startDate,  DateTime? endDate,  String? status,  String? deviceType)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsFilter():
return $default(_that.formId,_that.timeRange,_that.startDate,_that.endDate,_that.status,_that.deviceType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  TimeRange timeRange,  DateTime? startDate,  DateTime? endDate,  String? status,  String? deviceType)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsFilter() when $default != null:
return $default(_that.formId,_that.timeRange,_that.startDate,_that.endDate,_that.status,_that.deviceType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsFilter implements AnalyticsFilter {
  const _AnalyticsFilter({required this.formId, required this.timeRange, this.startDate, this.endDate, this.status, this.deviceType});
  factory _AnalyticsFilter.fromJson(Map<String, dynamic> json) => _$AnalyticsFilterFromJson(json);

@override final  String formId;
@override final  TimeRange timeRange;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  String? status;
@override final  String? deviceType;

/// Create a copy of AnalyticsFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsFilterCopyWith<_AnalyticsFilter> get copyWith => __$AnalyticsFilterCopyWithImpl<_AnalyticsFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsFilter&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,timeRange,startDate,endDate,status,deviceType);

@override
String toString() {
  return 'AnalyticsFilter(formId: $formId, timeRange: $timeRange, startDate: $startDate, endDate: $endDate, status: $status, deviceType: $deviceType)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsFilterCopyWith<$Res> implements $AnalyticsFilterCopyWith<$Res> {
  factory _$AnalyticsFilterCopyWith(_AnalyticsFilter value, $Res Function(_AnalyticsFilter) _then) = __$AnalyticsFilterCopyWithImpl;
@override @useResult
$Res call({
 String formId, TimeRange timeRange, DateTime? startDate, DateTime? endDate, String? status, String? deviceType
});




}
/// @nodoc
class __$AnalyticsFilterCopyWithImpl<$Res>
    implements _$AnalyticsFilterCopyWith<$Res> {
  __$AnalyticsFilterCopyWithImpl(this._self, this._then);

  final _AnalyticsFilter _self;
  final $Res Function(_AnalyticsFilter) _then;

/// Create a copy of AnalyticsFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? timeRange = null,Object? startDate = freezed,Object? endDate = freezed,Object? status = freezed,Object? deviceType = freezed,}) {
  return _then(_AnalyticsFilter(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as TimeRange,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,deviceType: freezed == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
