// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comparative_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PercentageChange {

 double get value; bool get isPositive; String? get label;
/// Create a copy of PercentageChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<PercentageChange> get copyWith => _$PercentageChangeCopyWithImpl<PercentageChange>(this as PercentageChange, _$identity);

  /// Serializes this PercentageChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PercentageChange&&(identical(other.value, value) || other.value == value)&&(identical(other.isPositive, isPositive) || other.isPositive == isPositive)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,isPositive,label);

@override
String toString() {
  return 'PercentageChange(value: $value, isPositive: $isPositive, label: $label)';
}


}

/// @nodoc
abstract mixin class $PercentageChangeCopyWith<$Res>  {
  factory $PercentageChangeCopyWith(PercentageChange value, $Res Function(PercentageChange) _then) = _$PercentageChangeCopyWithImpl;
@useResult
$Res call({
 double value, bool isPositive, String? label
});




}
/// @nodoc
class _$PercentageChangeCopyWithImpl<$Res>
    implements $PercentageChangeCopyWith<$Res> {
  _$PercentageChangeCopyWithImpl(this._self, this._then);

  final PercentageChange _self;
  final $Res Function(PercentageChange) _then;

/// Create a copy of PercentageChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? isPositive = null,Object? label = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,isPositive: null == isPositive ? _self.isPositive : isPositive // ignore: cast_nullable_to_non_nullable
as bool,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PercentageChange].
extension PercentageChangePatterns on PercentageChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PercentageChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PercentageChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PercentageChange value)  $default,){
final _that = this;
switch (_that) {
case _PercentageChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PercentageChange value)?  $default,){
final _that = this;
switch (_that) {
case _PercentageChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  bool isPositive,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PercentageChange() when $default != null:
return $default(_that.value,_that.isPositive,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  bool isPositive,  String? label)  $default,) {final _that = this;
switch (_that) {
case _PercentageChange():
return $default(_that.value,_that.isPositive,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  bool isPositive,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _PercentageChange() when $default != null:
return $default(_that.value,_that.isPositive,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PercentageChange implements PercentageChange {
  const _PercentageChange({required this.value, required this.isPositive, this.label});
  factory _PercentageChange.fromJson(Map<String, dynamic> json) => _$PercentageChangeFromJson(json);

@override final  double value;
@override final  bool isPositive;
@override final  String? label;

/// Create a copy of PercentageChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PercentageChangeCopyWith<_PercentageChange> get copyWith => __$PercentageChangeCopyWithImpl<_PercentageChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PercentageChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PercentageChange&&(identical(other.value, value) || other.value == value)&&(identical(other.isPositive, isPositive) || other.isPositive == isPositive)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,isPositive,label);

@override
String toString() {
  return 'PercentageChange(value: $value, isPositive: $isPositive, label: $label)';
}


}

/// @nodoc
abstract mixin class _$PercentageChangeCopyWith<$Res> implements $PercentageChangeCopyWith<$Res> {
  factory _$PercentageChangeCopyWith(_PercentageChange value, $Res Function(_PercentageChange) _then) = __$PercentageChangeCopyWithImpl;
@override @useResult
$Res call({
 double value, bool isPositive, String? label
});




}
/// @nodoc
class __$PercentageChangeCopyWithImpl<$Res>
    implements _$PercentageChangeCopyWith<$Res> {
  __$PercentageChangeCopyWithImpl(this._self, this._then);

  final _PercentageChange _self;
  final $Res Function(_PercentageChange) _then;

/// Create a copy of PercentageChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? isPositive = null,Object? label = freezed,}) {
  return _then(_PercentageChange(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,isPositive: null == isPositive ? _self.isPositive : isPositive // ignore: cast_nullable_to_non_nullable
as bool,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ComparativeAnalytics {

 String get formId; AnalyticsSummary get currentPeriod; AnalyticsSummary get previousPeriod; PercentageChange get submissionsChange; PercentageChange get completionRateChange; PercentageChange get avgTimeChange; PercentageChange get uniqueRespondersChange;
/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComparativeAnalyticsCopyWith<ComparativeAnalytics> get copyWith => _$ComparativeAnalyticsCopyWithImpl<ComparativeAnalytics>(this as ComparativeAnalytics, _$identity);

  /// Serializes this ComparativeAnalytics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComparativeAnalytics&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&(identical(other.previousPeriod, previousPeriod) || other.previousPeriod == previousPeriod)&&(identical(other.submissionsChange, submissionsChange) || other.submissionsChange == submissionsChange)&&(identical(other.completionRateChange, completionRateChange) || other.completionRateChange == completionRateChange)&&(identical(other.avgTimeChange, avgTimeChange) || other.avgTimeChange == avgTimeChange)&&(identical(other.uniqueRespondersChange, uniqueRespondersChange) || other.uniqueRespondersChange == uniqueRespondersChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,currentPeriod,previousPeriod,submissionsChange,completionRateChange,avgTimeChange,uniqueRespondersChange);

@override
String toString() {
  return 'ComparativeAnalytics(formId: $formId, currentPeriod: $currentPeriod, previousPeriod: $previousPeriod, submissionsChange: $submissionsChange, completionRateChange: $completionRateChange, avgTimeChange: $avgTimeChange, uniqueRespondersChange: $uniqueRespondersChange)';
}


}

/// @nodoc
abstract mixin class $ComparativeAnalyticsCopyWith<$Res>  {
  factory $ComparativeAnalyticsCopyWith(ComparativeAnalytics value, $Res Function(ComparativeAnalytics) _then) = _$ComparativeAnalyticsCopyWithImpl;
@useResult
$Res call({
 String formId, AnalyticsSummary currentPeriod, AnalyticsSummary previousPeriod, PercentageChange submissionsChange, PercentageChange completionRateChange, PercentageChange avgTimeChange, PercentageChange uniqueRespondersChange
});


$AnalyticsSummaryCopyWith<$Res> get currentPeriod;$AnalyticsSummaryCopyWith<$Res> get previousPeriod;$PercentageChangeCopyWith<$Res> get submissionsChange;$PercentageChangeCopyWith<$Res> get completionRateChange;$PercentageChangeCopyWith<$Res> get avgTimeChange;$PercentageChangeCopyWith<$Res> get uniqueRespondersChange;

}
/// @nodoc
class _$ComparativeAnalyticsCopyWithImpl<$Res>
    implements $ComparativeAnalyticsCopyWith<$Res> {
  _$ComparativeAnalyticsCopyWithImpl(this._self, this._then);

  final ComparativeAnalytics _self;
  final $Res Function(ComparativeAnalytics) _then;

/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? currentPeriod = null,Object? previousPeriod = null,Object? submissionsChange = null,Object? completionRateChange = null,Object? avgTimeChange = null,Object? uniqueRespondersChange = null,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,currentPeriod: null == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as AnalyticsSummary,previousPeriod: null == previousPeriod ? _self.previousPeriod : previousPeriod // ignore: cast_nullable_to_non_nullable
as AnalyticsSummary,submissionsChange: null == submissionsChange ? _self.submissionsChange : submissionsChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,completionRateChange: null == completionRateChange ? _self.completionRateChange : completionRateChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,avgTimeChange: null == avgTimeChange ? _self.avgTimeChange : avgTimeChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,uniqueRespondersChange: null == uniqueRespondersChange ? _self.uniqueRespondersChange : uniqueRespondersChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,
  ));
}
/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<$Res> get currentPeriod {
  
  return $AnalyticsSummaryCopyWith<$Res>(_self.currentPeriod, (value) {
    return _then(_self.copyWith(currentPeriod: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<$Res> get previousPeriod {
  
  return $AnalyticsSummaryCopyWith<$Res>(_self.previousPeriod, (value) {
    return _then(_self.copyWith(previousPeriod: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get submissionsChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.submissionsChange, (value) {
    return _then(_self.copyWith(submissionsChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get completionRateChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.completionRateChange, (value) {
    return _then(_self.copyWith(completionRateChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get avgTimeChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.avgTimeChange, (value) {
    return _then(_self.copyWith(avgTimeChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get uniqueRespondersChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.uniqueRespondersChange, (value) {
    return _then(_self.copyWith(uniqueRespondersChange: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComparativeAnalytics].
extension ComparativeAnalyticsPatterns on ComparativeAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComparativeAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComparativeAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComparativeAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _ComparativeAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComparativeAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _ComparativeAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  AnalyticsSummary currentPeriod,  AnalyticsSummary previousPeriod,  PercentageChange submissionsChange,  PercentageChange completionRateChange,  PercentageChange avgTimeChange,  PercentageChange uniqueRespondersChange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComparativeAnalytics() when $default != null:
return $default(_that.formId,_that.currentPeriod,_that.previousPeriod,_that.submissionsChange,_that.completionRateChange,_that.avgTimeChange,_that.uniqueRespondersChange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  AnalyticsSummary currentPeriod,  AnalyticsSummary previousPeriod,  PercentageChange submissionsChange,  PercentageChange completionRateChange,  PercentageChange avgTimeChange,  PercentageChange uniqueRespondersChange)  $default,) {final _that = this;
switch (_that) {
case _ComparativeAnalytics():
return $default(_that.formId,_that.currentPeriod,_that.previousPeriod,_that.submissionsChange,_that.completionRateChange,_that.avgTimeChange,_that.uniqueRespondersChange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  AnalyticsSummary currentPeriod,  AnalyticsSummary previousPeriod,  PercentageChange submissionsChange,  PercentageChange completionRateChange,  PercentageChange avgTimeChange,  PercentageChange uniqueRespondersChange)?  $default,) {final _that = this;
switch (_that) {
case _ComparativeAnalytics() when $default != null:
return $default(_that.formId,_that.currentPeriod,_that.previousPeriod,_that.submissionsChange,_that.completionRateChange,_that.avgTimeChange,_that.uniqueRespondersChange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ComparativeAnalytics implements ComparativeAnalytics {
  const _ComparativeAnalytics({required this.formId, required this.currentPeriod, required this.previousPeriod, required this.submissionsChange, required this.completionRateChange, required this.avgTimeChange, required this.uniqueRespondersChange});
  factory _ComparativeAnalytics.fromJson(Map<String, dynamic> json) => _$ComparativeAnalyticsFromJson(json);

@override final  String formId;
@override final  AnalyticsSummary currentPeriod;
@override final  AnalyticsSummary previousPeriod;
@override final  PercentageChange submissionsChange;
@override final  PercentageChange completionRateChange;
@override final  PercentageChange avgTimeChange;
@override final  PercentageChange uniqueRespondersChange;

/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComparativeAnalyticsCopyWith<_ComparativeAnalytics> get copyWith => __$ComparativeAnalyticsCopyWithImpl<_ComparativeAnalytics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComparativeAnalyticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComparativeAnalytics&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&(identical(other.previousPeriod, previousPeriod) || other.previousPeriod == previousPeriod)&&(identical(other.submissionsChange, submissionsChange) || other.submissionsChange == submissionsChange)&&(identical(other.completionRateChange, completionRateChange) || other.completionRateChange == completionRateChange)&&(identical(other.avgTimeChange, avgTimeChange) || other.avgTimeChange == avgTimeChange)&&(identical(other.uniqueRespondersChange, uniqueRespondersChange) || other.uniqueRespondersChange == uniqueRespondersChange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,currentPeriod,previousPeriod,submissionsChange,completionRateChange,avgTimeChange,uniqueRespondersChange);

@override
String toString() {
  return 'ComparativeAnalytics(formId: $formId, currentPeriod: $currentPeriod, previousPeriod: $previousPeriod, submissionsChange: $submissionsChange, completionRateChange: $completionRateChange, avgTimeChange: $avgTimeChange, uniqueRespondersChange: $uniqueRespondersChange)';
}


}

/// @nodoc
abstract mixin class _$ComparativeAnalyticsCopyWith<$Res> implements $ComparativeAnalyticsCopyWith<$Res> {
  factory _$ComparativeAnalyticsCopyWith(_ComparativeAnalytics value, $Res Function(_ComparativeAnalytics) _then) = __$ComparativeAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 String formId, AnalyticsSummary currentPeriod, AnalyticsSummary previousPeriod, PercentageChange submissionsChange, PercentageChange completionRateChange, PercentageChange avgTimeChange, PercentageChange uniqueRespondersChange
});


@override $AnalyticsSummaryCopyWith<$Res> get currentPeriod;@override $AnalyticsSummaryCopyWith<$Res> get previousPeriod;@override $PercentageChangeCopyWith<$Res> get submissionsChange;@override $PercentageChangeCopyWith<$Res> get completionRateChange;@override $PercentageChangeCopyWith<$Res> get avgTimeChange;@override $PercentageChangeCopyWith<$Res> get uniqueRespondersChange;

}
/// @nodoc
class __$ComparativeAnalyticsCopyWithImpl<$Res>
    implements _$ComparativeAnalyticsCopyWith<$Res> {
  __$ComparativeAnalyticsCopyWithImpl(this._self, this._then);

  final _ComparativeAnalytics _self;
  final $Res Function(_ComparativeAnalytics) _then;

/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? currentPeriod = null,Object? previousPeriod = null,Object? submissionsChange = null,Object? completionRateChange = null,Object? avgTimeChange = null,Object? uniqueRespondersChange = null,}) {
  return _then(_ComparativeAnalytics(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,currentPeriod: null == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as AnalyticsSummary,previousPeriod: null == previousPeriod ? _self.previousPeriod : previousPeriod // ignore: cast_nullable_to_non_nullable
as AnalyticsSummary,submissionsChange: null == submissionsChange ? _self.submissionsChange : submissionsChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,completionRateChange: null == completionRateChange ? _self.completionRateChange : completionRateChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,avgTimeChange: null == avgTimeChange ? _self.avgTimeChange : avgTimeChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,uniqueRespondersChange: null == uniqueRespondersChange ? _self.uniqueRespondersChange : uniqueRespondersChange // ignore: cast_nullable_to_non_nullable
as PercentageChange,
  ));
}

/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<$Res> get currentPeriod {
  
  return $AnalyticsSummaryCopyWith<$Res>(_self.currentPeriod, (value) {
    return _then(_self.copyWith(currentPeriod: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsSummaryCopyWith<$Res> get previousPeriod {
  
  return $AnalyticsSummaryCopyWith<$Res>(_self.previousPeriod, (value) {
    return _then(_self.copyWith(previousPeriod: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get submissionsChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.submissionsChange, (value) {
    return _then(_self.copyWith(submissionsChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get completionRateChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.completionRateChange, (value) {
    return _then(_self.copyWith(completionRateChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get avgTimeChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.avgTimeChange, (value) {
    return _then(_self.copyWith(avgTimeChange: value));
  });
}/// Create a copy of ComparativeAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageChangeCopyWith<$Res> get uniqueRespondersChange {
  
  return $PercentageChangeCopyWith<$Res>(_self.uniqueRespondersChange, (value) {
    return _then(_self.copyWith(uniqueRespondersChange: value));
  });
}
}

// dart format on
