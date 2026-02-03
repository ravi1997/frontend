// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsTimeline {

 String get formId; List<TimelineDataPoint> get dataPoints; String? get period; DateTime? get startDate; DateTime? get endDate;
/// Create a copy of AnalyticsTimeline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsTimelineCopyWith<AnalyticsTimeline> get copyWith => _$AnalyticsTimelineCopyWithImpl<AnalyticsTimeline>(this as AnalyticsTimeline, _$identity);

  /// Serializes this AnalyticsTimeline to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsTimeline&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other.dataPoints, dataPoints)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,const DeepCollectionEquality().hash(dataPoints),period,startDate,endDate);

@override
String toString() {
  return 'AnalyticsTimeline(formId: $formId, dataPoints: $dataPoints, period: $period, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $AnalyticsTimelineCopyWith<$Res>  {
  factory $AnalyticsTimelineCopyWith(AnalyticsTimeline value, $Res Function(AnalyticsTimeline) _then) = _$AnalyticsTimelineCopyWithImpl;
@useResult
$Res call({
 String formId, List<TimelineDataPoint> dataPoints, String? period, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class _$AnalyticsTimelineCopyWithImpl<$Res>
    implements $AnalyticsTimelineCopyWith<$Res> {
  _$AnalyticsTimelineCopyWithImpl(this._self, this._then);

  final AnalyticsTimeline _self;
  final $Res Function(AnalyticsTimeline) _then;

/// Create a copy of AnalyticsTimeline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? dataPoints = null,Object? period = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,dataPoints: null == dataPoints ? _self.dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TimelineDataPoint>,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsTimeline].
extension AnalyticsTimelinePatterns on AnalyticsTimeline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsTimeline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsTimeline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsTimeline value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsTimeline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsTimeline value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsTimeline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  List<TimelineDataPoint> dataPoints,  String? period,  DateTime? startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsTimeline() when $default != null:
return $default(_that.formId,_that.dataPoints,_that.period,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  List<TimelineDataPoint> dataPoints,  String? period,  DateTime? startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsTimeline():
return $default(_that.formId,_that.dataPoints,_that.period,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  List<TimelineDataPoint> dataPoints,  String? period,  DateTime? startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsTimeline() when $default != null:
return $default(_that.formId,_that.dataPoints,_that.period,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsTimeline implements AnalyticsTimeline {
  const _AnalyticsTimeline({required this.formId, required final  List<TimelineDataPoint> dataPoints, this.period, this.startDate, this.endDate}): _dataPoints = dataPoints;
  factory _AnalyticsTimeline.fromJson(Map<String, dynamic> json) => _$AnalyticsTimelineFromJson(json);

@override final  String formId;
 final  List<TimelineDataPoint> _dataPoints;
@override List<TimelineDataPoint> get dataPoints {
  if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dataPoints);
}

@override final  String? period;
@override final  DateTime? startDate;
@override final  DateTime? endDate;

/// Create a copy of AnalyticsTimeline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsTimelineCopyWith<_AnalyticsTimeline> get copyWith => __$AnalyticsTimelineCopyWithImpl<_AnalyticsTimeline>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsTimelineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsTimeline&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other._dataPoints, _dataPoints)&&(identical(other.period, period) || other.period == period)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,const DeepCollectionEquality().hash(_dataPoints),period,startDate,endDate);

@override
String toString() {
  return 'AnalyticsTimeline(formId: $formId, dataPoints: $dataPoints, period: $period, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsTimelineCopyWith<$Res> implements $AnalyticsTimelineCopyWith<$Res> {
  factory _$AnalyticsTimelineCopyWith(_AnalyticsTimeline value, $Res Function(_AnalyticsTimeline) _then) = __$AnalyticsTimelineCopyWithImpl;
@override @useResult
$Res call({
 String formId, List<TimelineDataPoint> dataPoints, String? period, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class __$AnalyticsTimelineCopyWithImpl<$Res>
    implements _$AnalyticsTimelineCopyWith<$Res> {
  __$AnalyticsTimelineCopyWithImpl(this._self, this._then);

  final _AnalyticsTimeline _self;
  final $Res Function(_AnalyticsTimeline) _then;

/// Create a copy of AnalyticsTimeline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? dataPoints = null,Object? period = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_AnalyticsTimeline(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,dataPoints: null == dataPoints ? _self._dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TimelineDataPoint>,period: freezed == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TimelineDataPoint {

 DateTime get date; int get count; int? get submissions; int? get completions; double? get rate;
/// Create a copy of TimelineDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineDataPointCopyWith<TimelineDataPoint> get copyWith => _$TimelineDataPointCopyWithImpl<TimelineDataPoint>(this as TimelineDataPoint, _$identity);

  /// Serializes this TimelineDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.submissions, submissions) || other.submissions == submissions)&&(identical(other.completions, completions) || other.completions == completions)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count,submissions,completions,rate);

@override
String toString() {
  return 'TimelineDataPoint(date: $date, count: $count, submissions: $submissions, completions: $completions, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $TimelineDataPointCopyWith<$Res>  {
  factory $TimelineDataPointCopyWith(TimelineDataPoint value, $Res Function(TimelineDataPoint) _then) = _$TimelineDataPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, int count, int? submissions, int? completions, double? rate
});




}
/// @nodoc
class _$TimelineDataPointCopyWithImpl<$Res>
    implements $TimelineDataPointCopyWith<$Res> {
  _$TimelineDataPointCopyWithImpl(this._self, this._then);

  final TimelineDataPoint _self;
  final $Res Function(TimelineDataPoint) _then;

/// Create a copy of TimelineDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,Object? submissions = freezed,Object? completions = freezed,Object? rate = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,submissions: freezed == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as int?,completions: freezed == completions ? _self.completions : completions // ignore: cast_nullable_to_non_nullable
as int?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineDataPoint].
extension TimelineDataPointPatterns on TimelineDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _TimelineDataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int count,  int? submissions,  int? completions,  double? rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineDataPoint() when $default != null:
return $default(_that.date,_that.count,_that.submissions,_that.completions,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int count,  int? submissions,  int? completions,  double? rate)  $default,) {final _that = this;
switch (_that) {
case _TimelineDataPoint():
return $default(_that.date,_that.count,_that.submissions,_that.completions,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int count,  int? submissions,  int? completions,  double? rate)?  $default,) {final _that = this;
switch (_that) {
case _TimelineDataPoint() when $default != null:
return $default(_that.date,_that.count,_that.submissions,_that.completions,_that.rate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelineDataPoint implements TimelineDataPoint {
  const _TimelineDataPoint({required this.date, required this.count, this.submissions, this.completions, this.rate});
  factory _TimelineDataPoint.fromJson(Map<String, dynamic> json) => _$TimelineDataPointFromJson(json);

@override final  DateTime date;
@override final  int count;
@override final  int? submissions;
@override final  int? completions;
@override final  double? rate;

/// Create a copy of TimelineDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineDataPointCopyWith<_TimelineDataPoint> get copyWith => __$TimelineDataPointCopyWithImpl<_TimelineDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.submissions, submissions) || other.submissions == submissions)&&(identical(other.completions, completions) || other.completions == completions)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count,submissions,completions,rate);

@override
String toString() {
  return 'TimelineDataPoint(date: $date, count: $count, submissions: $submissions, completions: $completions, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$TimelineDataPointCopyWith<$Res> implements $TimelineDataPointCopyWith<$Res> {
  factory _$TimelineDataPointCopyWith(_TimelineDataPoint value, $Res Function(_TimelineDataPoint) _then) = __$TimelineDataPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int count, int? submissions, int? completions, double? rate
});




}
/// @nodoc
class __$TimelineDataPointCopyWithImpl<$Res>
    implements _$TimelineDataPointCopyWith<$Res> {
  __$TimelineDataPointCopyWithImpl(this._self, this._then);

  final _TimelineDataPoint _self;
  final $Res Function(_TimelineDataPoint) _then;

/// Create a copy of TimelineDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,Object? submissions = freezed,Object? completions = freezed,Object? rate = freezed,}) {
  return _then(_TimelineDataPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,submissions: freezed == submissions ? _self.submissions : submissions // ignore: cast_nullable_to_non_nullable
as int?,completions: freezed == completions ? _self.completions : completions // ignore: cast_nullable_to_non_nullable
as int?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
