// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardData {

 DashboardStats get stats; List<RecentForm> get recentForms; List<ProjectSummary> get projects;
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataCopyWith<DashboardData> get copyWith => _$DashboardDataCopyWithImpl<DashboardData>(this as DashboardData, _$identity);

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardData&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.recentForms, recentForms)&&const DeepCollectionEquality().equals(other.projects, projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(recentForms),const DeepCollectionEquality().hash(projects));

@override
String toString() {
  return 'DashboardData(stats: $stats, recentForms: $recentForms, projects: $projects)';
}


}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res>  {
  factory $DashboardDataCopyWith(DashboardData value, $Res Function(DashboardData) _then) = _$DashboardDataCopyWithImpl;
@useResult
$Res call({
 DashboardStats stats, List<RecentForm> recentForms, List<ProjectSummary> projects
});


$DashboardStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? recentForms = null,Object? projects = null,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as DashboardStats,recentForms: null == recentForms ? _self.recentForms : recentForms // ignore: cast_nullable_to_non_nullable
as List<RecentForm>,projects: null == projects ? _self.projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectSummary>,
  ));
}
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<$Res> get stats {
  
  return $DashboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardData value)  $default,){
final _that = this;
switch (_that) {
case _DashboardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardStats stats,  List<RecentForm> recentForms,  List<ProjectSummary> projects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.stats,_that.recentForms,_that.projects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardStats stats,  List<RecentForm> recentForms,  List<ProjectSummary> projects)  $default,) {final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that.stats,_that.recentForms,_that.projects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardStats stats,  List<RecentForm> recentForms,  List<ProjectSummary> projects)?  $default,) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.stats,_that.recentForms,_that.projects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardData extends DashboardData {
  const _DashboardData({required this.stats, required final  List<RecentForm> recentForms, final  List<ProjectSummary> projects = const <ProjectSummary>[]}): _recentForms = recentForms,_projects = projects,super._();
  factory _DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);

@override final  DashboardStats stats;
 final  List<RecentForm> _recentForms;
@override List<RecentForm> get recentForms {
  if (_recentForms is EqualUnmodifiableListView) return _recentForms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentForms);
}

 final  List<ProjectSummary> _projects;
@override@JsonKey() List<ProjectSummary> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}


/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataCopyWith<_DashboardData> get copyWith => __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardData&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._recentForms, _recentForms)&&const DeepCollectionEquality().equals(other._projects, _projects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(_recentForms),const DeepCollectionEquality().hash(_projects));

@override
String toString() {
  return 'DashboardData(stats: $stats, recentForms: $recentForms, projects: $projects)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res> implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(_DashboardData value, $Res Function(_DashboardData) _then) = __$DashboardDataCopyWithImpl;
@override @useResult
$Res call({
 DashboardStats stats, List<RecentForm> recentForms, List<ProjectSummary> projects
});


@override $DashboardStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? recentForms = null,Object? projects = null,}) {
  return _then(_DashboardData(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as DashboardStats,recentForms: null == recentForms ? _self._recentForms : recentForms // ignore: cast_nullable_to_non_nullable
as List<RecentForm>,projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<ProjectSummary>,
  ));
}

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<$Res> get stats {
  
  return $DashboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
