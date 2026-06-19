"""
lib/modules/dashboard_builder/models/natural_language_query_models.dart
Models for Natural Language Query functionality.
"""

import 'package:json_annotation/json_annotation.dart';

part 'natural_language_query_models.g.dart';

@JsonSerializable()
class NaturalLanguageQuery {
  final String id;
  final String query;
  final NaturalLanguageQueryResponse? response;
  final String? error;
  final DateTime createdAt;

  NaturalLanguageQuery({
    required this.id,
    required this.query,
    this.response,
    this.error,
    required this.createdAt,
  });

  factory NaturalLanguageQuery.fromJson(Map<String, dynamic> json) =>
      _$NaturalLanguageQueryFromJson(json);
  Map<String, dynamic> toJson() => _$NaturalLanguageQueryToJson(this);
}

@JsonSerializable()
class NaturalLanguageQueryResponse {
  final String explanation;
  final List<NaturalLanguageFilter> filters;
  final List<String> suggestedVisualizations;
  final Map<String, dynamic>? metadata;

  NaturalLanguageQueryResponse({
    required this.explanation,
    required this.filters,
    required this.suggestedVisualizations,
    this.metadata,
  });

  factory NaturalLanguageQueryResponse.fromJson(Map<String, dynamic> json) =>
      _$NaturalLanguageQueryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NaturalLanguageQueryResponseToJson(this);
}

@JsonSerializable()
class NaturalLanguageFilter {
  final String field;
  final String operator;
  final dynamic value;
  final String? dataType;
  final String? description;

  NaturalLanguageFilter({
    required this.field,
    required this.operator,
    required this.value,
    this.dataType,
    this.description,
  });

  factory NaturalLanguageFilter.fromJson(Map<String, dynamic> json) =>
      _$NaturalLanguageFilterFromJson(json);
  Map<String, dynamic> toJson() => _$NaturalLanguageFilterToJson(this);
}

@JsonSerializable()
class NaturalLanguageQueryState {
  final List<NaturalLanguageQuery> queries;
  final bool isProcessing;
  final String? error;
  final Map<String, dynamic>? context;

  NaturalLanguageQueryState({
    required this.queries,
    required this.isProcessing,
    this.error,
    this.context,
  });

  factory NaturalLanguageQueryState.fromJson(Map<String, dynamic> json) =>
      _$NaturalLanguageQueryStateFromJson(json);
  Map<String, dynamic> toJson() => _$NaturalLanguageQueryStateToJson(this);
}

// Filter operators
class NaturalLanguageFilterOperators {
  static const String equals = 'equals';
  static const String notEquals = 'not_equals';
  static const String contains = 'contains';
  static const String startsWith = 'starts_with';
  static const String endsWith = 'ends_with';
  static const String greaterThan = 'greater_than';
  static const String lessThan = 'less_than';
  static const String greaterThanOrEqual = 'greater_than_or_equal';
  static const String lessThanOrEqual = 'less_than_or_equal';
  static const String inList = 'in_list';
  static const String notInList = 'not_in_list';
  static const String isNull = 'is_null';
  static const String isNotNull = 'is_not_null';
}

// Data types
class NaturalLanguageDataTypes {
  static const String string = 'string';
  static const String number = 'number';
  static const String boolean = 'boolean';
  static const String date = 'date';
  static const String datetime = 'datetime';
  static const String array = 'array';
  static const String object = 'object';
}