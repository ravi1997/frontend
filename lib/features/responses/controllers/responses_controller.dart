import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/responses/form_response.dart';
import 'package:frontend/features/responses/response_repository_provider.dart';

typedef _ListArgs = ({String projectId, String formId, String? searchQuery});
typedef _DetailArgs = ({String projectId, String formId, String responseId});
typedef _FilterArgs = ({
  String projectId,
  String formId,
  List<Map<String, dynamic>>? filters,
});

final _formResponsesProvider =
    FutureProvider.family<List<FormResponse>, _ListArgs>((ref, args) async {
      final repository = ref.watch(responseRepositoryProvider);
      final searchQuery = args.searchQuery;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return repository.aiSearch(args.formId, searchQuery);
      }
      return repository.getProjectResponses(args.projectId, args.formId);
    });

final _responseDetailProvider =
    FutureProvider.family<FormResponse, _DetailArgs>((ref, args) {
      final repository = ref.watch(responseRepositoryProvider);
      return repository.getProjectResponseDetail(
        args.projectId,
        args.formId,
        args.responseId,
      );
    });

final _responseHistoryProvider =
    FutureProvider.family<List<ResponseHistory>, _DetailArgs>((ref, args) {
      final repository = ref.watch(responseRepositoryProvider);
      return repository.getProjectResponseHistory(
        args.projectId,
        args.formId,
        args.responseId,
      );
    });

final _filteredFormResponsesProvider =
    FutureProvider.family<List<FormResponse>, _FilterArgs>((ref, args) {
      final repository = ref.watch(responseRepositoryProvider);
      final filters = args.filters;
      if (filters != null && filters.isNotEmpty) {
        return repository.getFilteredResponses(
          args.projectId,
          args.formId,
          filters,
        );
      }
      return repository.getProjectResponses(args.projectId, args.formId);
    });

dynamic formResponsesProvider(
  String projectId,
  String formId, {
  String? searchQuery,
}) => _formResponsesProvider((
  projectId: projectId,
  formId: formId,
  searchQuery: searchQuery,
));

dynamic responseDetailProvider(
  String projectId,
  String formId,
  String responseId,
) => _responseDetailProvider((
  projectId: projectId,
  formId: formId,
  responseId: responseId,
));

dynamic responseHistoryProvider(
  String projectId,
  String formId,
  String responseId,
) => _responseHistoryProvider((
  projectId: projectId,
  formId: formId,
  responseId: responseId,
));

dynamic filteredFormResponsesProvider(
  String projectId,
  String formId, {
  List<Map<String, dynamic>>? filters,
}) => _filteredFormResponsesProvider((
  projectId: projectId,
  formId: formId,
  filters: filters,
));
