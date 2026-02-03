// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsSummary {

 String get formId; int get totalSubmissions; double get completionRate; int? get uniqueResponders; double? get averageCompletionTime; Map<String, int>? get statusBreakdown;
/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<AnalyticsSummary> get copyWith => _$AnalyticsSummaryCopyWithImpl<AnalyticsSummary>(this as AnalyticsSummary, _$identity);

  /// Serializes this AnalyticsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsSummary&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.totalSubmissions, totalSubmissions) || other.totalSubmissions == totalSubmissions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.uniqueResponders, uniqueResponders) || other.uniqueResponders == uniqueResponders)&&(identical(other.averageCompletionTime, averageCompletionTime) || other.averageCompletionTime == averageCompletionTime)&&const DeepCollectionEquality().equals(other.statusBreakdown, statusBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,totalSubmissions,completionRate,uniqueResponders,averageCompletionTime,const DeepCollectionEquality().hash(statusBreakdown));

@override
String toString() {
  return 'AnalyticsSummary(formId: $formId, totalSubmissions: $totalSubmissions, completionRate: $completionRate, uniqueResponders: $uniqueResponders, averageCompletionTime: $averageCompletionTime, statusBreakdown: $statusBreakdown)';
}


}

/// @nodoc
abstract mixin class $AnalyticsSummaryCopyWith<$Res>  {
  factory $AnalyticsSummaryCopyWith(AnalyticsSummary value, $Res Function(AnalyticsSummary) _then) = _$AnalyticsSummaryCopyWithImpl;
@useResult
$Res call({
 String formId, int totalSubmissions, double completionRate, int? uniqueResponders, double? averageCompletionTime, Map<String, int>? statusBreakdown
});




}
/// @nodoc
class _$AnalyticsSummaryCopyWithImpl<$Res>
    implements $AnalyticsSummaryCopyWith<$Res> {
  _$AnalyticsSummaryCopyWithImpl(this._self, this._then);

  final AnalyticsSummary _self;
  final $Res Function(AnalyticsSummary) _then;

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? totalSubmissions = null,Object? completionRate = null,Object? uniqueResponders = freezed,Object? averageCompletionTime = freezed,Object? statusBreakdown = freezed,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,totalSubmissions: null == totalSubmissions ? _self.totalSubmissions : totalSubmissions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,uniqueResponders: freezed == uniqueResponders ? _self.uniqueResponders : uniqueResponders // ignore: cast_nullable_to_non_nullable
as int?,averageCompletionTime: freezed == averageCompletionTime ? _self.averageCompletionTime : averageCompletionTime // ignore: cast_nullable_to_non_nullable
as double?,statusBreakdown: freezed == statusBreakdown ? _self.statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsSummary].
extension AnalyticsSummaryPatterns on AnalyticsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsSummary value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  int totalSubmissions,  double completionRate,  int? uniqueResponders,  double? averageCompletionTime,  Map<String, int>? statusBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.uniqueResponders,_that.averageCompletionTime,_that.statusBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  int totalSubmissions,  double completionRate,  int? uniqueResponders,  double? averageCompletionTime,  Map<String, int>? statusBreakdown)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummary():
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.uniqueResponders,_that.averageCompletionTime,_that.statusBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  int totalSubmissions,  double completionRate,  int? uniqueResponders,  double? averageCompletionTime,  Map<String, int>? statusBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsSummary() when $default != null:
return $default(_that.formId,_that.totalSubmissions,_that.completionRate,_that.uniqueResponders,_that.averageCompletionTime,_that.statusBreakdown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsSummary implements AnalyticsSummary {
  const _AnalyticsSummary({required this.formId, required this.totalSubmissions, required this.completionRate, this.uniqueResponders, this.averageCompletionTime, final  Map<String, int>? statusBreakdown}): _statusBreakdown = statusBreakdown;
  factory _AnalyticsSummary.fromJson(Map<String, dynamic> json) => _$AnalyticsSummaryFromJson(json);

@override final  String formId;
@override final  int totalSubmissions;
@override final  double completionRate;
@override final  int? uniqueResponders;
@override final  double? averageCompletionTime;
 final  Map<String, int>? _statusBreakdown;
@override Map<String, int>? get statusBreakdown {
  final value = _statusBreakdown;
  if (value == null) return null;
  if (_statusBreakdown is EqualUnmodifiableMapView) return _statusBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsSummaryCopyWith<_AnalyticsSummary> get copyWith => __$AnalyticsSummaryCopyWithImpl<_AnalyticsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSummary&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.totalSubmissions, totalSubmissions) || other.totalSubmissions == totalSubmissions)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.uniqueResponders, uniqueResponders) || other.uniqueResponders == uniqueResponders)&&(identical(other.averageCompletionTime, averageCompletionTime) || other.averageCompletionTime == averageCompletionTime)&&const DeepCollectionEquality().equals(other._statusBreakdown, _statusBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,totalSubmissions,completionRate,uniqueResponders,averageCompletionTime,const DeepCollectionEquality().hash(_statusBreakdown));

@override
String toString() {
  return 'AnalyticsSummary(formId: $formId, totalSubmissions: $totalSubmissions, completionRate: $completionRate, uniqueResponders: $uniqueResponders, averageCompletionTime: $averageCompletionTime, statusBreakdown: $statusBreakdown)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsSummaryCopyWith<$Res> implements $AnalyticsSummaryCopyWith<$Res> {
  factory _$AnalyticsSummaryCopyWith(_AnalyticsSummary value, $Res Function(_AnalyticsSummary) _then) = __$AnalyticsSummaryCopyWithImpl;
@override @useResult
$Res call({
 String formId, int totalSubmissions, double completionRate, int? uniqueResponders, double? averageCompletionTime, Map<String, int>? statusBreakdown
});




}
/// @nodoc
class __$AnalyticsSummaryCopyWithImpl<$Res>
    implements _$AnalyticsSummaryCopyWith<$Res> {
  __$AnalyticsSummaryCopyWithImpl(this._self, this._then);

  final _AnalyticsSummary _self;
  final $Res Function(_AnalyticsSummary) _then;

/// Create a copy of AnalyticsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? totalSubmissions = null,Object? completionRate = null,Object? uniqueResponders = freezed,Object? averageCompletionTime = freezed,Object? statusBreakdown = freezed,}) {
  return _then(_AnalyticsSummary(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,totalSubmissions: null == totalSubmissions ? _self.totalSubmissions : totalSubmissions // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,uniqueResponders: freezed == uniqueResponders ? _self.uniqueResponders : uniqueResponders // ignore: cast_nullable_to_non_nullable
as int?,averageCompletionTime: freezed == averageCompletionTime ? _self.averageCompletionTime : averageCompletionTime // ignore: cast_nullable_to_non_nullable
as double?,statusBreakdown: freezed == statusBreakdown ? _self._statusBreakdown : statusBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>?,
  ));
}


}

// dart format on
