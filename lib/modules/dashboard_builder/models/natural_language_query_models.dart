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
}

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

  factory NaturalLanguageQueryResponse.fromJson(Map<String, dynamic> json) {
    return NaturalLanguageQueryResponse(
      explanation: json['explanation']?.toString() ?? '',
      filters: const [],
      suggestedVisualizations: List<String>.from(json['suggestedVisualizations'] ?? const []),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

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

  Map<String, dynamic> toJson() => {
        'field': field,
        'operator': operator,
        'value': value,
        'dataType': dataType,
        'description': description,
      };
}

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
}
