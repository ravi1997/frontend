// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsExport {

 String get formId; ExportFormat get format; DateTimeRange get dateRange; bool get includeCharts; bool get includeRawData; bool get includeSummary; List<String>? get selectedFields;
/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsExportCopyWith<AnalyticsExport> get copyWith => _$AnalyticsExportCopyWithImpl<AnalyticsExport>(this as AnalyticsExport, _$identity);

  /// Serializes this AnalyticsExport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsExport&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.format, format) || other.format == format)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.includeCharts, includeCharts) || other.includeCharts == includeCharts)&&(identical(other.includeRawData, includeRawData) || other.includeRawData == includeRawData)&&(identical(other.includeSummary, includeSummary) || other.includeSummary == includeSummary)&&const DeepCollectionEquality().equals(other.selectedFields, selectedFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,format,dateRange,includeCharts,includeRawData,includeSummary,const DeepCollectionEquality().hash(selectedFields));

@override
String toString() {
  return 'AnalyticsExport(formId: $formId, format: $format, dateRange: $dateRange, includeCharts: $includeCharts, includeRawData: $includeRawData, includeSummary: $includeSummary, selectedFields: $selectedFields)';
}


}

/// @nodoc
abstract mixin class $AnalyticsExportCopyWith<$Res>  {
  factory $AnalyticsExportCopyWith(AnalyticsExport value, $Res Function(AnalyticsExport) _then) = _$AnalyticsExportCopyWithImpl;
@useResult
$Res call({
 String formId, ExportFormat format, DateTimeRange dateRange, bool includeCharts, bool includeRawData, bool includeSummary, List<String>? selectedFields
});


$DateTimeRangeCopyWith<$Res> get dateRange;

}
/// @nodoc
class _$AnalyticsExportCopyWithImpl<$Res>
    implements $AnalyticsExportCopyWith<$Res> {
  _$AnalyticsExportCopyWithImpl(this._self, this._then);

  final AnalyticsExport _self;
  final $Res Function(AnalyticsExport) _then;

/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formId = null,Object? format = null,Object? dateRange = null,Object? includeCharts = null,Object? includeRawData = null,Object? includeSummary = null,Object? selectedFields = freezed,}) {
  return _then(_self.copyWith(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange,includeCharts: null == includeCharts ? _self.includeCharts : includeCharts // ignore: cast_nullable_to_non_nullable
as bool,includeRawData: null == includeRawData ? _self.includeRawData : includeRawData // ignore: cast_nullable_to_non_nullable
as bool,includeSummary: null == includeSummary ? _self.includeSummary : includeSummary // ignore: cast_nullable_to_non_nullable
as bool,selectedFields: freezed == selectedFields ? _self.selectedFields : selectedFields // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateTimeRangeCopyWith<$Res> get dateRange {
  
  return $DateTimeRangeCopyWith<$Res>(_self.dateRange, (value) {
    return _then(_self.copyWith(dateRange: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsExport].
extension AnalyticsExportPatterns on AnalyticsExport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsExport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsExport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsExport value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsExport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsExport value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsExport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formId,  ExportFormat format,  DateTimeRange dateRange,  bool includeCharts,  bool includeRawData,  bool includeSummary,  List<String>? selectedFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsExport() when $default != null:
return $default(_that.formId,_that.format,_that.dateRange,_that.includeCharts,_that.includeRawData,_that.includeSummary,_that.selectedFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formId,  ExportFormat format,  DateTimeRange dateRange,  bool includeCharts,  bool includeRawData,  bool includeSummary,  List<String>? selectedFields)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsExport():
return $default(_that.formId,_that.format,_that.dateRange,_that.includeCharts,_that.includeRawData,_that.includeSummary,_that.selectedFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formId,  ExportFormat format,  DateTimeRange dateRange,  bool includeCharts,  bool includeRawData,  bool includeSummary,  List<String>? selectedFields)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsExport() when $default != null:
return $default(_that.formId,_that.format,_that.dateRange,_that.includeCharts,_that.includeRawData,_that.includeSummary,_that.selectedFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsExport implements AnalyticsExport {
  const _AnalyticsExport({required this.formId, required this.format, required this.dateRange, this.includeCharts = false, this.includeRawData = false, this.includeSummary = false, final  List<String>? selectedFields}): _selectedFields = selectedFields;
  factory _AnalyticsExport.fromJson(Map<String, dynamic> json) => _$AnalyticsExportFromJson(json);

@override final  String formId;
@override final  ExportFormat format;
@override final  DateTimeRange dateRange;
@override@JsonKey() final  bool includeCharts;
@override@JsonKey() final  bool includeRawData;
@override@JsonKey() final  bool includeSummary;
 final  List<String>? _selectedFields;
@override List<String>? get selectedFields {
  final value = _selectedFields;
  if (value == null) return null;
  if (_selectedFields is EqualUnmodifiableListView) return _selectedFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsExportCopyWith<_AnalyticsExport> get copyWith => __$AnalyticsExportCopyWithImpl<_AnalyticsExport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsExportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsExport&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.format, format) || other.format == format)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.includeCharts, includeCharts) || other.includeCharts == includeCharts)&&(identical(other.includeRawData, includeRawData) || other.includeRawData == includeRawData)&&(identical(other.includeSummary, includeSummary) || other.includeSummary == includeSummary)&&const DeepCollectionEquality().equals(other._selectedFields, _selectedFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formId,format,dateRange,includeCharts,includeRawData,includeSummary,const DeepCollectionEquality().hash(_selectedFields));

@override
String toString() {
  return 'AnalyticsExport(formId: $formId, format: $format, dateRange: $dateRange, includeCharts: $includeCharts, includeRawData: $includeRawData, includeSummary: $includeSummary, selectedFields: $selectedFields)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsExportCopyWith<$Res> implements $AnalyticsExportCopyWith<$Res> {
  factory _$AnalyticsExportCopyWith(_AnalyticsExport value, $Res Function(_AnalyticsExport) _then) = __$AnalyticsExportCopyWithImpl;
@override @useResult
$Res call({
 String formId, ExportFormat format, DateTimeRange dateRange, bool includeCharts, bool includeRawData, bool includeSummary, List<String>? selectedFields
});


@override $DateTimeRangeCopyWith<$Res> get dateRange;

}
/// @nodoc
class __$AnalyticsExportCopyWithImpl<$Res>
    implements _$AnalyticsExportCopyWith<$Res> {
  __$AnalyticsExportCopyWithImpl(this._self, this._then);

  final _AnalyticsExport _self;
  final $Res Function(_AnalyticsExport) _then;

/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formId = null,Object? format = null,Object? dateRange = null,Object? includeCharts = null,Object? includeRawData = null,Object? includeSummary = null,Object? selectedFields = freezed,}) {
  return _then(_AnalyticsExport(
formId: null == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange,includeCharts: null == includeCharts ? _self.includeCharts : includeCharts // ignore: cast_nullable_to_non_nullable
as bool,includeRawData: null == includeRawData ? _self.includeRawData : includeRawData // ignore: cast_nullable_to_non_nullable
as bool,includeSummary: null == includeSummary ? _self.includeSummary : includeSummary // ignore: cast_nullable_to_non_nullable
as bool,selectedFields: freezed == selectedFields ? _self._selectedFields : selectedFields // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of AnalyticsExport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateTimeRangeCopyWith<$Res> get dateRange {
  
  return $DateTimeRangeCopyWith<$Res>(_self.dateRange, (value) {
    return _then(_self.copyWith(dateRange: value));
  });
}
}


/// @nodoc
mixin _$DateTimeRange {

 DateTime get start; DateTime get end;
/// Create a copy of DateTimeRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateTimeRangeCopyWith<DateTimeRange> get copyWith => _$DateTimeRangeCopyWithImpl<DateTimeRange>(this as DateTimeRange, _$identity);

  /// Serializes this DateTimeRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateTimeRange&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'DateTimeRange(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $DateTimeRangeCopyWith<$Res>  {
  factory $DateTimeRangeCopyWith(DateTimeRange value, $Res Function(DateTimeRange) _then) = _$DateTimeRangeCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$DateTimeRangeCopyWithImpl<$Res>
    implements $DateTimeRangeCopyWith<$Res> {
  _$DateTimeRangeCopyWithImpl(this._self, this._then);

  final DateTimeRange _self;
  final $Res Function(DateTimeRange) _then;

/// Create a copy of DateTimeRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DateTimeRange].
extension DateTimeRangePatterns on DateTimeRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateTimeRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateTimeRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateTimeRange value)  $default,){
final _that = this;
switch (_that) {
case _DateTimeRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateTimeRange value)?  $default,){
final _that = this;
switch (_that) {
case _DateTimeRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateTimeRange() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _DateTimeRange():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _DateTimeRange() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateTimeRange implements DateTimeRange {
  const _DateTimeRange({required this.start, required this.end});
  factory _DateTimeRange.fromJson(Map<String, dynamic> json) => _$DateTimeRangeFromJson(json);

@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of DateTimeRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateTimeRangeCopyWith<_DateTimeRange> get copyWith => __$DateTimeRangeCopyWithImpl<_DateTimeRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateTimeRangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateTimeRange&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'DateTimeRange(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$DateTimeRangeCopyWith<$Res> implements $DateTimeRangeCopyWith<$Res> {
  factory _$DateTimeRangeCopyWith(_DateTimeRange value, $Res Function(_DateTimeRange) _then) = __$DateTimeRangeCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class __$DateTimeRangeCopyWithImpl<$Res>
    implements _$DateTimeRangeCopyWith<$Res> {
  __$DateTimeRangeCopyWithImpl(this._self, this._then);

  final _DateTimeRange _self;
  final $Res Function(_DateTimeRange) _then;

/// Create a copy of DateTimeRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_DateTimeRange(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
