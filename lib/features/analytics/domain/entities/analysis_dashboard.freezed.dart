// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalysisDashboard {

 String get id; String get title; String? get slug; String? get description; List<String> get roles; String get layout; List<AnalysisWidget> get widgets; List<GlobalFilter> get globalFilters; String? get createdBy; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of AnalysisDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisDashboardCopyWith<AnalysisDashboard> get copyWith => _$AnalysisDashboardCopyWithImpl<AnalysisDashboard>(this as AnalysisDashboard, _$identity);

  /// Serializes this AnalysisDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisDashboard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.layout, layout) || other.layout == layout)&&const DeepCollectionEquality().equals(other.widgets, widgets)&&const DeepCollectionEquality().equals(other.globalFilters, globalFilters)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,description,const DeepCollectionEquality().hash(roles),layout,const DeepCollectionEquality().hash(widgets),const DeepCollectionEquality().hash(globalFilters),createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'AnalysisDashboard(id: $id, title: $title, slug: $slug, description: $description, roles: $roles, layout: $layout, widgets: $widgets, globalFilters: $globalFilters, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AnalysisDashboardCopyWith<$Res>  {
  factory $AnalysisDashboardCopyWith(AnalysisDashboard value, $Res Function(AnalysisDashboard) _then) = _$AnalysisDashboardCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? slug, String? description, List<String> roles, String layout, List<AnalysisWidget> widgets, List<GlobalFilter> globalFilters, String? createdBy, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AnalysisDashboardCopyWithImpl<$Res>
    implements $AnalysisDashboardCopyWith<$Res> {
  _$AnalysisDashboardCopyWithImpl(this._self, this._then);

  final AnalysisDashboard _self;
  final $Res Function(AnalysisDashboard) _then;

/// Create a copy of AnalysisDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? description = freezed,Object? roles = null,Object? layout = null,Object? widgets = null,Object? globalFilters = null,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self.widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<AnalysisWidget>,globalFilters: null == globalFilters ? _self.globalFilters : globalFilters // ignore: cast_nullable_to_non_nullable
as List<GlobalFilter>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisDashboard].
extension AnalysisDashboardPatterns on AnalysisDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisDashboard value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? slug,  String? description,  List<String> roles,  String layout,  List<AnalysisWidget> widgets,  List<GlobalFilter> globalFilters,  String? createdBy,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisDashboard() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.description,_that.roles,_that.layout,_that.widgets,_that.globalFilters,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? slug,  String? description,  List<String> roles,  String layout,  List<AnalysisWidget> widgets,  List<GlobalFilter> globalFilters,  String? createdBy,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AnalysisDashboard():
return $default(_that.id,_that.title,_that.slug,_that.description,_that.roles,_that.layout,_that.widgets,_that.globalFilters,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? slug,  String? description,  List<String> roles,  String layout,  List<AnalysisWidget> widgets,  List<GlobalFilter> globalFilters,  String? createdBy,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisDashboard() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.description,_that.roles,_that.layout,_that.widgets,_that.globalFilters,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisDashboard implements AnalysisDashboard {
  const _AnalysisDashboard({required this.id, required this.title, this.slug, this.description, final  List<String> roles = const [], this.layout = 'grid', final  List<AnalysisWidget> widgets = const [], final  List<GlobalFilter> globalFilters = const [], this.createdBy, this.createdAt, this.updatedAt}): _roles = roles,_widgets = widgets,_globalFilters = globalFilters;
  factory _AnalysisDashboard.fromJson(Map<String, dynamic> json) => _$AnalysisDashboardFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? slug;
@override final  String? description;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey() final  String layout;
 final  List<AnalysisWidget> _widgets;
@override@JsonKey() List<AnalysisWidget> get widgets {
  if (_widgets is EqualUnmodifiableListView) return _widgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_widgets);
}

 final  List<GlobalFilter> _globalFilters;
@override@JsonKey() List<GlobalFilter> get globalFilters {
  if (_globalFilters is EqualUnmodifiableListView) return _globalFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_globalFilters);
}

@override final  String? createdBy;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of AnalysisDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisDashboardCopyWith<_AnalysisDashboard> get copyWith => __$AnalysisDashboardCopyWithImpl<_AnalysisDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisDashboard&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.layout, layout) || other.layout == layout)&&const DeepCollectionEquality().equals(other._widgets, _widgets)&&const DeepCollectionEquality().equals(other._globalFilters, _globalFilters)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,slug,description,const DeepCollectionEquality().hash(_roles),layout,const DeepCollectionEquality().hash(_widgets),const DeepCollectionEquality().hash(_globalFilters),createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'AnalysisDashboard(id: $id, title: $title, slug: $slug, description: $description, roles: $roles, layout: $layout, widgets: $widgets, globalFilters: $globalFilters, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AnalysisDashboardCopyWith<$Res> implements $AnalysisDashboardCopyWith<$Res> {
  factory _$AnalysisDashboardCopyWith(_AnalysisDashboard value, $Res Function(_AnalysisDashboard) _then) = __$AnalysisDashboardCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? slug, String? description, List<String> roles, String layout, List<AnalysisWidget> widgets, List<GlobalFilter> globalFilters, String? createdBy, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AnalysisDashboardCopyWithImpl<$Res>
    implements _$AnalysisDashboardCopyWith<$Res> {
  __$AnalysisDashboardCopyWithImpl(this._self, this._then);

  final _AnalysisDashboard _self;
  final $Res Function(_AnalysisDashboard) _then;

/// Create a copy of AnalysisDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? description = freezed,Object? roles = null,Object? layout = null,Object? widgets = null,Object? globalFilters = null,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AnalysisDashboard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self._widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<AnalysisWidget>,globalFilters: null == globalFilters ? _self._globalFilters : globalFilters // ignore: cast_nullable_to_non_nullable
as List<GlobalFilter>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AnalysisWidget {

 String get id; String get title; String get type;// chart_bar, chart_line, chart_pie, kpi, table, text, ai_insight
 String? get formId; String? get groupByField; String? get aggregateField; String get calculationType; Map<String, dynamic> get filters; String get size; String get colorScheme; int get positionX; int get positionY; int get width; int get height; List<String> get displayColumns; Map<String, dynamic> get config; bool get interactivityEnabled; List<String> get linkedWidgetIds; dynamic get data;
/// Create a copy of AnalysisWidget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisWidgetCopyWith<AnalysisWidget> get copyWith => _$AnalysisWidgetCopyWithImpl<AnalysisWidget>(this as AnalysisWidget, _$identity);

  /// Serializes this AnalysisWidget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisWidget&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.groupByField, groupByField) || other.groupByField == groupByField)&&(identical(other.aggregateField, aggregateField) || other.aggregateField == aggregateField)&&(identical(other.calculationType, calculationType) || other.calculationType == calculationType)&&const DeepCollectionEquality().equals(other.filters, filters)&&(identical(other.size, size) || other.size == size)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other.displayColumns, displayColumns)&&const DeepCollectionEquality().equals(other.config, config)&&(identical(other.interactivityEnabled, interactivityEnabled) || other.interactivityEnabled == interactivityEnabled)&&const DeepCollectionEquality().equals(other.linkedWidgetIds, linkedWidgetIds)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,type,formId,groupByField,aggregateField,calculationType,const DeepCollectionEquality().hash(filters),size,colorScheme,positionX,positionY,width,height,const DeepCollectionEquality().hash(displayColumns),const DeepCollectionEquality().hash(config),interactivityEnabled,const DeepCollectionEquality().hash(linkedWidgetIds),const DeepCollectionEquality().hash(data)]);

@override
String toString() {
  return 'AnalysisWidget(id: $id, title: $title, type: $type, formId: $formId, groupByField: $groupByField, aggregateField: $aggregateField, calculationType: $calculationType, filters: $filters, size: $size, colorScheme: $colorScheme, positionX: $positionX, positionY: $positionY, width: $width, height: $height, displayColumns: $displayColumns, config: $config, interactivityEnabled: $interactivityEnabled, linkedWidgetIds: $linkedWidgetIds, data: $data)';
}


}

/// @nodoc
abstract mixin class $AnalysisWidgetCopyWith<$Res>  {
  factory $AnalysisWidgetCopyWith(AnalysisWidget value, $Res Function(AnalysisWidget) _then) = _$AnalysisWidgetCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, String? formId, String? groupByField, String? aggregateField, String calculationType, Map<String, dynamic> filters, String size, String colorScheme, int positionX, int positionY, int width, int height, List<String> displayColumns, Map<String, dynamic> config, bool interactivityEnabled, List<String> linkedWidgetIds, dynamic data
});




}
/// @nodoc
class _$AnalysisWidgetCopyWithImpl<$Res>
    implements $AnalysisWidgetCopyWith<$Res> {
  _$AnalysisWidgetCopyWithImpl(this._self, this._then);

  final AnalysisWidget _self;
  final $Res Function(AnalysisWidget) _then;

/// Create a copy of AnalysisWidget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? formId = freezed,Object? groupByField = freezed,Object? aggregateField = freezed,Object? calculationType = null,Object? filters = null,Object? size = null,Object? colorScheme = null,Object? positionX = null,Object? positionY = null,Object? width = null,Object? height = null,Object? displayColumns = null,Object? config = null,Object? interactivityEnabled = null,Object? linkedWidgetIds = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,formId: freezed == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String?,groupByField: freezed == groupByField ? _self.groupByField : groupByField // ignore: cast_nullable_to_non_nullable
as String?,aggregateField: freezed == aggregateField ? _self.aggregateField : aggregateField // ignore: cast_nullable_to_non_nullable
as String?,calculationType: null == calculationType ? _self.calculationType : calculationType // ignore: cast_nullable_to_non_nullable
as String,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as String,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as int,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,displayColumns: null == displayColumns ? _self.displayColumns : displayColumns // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,interactivityEnabled: null == interactivityEnabled ? _self.interactivityEnabled : interactivityEnabled // ignore: cast_nullable_to_non_nullable
as bool,linkedWidgetIds: null == linkedWidgetIds ? _self.linkedWidgetIds : linkedWidgetIds // ignore: cast_nullable_to_non_nullable
as List<String>,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisWidget].
extension AnalysisWidgetPatterns on AnalysisWidget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisWidget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisWidget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisWidget value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisWidget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisWidget value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisWidget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String? formId,  String? groupByField,  String? aggregateField,  String calculationType,  Map<String, dynamic> filters,  String size,  String colorScheme,  int positionX,  int positionY,  int width,  int height,  List<String> displayColumns,  Map<String, dynamic> config,  bool interactivityEnabled,  List<String> linkedWidgetIds,  dynamic data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisWidget() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.formId,_that.groupByField,_that.aggregateField,_that.calculationType,_that.filters,_that.size,_that.colorScheme,_that.positionX,_that.positionY,_that.width,_that.height,_that.displayColumns,_that.config,_that.interactivityEnabled,_that.linkedWidgetIds,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String type,  String? formId,  String? groupByField,  String? aggregateField,  String calculationType,  Map<String, dynamic> filters,  String size,  String colorScheme,  int positionX,  int positionY,  int width,  int height,  List<String> displayColumns,  Map<String, dynamic> config,  bool interactivityEnabled,  List<String> linkedWidgetIds,  dynamic data)  $default,) {final _that = this;
switch (_that) {
case _AnalysisWidget():
return $default(_that.id,_that.title,_that.type,_that.formId,_that.groupByField,_that.aggregateField,_that.calculationType,_that.filters,_that.size,_that.colorScheme,_that.positionX,_that.positionY,_that.width,_that.height,_that.displayColumns,_that.config,_that.interactivityEnabled,_that.linkedWidgetIds,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String type,  String? formId,  String? groupByField,  String? aggregateField,  String calculationType,  Map<String, dynamic> filters,  String size,  String colorScheme,  int positionX,  int positionY,  int width,  int height,  List<String> displayColumns,  Map<String, dynamic> config,  bool interactivityEnabled,  List<String> linkedWidgetIds,  dynamic data)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisWidget() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.formId,_that.groupByField,_that.aggregateField,_that.calculationType,_that.filters,_that.size,_that.colorScheme,_that.positionX,_that.positionY,_that.width,_that.height,_that.displayColumns,_that.config,_that.interactivityEnabled,_that.linkedWidgetIds,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisWidget implements AnalysisWidget {
  const _AnalysisWidget({required this.id, required this.title, required this.type, this.formId, this.groupByField, this.aggregateField, this.calculationType = 'count', final  Map<String, dynamic> filters = const {}, this.size = 'medium', this.colorScheme = 'ocean', this.positionX = 0, this.positionY = 0, this.width = 2, this.height = 2, final  List<String> displayColumns = const [], final  Map<String, dynamic> config = const {}, this.interactivityEnabled = true, final  List<String> linkedWidgetIds = const [], this.data}): _filters = filters,_displayColumns = displayColumns,_config = config,_linkedWidgetIds = linkedWidgetIds;
  factory _AnalysisWidget.fromJson(Map<String, dynamic> json) => _$AnalysisWidgetFromJson(json);

@override final  String id;
@override final  String title;
@override final  String type;
// chart_bar, chart_line, chart_pie, kpi, table, text, ai_insight
@override final  String? formId;
@override final  String? groupByField;
@override final  String? aggregateField;
@override@JsonKey() final  String calculationType;
 final  Map<String, dynamic> _filters;
@override@JsonKey() Map<String, dynamic> get filters {
  if (_filters is EqualUnmodifiableMapView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_filters);
}

@override@JsonKey() final  String size;
@override@JsonKey() final  String colorScheme;
@override@JsonKey() final  int positionX;
@override@JsonKey() final  int positionY;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
 final  List<String> _displayColumns;
@override@JsonKey() List<String> get displayColumns {
  if (_displayColumns is EqualUnmodifiableListView) return _displayColumns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_displayColumns);
}

 final  Map<String, dynamic> _config;
@override@JsonKey() Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

@override@JsonKey() final  bool interactivityEnabled;
 final  List<String> _linkedWidgetIds;
@override@JsonKey() List<String> get linkedWidgetIds {
  if (_linkedWidgetIds is EqualUnmodifiableListView) return _linkedWidgetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_linkedWidgetIds);
}

@override final  dynamic data;

/// Create a copy of AnalysisWidget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisWidgetCopyWith<_AnalysisWidget> get copyWith => __$AnalysisWidgetCopyWithImpl<_AnalysisWidget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisWidgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisWidget&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.formId, formId) || other.formId == formId)&&(identical(other.groupByField, groupByField) || other.groupByField == groupByField)&&(identical(other.aggregateField, aggregateField) || other.aggregateField == aggregateField)&&(identical(other.calculationType, calculationType) || other.calculationType == calculationType)&&const DeepCollectionEquality().equals(other._filters, _filters)&&(identical(other.size, size) || other.size == size)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&const DeepCollectionEquality().equals(other._displayColumns, _displayColumns)&&const DeepCollectionEquality().equals(other._config, _config)&&(identical(other.interactivityEnabled, interactivityEnabled) || other.interactivityEnabled == interactivityEnabled)&&const DeepCollectionEquality().equals(other._linkedWidgetIds, _linkedWidgetIds)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,type,formId,groupByField,aggregateField,calculationType,const DeepCollectionEquality().hash(_filters),size,colorScheme,positionX,positionY,width,height,const DeepCollectionEquality().hash(_displayColumns),const DeepCollectionEquality().hash(_config),interactivityEnabled,const DeepCollectionEquality().hash(_linkedWidgetIds),const DeepCollectionEquality().hash(data)]);

@override
String toString() {
  return 'AnalysisWidget(id: $id, title: $title, type: $type, formId: $formId, groupByField: $groupByField, aggregateField: $aggregateField, calculationType: $calculationType, filters: $filters, size: $size, colorScheme: $colorScheme, positionX: $positionX, positionY: $positionY, width: $width, height: $height, displayColumns: $displayColumns, config: $config, interactivityEnabled: $interactivityEnabled, linkedWidgetIds: $linkedWidgetIds, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AnalysisWidgetCopyWith<$Res> implements $AnalysisWidgetCopyWith<$Res> {
  factory _$AnalysisWidgetCopyWith(_AnalysisWidget value, $Res Function(_AnalysisWidget) _then) = __$AnalysisWidgetCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, String? formId, String? groupByField, String? aggregateField, String calculationType, Map<String, dynamic> filters, String size, String colorScheme, int positionX, int positionY, int width, int height, List<String> displayColumns, Map<String, dynamic> config, bool interactivityEnabled, List<String> linkedWidgetIds, dynamic data
});




}
/// @nodoc
class __$AnalysisWidgetCopyWithImpl<$Res>
    implements _$AnalysisWidgetCopyWith<$Res> {
  __$AnalysisWidgetCopyWithImpl(this._self, this._then);

  final _AnalysisWidget _self;
  final $Res Function(_AnalysisWidget) _then;

/// Create a copy of AnalysisWidget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? formId = freezed,Object? groupByField = freezed,Object? aggregateField = freezed,Object? calculationType = null,Object? filters = null,Object? size = null,Object? colorScheme = null,Object? positionX = null,Object? positionY = null,Object? width = null,Object? height = null,Object? displayColumns = null,Object? config = null,Object? interactivityEnabled = null,Object? linkedWidgetIds = null,Object? data = freezed,}) {
  return _then(_AnalysisWidget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,formId: freezed == formId ? _self.formId : formId // ignore: cast_nullable_to_non_nullable
as String?,groupByField: freezed == groupByField ? _self.groupByField : groupByField // ignore: cast_nullable_to_non_nullable
as String?,aggregateField: freezed == aggregateField ? _self.aggregateField : aggregateField // ignore: cast_nullable_to_non_nullable
as String?,calculationType: null == calculationType ? _self.calculationType : calculationType // ignore: cast_nullable_to_non_nullable
as String,filters: null == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as String,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as int,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,displayColumns: null == displayColumns ? _self._displayColumns : displayColumns // ignore: cast_nullable_to_non_nullable
as List<String>,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,interactivityEnabled: null == interactivityEnabled ? _self.interactivityEnabled : interactivityEnabled // ignore: cast_nullable_to_non_nullable
as bool,linkedWidgetIds: null == linkedWidgetIds ? _self._linkedWidgetIds : linkedWidgetIds // ignore: cast_nullable_to_non_nullable
as List<String>,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
