// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_distribution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsDistribution {

 String get formId; List<FieldDistribution> get fieldDistributions;
/// Create a copy of AnalyticsDistribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsDistributionCopyWith<AnalyticsDistribution> get copyWith => _$AnalyticsDistributionCopyWithImpl<AnalyticsDistribution>(this as AnalyticsDistribution, _$identity);

  /// Serializes this AnalyticsDistribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsDistribution&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other.fieldDistributions, fieldDistributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,const DeepCollectionEquality().hash(fieldDistributions));

@override
String toString() {
  return 'AnalyticsDistribution(formId: $formId, fieldDistributions: $fieldDistributions)';
}


}

/// @nodoc
abstract mixin class $AnalyticsDistributionCopyWith<$Res>  {
  factory $AnalyticsDistributionCopyWith(AnalyticsDistribution value, $Res Function(AnalyticsDistribution) _then) = _$AnalyticsDistributionCopyWithImpl;
@useResult
$Res call({
 String formId, List<FieldDistribution> fieldDistributions
});




}
/// @nodoc
class _$AnalyticsDistributionCopyWithImpl<$Res>
    implements $AnalyticsDistributionCopyWith<$Res> {
  _$AnalyticsDistributionCopyWithImpl(this._self, this._then);

  final AnalyticsDistribution _self;
  final $Res Function(AnalyticsDistribution) _then;

/// Create a copy of AnalyticsDistribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? fieldDistributions = null,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,fieldDistributions: null == fieldDistributions ? _self.fieldDistributions : fieldDistributions // ignore: cast_nullable_to_non_nullable
as List<FieldDistribution>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsDistribution].
extension AnalyticsDistributionPatterns on AnalyticsDistribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsDistribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsDistribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsDistribution value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDistribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsDistribution value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDistribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  List<FieldDistribution> fieldDistributions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsDistribution() when $default != null:
return $default(_that.formId,_that.fieldDistributions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  List<FieldDistribution> fieldDistributions)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDistribution():
return $default(_that.formId,_that.fieldDistributions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  List<FieldDistribution> fieldDistributions)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDistribution() when $default != null:
return $default(_that.formId,_that.fieldDistributions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsDistribution implements AnalyticsDistribution {
  const _AnalyticsDistribution({required this.formId, required final  List<FieldDistribution> fieldDistributions}): _fieldDistributions = fieldDistributions;
  factory _AnalyticsDistribution.fromJson(Map<String, dynamic> json) => _$AnalyticsDistributionFromJson(json);

@override final  String formId;
 final  List<FieldDistribution> _fieldDistributions;
@override List<FieldDistribution> get fieldDistributions {
  if (_fieldDistributions is EqualUnmodifiableListView) return _fieldDistributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fieldDistributions);
}


/// Create a copy of AnalyticsDistribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsDistributionCopyWith<_AnalyticsDistribution> get copyWith => __$AnalyticsDistributionCopyWithImpl<_AnalyticsDistribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsDistributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsDistribution&&(identical(other.formId, formId) || other.formId == formId)&&const DeepCollectionEquality().equals(other._fieldDistributions, _fieldDistributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,const DeepCollectionEquality().hash(_fieldDistributions));

@override
String toString() {
  return 'AnalyticsDistribution(formId: $formId, fieldDistributions: $fieldDistributions)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsDistributionCopyWith<$Res> implements $AnalyticsDistributionCopyWith<$Res> {
  factory _$AnalyticsDistributionCopyWith(_AnalyticsDistribution value, $Res Function(_AnalyticsDistribution) _then) = __$AnalyticsDistributionCopyWithImpl;
@override @useResult
$Res call({
 String formId, List<FieldDistribution> fieldDistributions
});




}
/// @nodoc
class __$AnalyticsDistributionCopyWithImpl<$Res>
    implements _$AnalyticsDistributionCopyWith<$Res> {
  __$AnalyticsDistributionCopyWithImpl(this._self, this._then);

  final _AnalyticsDistribution _self;
  final $Res Function(_AnalyticsDistribution) _then;

/// Create a copy of AnalyticsDistribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? fieldDistributions = null,}) {
  return _then(_AnalyticsDistribution(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,fieldDistributions: null == fieldDistributions ? _self._fieldDistributions : fieldDistributions // ignore: cast_nullable_to_non_nullable
as List<FieldDistribution>,
  ));
}


}


/// @nodoc
mixin _$FieldDistribution {

 String get fieldId; String get fieldLabel; List<DistributionOption> get options; int? get totalResponses;
/// Create a copy of FieldDistribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldDistributionCopyWith<FieldDistribution> get copyWith => _$FieldDistributionCopyWithImpl<FieldDistribution>(this as FieldDistribution, _$identity);

  /// Serializes this FieldDistribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldDistribution&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.fieldLabel, fieldLabel) || other.fieldLabel == fieldLabel)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.totalResponses, totalResponses) || other.totalResponses == totalResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,fieldLabel,const DeepCollectionEquality().hash(options),totalResponses);

@override
String toString() {
  return 'FieldDistribution(fieldId: $fieldId, fieldLabel: $fieldLabel, options: $options, totalResponses: $totalResponses)';
}


}

/// @nodoc
abstract mixin class $FieldDistributionCopyWith<$Res>  {
  factory $FieldDistributionCopyWith(FieldDistribution value, $Res Function(FieldDistribution) _then) = _$FieldDistributionCopyWithImpl;
@useResult
$Res call({
 String fieldId, String fieldLabel, List<DistributionOption> options, int? totalResponses
});




}
/// @nodoc
class _$FieldDistributionCopyWithImpl<$Res>
    implements $FieldDistributionCopyWith<$Res> {
  _$FieldDistributionCopyWithImpl(this._self, this._then);

  final FieldDistribution _self;
  final $Res Function(FieldDistribution) _then;

/// Create a copy of FieldDistribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fieldId = null,Object? fieldLabel = null,Object? options = null,Object? totalResponses = freezed,}) {
  return _then(_self.copyWith(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,fieldLabel: null == fieldLabel ? _self.fieldLabel : fieldLabel // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<DistributionOption>,totalResponses: freezed == totalResponses ? _self.totalResponses : totalResponses // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldDistribution].
extension FieldDistributionPatterns on FieldDistribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldDistribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldDistribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldDistribution value)  $default,){
final _that = this;
switch (_that) {
case _FieldDistribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldDistribution value)?  $default,){
final _that = this;
switch (_that) {
case _FieldDistribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fieldId,  String fieldLabel,  List<DistributionOption> options,  int? totalResponses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldDistribution() when $default != null:
return $default(_that.fieldId,_that.fieldLabel,_that.options,_that.totalResponses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fieldId,  String fieldLabel,  List<DistributionOption> options,  int? totalResponses)  $default,) {final _that = this;
switch (_that) {
case _FieldDistribution():
return $default(_that.fieldId,_that.fieldLabel,_that.options,_that.totalResponses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fieldId,  String fieldLabel,  List<DistributionOption> options,  int? totalResponses)?  $default,) {final _that = this;
switch (_that) {
case _FieldDistribution() when $default != null:
return $default(_that.fieldId,_that.fieldLabel,_that.options,_that.totalResponses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldDistribution implements FieldDistribution {
  const _FieldDistribution({required this.fieldId, required this.fieldLabel, required final  List<DistributionOption> options, this.totalResponses}): _options = options;
  factory _FieldDistribution.fromJson(Map<String, dynamic> json) => _$FieldDistributionFromJson(json);

@override final  String fieldId;
@override final  String fieldLabel;
 final  List<DistributionOption> _options;
@override List<DistributionOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int? totalResponses;

/// Create a copy of FieldDistribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldDistributionCopyWith<_FieldDistribution> get copyWith => __$FieldDistributionCopyWithImpl<_FieldDistribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldDistributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldDistribution&&(identical(other.fieldId, fieldId) || other.fieldId == fieldId)&&(identical(other.fieldLabel, fieldLabel) || other.fieldLabel == fieldLabel)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.totalResponses, totalResponses) || other.totalResponses == totalResponses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fieldId,fieldLabel,const DeepCollectionEquality().hash(_options),totalResponses);

@override
String toString() {
  return 'FieldDistribution(fieldId: $fieldId, fieldLabel: $fieldLabel, options: $options, totalResponses: $totalResponses)';
}


}

/// @nodoc
abstract mixin class _$FieldDistributionCopyWith<$Res> implements $FieldDistributionCopyWith<$Res> {
  factory _$FieldDistributionCopyWith(_FieldDistribution value, $Res Function(_FieldDistribution) _then) = __$FieldDistributionCopyWithImpl;
@override @useResult
$Res call({
 String fieldId, String fieldLabel, List<DistributionOption> options, int? totalResponses
});




}
/// @nodoc
class __$FieldDistributionCopyWithImpl<$Res>
    implements _$FieldDistributionCopyWith<$Res> {
  __$FieldDistributionCopyWithImpl(this._self, this._then);

  final _FieldDistribution _self;
  final $Res Function(_FieldDistribution) _then;

/// Create a copy of FieldDistribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fieldId = null,Object? fieldLabel = null,Object? options = null,Object? totalResponses = freezed,}) {
  return _then(_FieldDistribution(
fieldId: null == fieldId ? _self.fieldId : fieldId // ignore: cast_nullable_to_non_nullable
as String,fieldLabel: null == fieldLabel ? _self.fieldLabel : fieldLabel // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<DistributionOption>,totalResponses: freezed == totalResponses ? _self.totalResponses : totalResponses // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DistributionOption {

 String get label; int get count; double get percentage;
/// Create a copy of DistributionOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionOptionCopyWith<DistributionOption> get copyWith => _$DistributionOptionCopyWithImpl<DistributionOption>(this as DistributionOption, _$identity);

  /// Serializes this DistributionOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionOption&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count,percentage);

@override
String toString() {
  return 'DistributionOption(label: $label, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $DistributionOptionCopyWith<$Res>  {
  factory $DistributionOptionCopyWith(DistributionOption value, $Res Function(DistributionOption) _then) = _$DistributionOptionCopyWithImpl;
@useResult
$Res call({
 String label, int count, double percentage
});




}
/// @nodoc
class _$DistributionOptionCopyWithImpl<$Res>
    implements $DistributionOptionCopyWith<$Res> {
  _$DistributionOptionCopyWithImpl(this._self, this._then);

  final DistributionOption _self;
  final $Res Function(DistributionOption) _then;

/// Create a copy of DistributionOption
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


/// Adds pattern-matching-related methods to [DistributionOption].
extension DistributionOptionPatterns on DistributionOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionOption value)  $default,){
final _that = this;
switch (_that) {
case _DistributionOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionOption value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionOption() when $default != null:
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
case _DistributionOption() when $default != null:
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
case _DistributionOption():
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
case _DistributionOption() when $default != null:
return $default(_that.label,_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionOption implements DistributionOption {
  const _DistributionOption({required this.label, required this.count, required this.percentage});
  factory _DistributionOption.fromJson(Map<String, dynamic> json) => _$DistributionOptionFromJson(json);

@override final  String label;
@override final  int count;
@override final  double percentage;

/// Create a copy of DistributionOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionOptionCopyWith<_DistributionOption> get copyWith => __$DistributionOptionCopyWithImpl<_DistributionOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionOption&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,count,percentage);

@override
String toString() {
  return 'DistributionOption(label: $label, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$DistributionOptionCopyWith<$Res> implements $DistributionOptionCopyWith<$Res> {
  factory _$DistributionOptionCopyWith(_DistributionOption value, $Res Function(_DistributionOption) _then) = __$DistributionOptionCopyWithImpl;
@override @useResult
$Res call({
 String label, int count, double percentage
});




}
/// @nodoc
class __$DistributionOptionCopyWithImpl<$Res>
    implements _$DistributionOptionCopyWith<$Res> {
  __$DistributionOptionCopyWithImpl(this._self, this._then);

  final _DistributionOption _self;
  final $Res Function(_DistributionOption) _then;

/// Create a copy of DistributionOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? count = null,Object? percentage = null,}) {
  return _then(_DistributionOption(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
