"""
lib/modules/dashboard_builder/providers/natural_language_query_provider.dart
Provider for Natural Language Query state management.
"""

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../models/natural_language_query_models.dart';
import '../models/dashboard_models.dart';
import '../../core/services/api_service.dart';

class NaturalLanguageQueryNotifier extends StateNotifier<NaturalLanguageQueryState> {
  final String dashboardId;
  final ApiService _apiService;

  NaturalLanguageQueryNotifier({
    required this.dashboardId,
    required ApiService apiService,
  })  : _apiService = apiService,
        super(NaturalLanguageQueryState(
          queries: [],
          isProcessing: false,
        ));

  Future<void> processQuery({
    required String query,
    required List<AnalysisModel> availableAnalyses,
  }) async {
    if (state.isProcessing) return;

    // Add query immediately
    final newQuery = NaturalLanguageQuery(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      query: query,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      queries: [...state.queries, newQuery],
      isProcessing: true,
      error: null,
    );

    try {
      final response = await _apiService.post(
        '/api/internal/v1/dashboards/$dashboardId/natural-language-query',
        data: {
          'query': query,
          'available_analyses': availableAnalyses.map((a) => a.toJson()).toList(),
          'context': state.context,
        },
      );

      final queryResponse = NaturalLanguageQueryResponse.fromJson(response.data['response']);
      
      // Update the query with response
      final updatedQuery = newQuery.copyWith(response: queryResponse);
      
      state = state.copyWith(
        queries: [
          ...state.queries.where((q) => q.id != newQuery.id),
          updatedQuery,
        ],
        isProcessing: false,
        context: response.data['context'],
      );
    } catch (e) {
      // Update the query with error
      final updatedQuery = newQuery.copyWith(error: e.toString());
      
      state = state.copyWith(
        queries: [
          ...state.queries.where((q) => q.id != newQuery.id),
          updatedQuery,
        ],
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> applyFilters(List<NaturalLanguageFilter> filters) async {
    try {
      await _apiService.post(
        '/api/internal/v1/dashboards/$dashboardId/apply-filters',
        data: {
          'filters': filters.map((f) => f.toJson()).toList(),
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearQueries() {
    state = state.copyWith(queries: []);
  }

  void removeQuery(String queryId) {
    state = state.copyWith(
      queries: state.queries.where((q) => q.id != queryId).toList(),
    );
  }
}

final naturalLanguageQueryProvider = StateNotifierProviderFamily<
  NaturalLanguageQueryNotifier,
  NaturalLanguageQueryState,
  String
>((ref, dashboardId) {
  final apiService = ref.read(apiServiceProvider);
  return NaturalLanguageQueryNotifier(
    dashboardId: dashboardId,
    apiService: apiService,
  );
});

// Extension to make copyWith available
extension NaturalLanguageQueryStateExtension on NaturalLanguageQueryState {
  NaturalLanguageQueryState copyWith({
    List<NaturalLanguageQuery>? queries,
    bool? isProcessing,
    String? error,
    Map<String, dynamic>? context,
  }) {
    return NaturalLanguageQueryState(
      queries: queries ?? this.queries,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error ?? this.error,
      context: context ?? this.context,
    );
  }
}

// Extension to make copyWith available for NaturalLanguageQuery
extension NaturalLanguageQueryExtension on NaturalLanguageQuery {
  NaturalLanguageQuery copyWith({
    String? id,
    String? query,
    NaturalLanguageQueryResponse? response,
    String? error,
    DateTime? createdAt,
  }) {
    return NaturalLanguageQuery(
      id: id ?? this.id,
      query: query ?? this.query,
      response: response ?? this.response,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}