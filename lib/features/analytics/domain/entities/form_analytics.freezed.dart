// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormAnalytics {

 String get formId; int get totalSubmissions; double get completionRate; List<TimeSeriesData> get trends; Map<String, List<DistributionData>> get fieldDistributions;
/// Create a copy of FormAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormAnalyticsCopyWith<FormAnalytics> get copyWith => _$FormAnalyticsCopyWithImpl<FormAnalytics>(this as FormAnalytics, _$identity);

  /// Serializes this FormAnalytics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormAnalytics&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.totalSubmissions, totalSubmissions) || other.totalSubmissions == totalSubmissions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&const DeepCollectionEquality().equals(other.trends, trends)&&const DeepCollectionEquality().equals(other.fieldDistributions, fieldDistributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,totalSubmissions,completionRate,const DeepCollectionEquality().hash(trends),const DeepCollectionEquality().hash(fieldDistributions));

@override
String toString() {
  return 'FormAnalytics(formId: $formId, totalSubmissions: $totalSubmissions, completionRate: $completionRate, trends: $trends, fieldDistributions: $fieldDistributions)';
}


}

/// @nodoc
abstract mixin class $FormAnalyticsCopyWith<$Res>  {
  factory $FormAnalyticsCopyWith(FormAnalytics value, $Res Function(FormAnalytics) _then) = _$FormAnalyticsCopyWithImpl;
@useResult
$Res call({
 String formId, int totalSubmissions, double completionRate, List<TimeSeriesData> trends, Map<String, List<DistributionData>> fieldDistributions
});




}
/// @nodoc
class _$FormAnalyticsCopyWithImpl<$Res>
    implements $FormAnalyticsCopyWith<$Res> {
  _$FormAnalyticsCopyWithImpl(this._self, this._then);

  final FormAnalytics _self;
  final $Res Function(FormAnalytics) _then;

/// Create a copy of FormAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? totalSubmissions = null,Object? completionRate = null,Object? trends = null,Object? fieldDistributions = null,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,totalSubmissions: null == totalSubmissions ? _self.totalSubmissions : totalSubmissions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,trends: null == trends ? _self.trends : trends // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesData>,fieldDistributions: null == fieldDistributions ? _self.fieldDistributions : fieldDistributions // ignore: cast_nullable_to_non_nullable
as Map<String, List<DistributionData>>,
  ));
}

}


/// Adds pattern-matching-related methods to [FormAnalytics].
extension FormAnalyticsPatterns on FormAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _FormAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _FormAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  int totalSubmissions,  double completionRate,  List<TimeSeriesData> trends,  Map<String, List<DistributionData>> fieldDistributions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormAnalytics() when $default != null:
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.trends,_that.fieldDistributions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  int totalSubmissions,  double completionRate,  List<TimeSeriesData> trends,  Map<String, List<DistributionData>> fieldDistributions)  $default,) {final _that = this;
switch (_that) {
case _FormAnalytics():
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.trends,_that.fieldDistributions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  int totalSubmissions,  double completionRate,  List<TimeSeriesData> trends,  Map<String, List<DistributionData>> fieldDistributions)?  $default,) {final _that = this;
switch (_that) {
case _FormAnalytics() when $default != null:
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.trends,_that.fieldDistributions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormAnalytics implements FormAnalytics {
  const _FormAnalytics({required this.formId, required this.totalSubmissions, required this.completionRate, final  List<TimeSeriesData> trends = const [], final  Map<String, List<DistributionData>> fieldDistributions = const {}}): _trends = trends,_fieldDistributions = fieldDistributions;
  factory _FormAnalytics.fromJson(Map<String, dynamic> json) => _$FormAnalyticsFromJson(json);

@override final  String formId;
@override final  int totalSubmissions;
@override final  double completionRate;
 final  List<TimeSeriesData> _trends;
@override@JsonKey() List<TimeSeriesData> get trends {
  if (_trends is EqualUnmodifiableListView) return _trends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trends);
}

 final  Map<String, List<DistributionData>> _fieldDistributions;
@override@JsonKey() Map<String, List<DistributionData>> get fieldDistributions {
  if (_fieldDistributions is EqualUnmodifiableMapView) return _fieldDistributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldDistributions);
}


/// Create a copy of FormAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormAnalyticsCopyWith<_FormAnalytics> get copyWith => __$FormAnalyticsCopyWithImpl<_FormAnalytics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormAnalyticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormAnalytics&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.totalSubmissions, totalSubmissions) || other.totalSubmissions == totalSubmissions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&const DeepCollectionEquality().equals(other._trends, _trends)&&const DeepCollectionEquality().equals(other._fieldDistributions, _fieldDistributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,totalSubmissions,completionRate,const DeepCollectionEquality().hash(_trends),const DeepCollectionEquality().hash(_fieldDistributions));

@override
String toString() {
  return 'FormAnalytics(formId: $formId, totalSubmissions: $totalSubmissions, completionRate: $completionRate, trends: $trends, fieldDistributions: $fieldDistributions)';
}


}

/// @nodoc
abstract mixin class _$FormAnalyticsCopyWith<$Res> implements $FormAnalyticsCopyWith<$Res> {
  factory _$FormAnalyticsCopyWith(_FormAnalytics value, $Res Function(_FormAnalytics) _then) = __$FormAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 String formId, int totalSubmissions, double completionRate, List<TimeSeriesData> trends, Map<String, List<DistributionData>> fieldDistributions
});




}
/// @nodoc
class __$FormAnalyticsCopyWithImpl<$Res>
    implements _$FormAnalyticsCopyWith<$Res> {
  __$FormAnalyticsCopyWithImpl(this._self, this._then);

  final _FormAnalytics _self;
  final $Res Function(_FormAnalytics) _then;

/// Create a copy of FormAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? totalSubmissions = null,Object? completionRate = null,Object? trends = null,Object? fieldDistributions = null,}) {
  return _then(_FormAnalytics(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,totalSubmissions: null == totalSubmissions ? _self.totalSubmissions : totalSubmissions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,trends: null == trends ? _self._trends : trends // ignore: cast_nullable_to_non_nullable
as List<TimeSeriesData>,fieldDistributions: null == fieldDistributions ? _self._fieldDistributions : fieldDistributions // ignore: cast_nullable_to_non_nullable
as Map<String, List<DistributionData>>,
  ));
}


}


/// @nodoc
mixin _$TimeSeriesData {

 DateTime get date; int get value;
/// Create a copy of TimeSeriesData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesDataCopyWith<TimeSeriesData> get copyWith => _$TimeSeriesDataCopyWithImpl<TimeSeriesData>(this as TimeSeriesData, _$identity);

  /// Serializes this TimeSeriesData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeriesData&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'TimeSeriesData(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class $TimeSeriesDataCopyWith<$Res>  {
  factory $TimeSeriesDataCopyWith(TimeSeriesData value, $Res Function(TimeSeriesData) _then) = _$TimeSeriesDataCopyWithImpl;
@useResult
$Res call({
 DateTime date, int value
});




}
/// @nodoc
class _$TimeSeriesDataCopyWithImpl<$Res>
    implements $TimeSeriesDataCopyWith<$Res> {
  _$TimeSeriesDataCopyWithImpl(this._self, this._then);

  final TimeSeriesData _self;
  final $Res Function(TimeSeriesData) _then;

/// Create a copy of TimeSeriesData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? value = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeriesData].
extension TimeSeriesDataPatterns on TimeSeriesData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeriesData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeriesData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeriesData value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeriesData value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeriesData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeriesData() when $default != null:
return $default(_that.date,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int value)  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesData():
return $default(_that.date,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int value)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeriesData() when $default != null:
return $default(_that.date,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeSeriesData implements TimeSeriesData {
  const _TimeSeriesData({required this.date, required this.value});
  factory _TimeSeriesData.fromJson(Map<String, dynamic> json) => _$TimeSeriesDataFromJson(json);

@override final  DateTime date;
@override final  int value;

/// Create a copy of TimeSeriesData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesDataCopyWith<_TimeSeriesData> get copyWith => __$TimeSeriesDataCopyWithImpl<_TimeSeriesData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeSeriesDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeriesData&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'TimeSeriesData(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesDataCopyWith<$Res> implements $TimeSeriesDataCopyWith<$Res> {
  factory _$TimeSeriesDataCopyWith(_TimeSeriesData value, $Res Function(_TimeSeriesData) _then) = __$TimeSeriesDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int value
});




}
/// @nodoc
class __$TimeSeriesDataCopyWithImpl<$Res>
    implements _$TimeSeriesDataCopyWith<$Res> {
  __$TimeSeriesDataCopyWithImpl(this._self, this._then);

  final _TimeSeriesData _self;
  final $Res Function(_TimeSeriesData) _then;

/// Create a copy of TimeSeriesData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? value = null,}) {
  return _then(_TimeSeriesData(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DistributionData {

 String get label; int get count; double get percentage;
/// Create a copy of DistributionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionDataCopyWith<DistributionData> get copyWith => _$DistributionDataCopyWithImpl<DistributionData>(this as DistributionData, _$identity);

  /// Serializes this DistributionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionData&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count,percentage);

@override
String toString() {
  return 'DistributionData(label: $label, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $DistributionDataCopyWith<$Res>  {
  factory $DistributionDataCopyWith(DistributionData value, $Res Function(DistributionData) _then) = _$DistributionDataCopyWithImpl;
@useResult
$Res call({
 String label, int count, double percentage
});




}
/// @nodoc
class _$DistributionDataCopyWithImpl<$Res>
    implements $DistributionDataCopyWith<$Res> {
  _$DistributionDataCopyWithImpl(this._self, this._then);

  final DistributionData _self;
  final $Res Function(DistributionData) _then;

/// Create a copy of DistributionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? count = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionData].
extension DistributionDataPatterns on DistributionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionData value)  $default,){
final _that = this;
switch (_that) {
case _DistributionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionData value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int count,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionData() when $default != null:
return $default(_that.label,_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int count,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _DistributionData():
return $default(_that.label,_that.count,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int count,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _DistributionData() when $default != null:
return $default(_that.label,_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionData implements DistributionData {
  const _DistributionData({required this.label, required this.count, required this.percentage});
  factory _DistributionData.fromJson(Map<String, dynamic> json) => _$DistributionDataFromJson(json);

@override final  String label;
@override final  int count;
@override final  double percentage;

/// Create a copy of DistributionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionDataCopyWith<_DistributionData> get copyWith => __$DistributionDataCopyWithImpl<_DistributionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionData&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count,percentage);

@override
String toString() {
  return 'DistributionData(label: $label, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$DistributionDataCopyWith<$Res> implements $DistributionDataCopyWith<$Res> {
  factory _$DistributionDataCopyWith(_DistributionData value, $Res Function(_DistributionData) _then) = __$DistributionDataCopyWithImpl;
@override @useResult
$Res call({
 String label, int count, double percentage
});




}
/// @nodoc
class __$DistributionDataCopyWithImpl<$Res>
    implements _$DistributionDataCopyWith<$Res> {
  __$DistributionDataCopyWithImpl(this._self, this._then);

  final _DistributionData _self;
  final $Res Function(_DistributionData) _then;

/// Create a copy of DistributionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? count = null,Object? percentage = null,}) {
  return _then(_DistributionData(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
