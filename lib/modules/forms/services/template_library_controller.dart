import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/models/form_template.dart';
import 'package:frontend/modules/forms/services/template_library_providers.dart';

class TemplateLibraryState {
  final List<FormTemplate> templates;
  final List<FormTemplate> filteredTemplates;
  final FormTemplateCategory? selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? error;
  final FormTemplate? selectedTemplate;

  const TemplateLibraryState({
    this.templates = const [],
    this.filteredTemplates = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
    this.selectedTemplate,
  });

  TemplateLibraryState copyWith({
    List<FormTemplate>? templates,
    List<FormTemplate>? filteredTemplates,
    FormTemplateCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? error,
    FormTemplate? selectedTemplate,
    bool clearSelectedTemplate = false,
  }) {
    return TemplateLibraryState(
      templates: templates ?? this.templates,
      filteredTemplates: filteredTemplates ?? this.filteredTemplates,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTemplate: clearSelectedTemplate
          ? null
          : (selectedTemplate ?? this.selectedTemplate),
    );
  }
}

class TemplateLibraryController extends ChangeNotifier {
  TemplateLibraryController(this.ref) {
    _loadInitialTemplates();
  }

  final Ref ref;
  TemplateLibraryState _state = const TemplateLibraryState();

  TemplateLibraryState get state => _state;

  set _nextState(TemplateLibraryState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _loadInitialTemplates() async {
    _nextState = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(templateLibraryRepositoryProvider);
      final templates = await repository.getAllTemplates();
      _nextState = state.copyWith(
        templates: templates,
        filteredTemplates: templates,
        isLoading: false,
      );
    } catch (e) {
      _nextState = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadTemplates() async => _loadInitialTemplates();

  Future<void> filterByCategory(FormTemplateCategory? category) async {
    final filtered = _filterTemplates(
      state.templates,
      category,
      state.searchQuery,
    );
    _nextState = state.copyWith(
      selectedCategory: category,
      filteredTemplates: filtered,
    );
  }

  Future<void> searchTemplates(String query) async {
    final filtered = _filterTemplates(
      state.templates,
      state.selectedCategory,
      query,
    );
    _nextState = state.copyWith(searchQuery: query, filteredTemplates: filtered);
  }

  Future<void> selectTemplate(FormTemplate template) async {
    _nextState = state.copyWith(selectedTemplate: template);
  }

  void clearSelectedTemplate() {
    _nextState = state.copyWith(clearSelectedTemplate: true);
  }

  Future<String> createFormFromTemplate(
    String templateId,
    String formName,
  ) async {
    try {
      final repository = ref.read(templateLibraryRepositoryProvider);
      final formId = await repository.createFormFromTemplate(
        templateId,
        formName,
      );

      final updatedTemplates = state.templates.map((t) {
        if (t.id == templateId) {
          return t.copyWith(usageCount: t.usageCount + 1);
        }
        return t;
      }).toList();

      _nextState = state.copyWith(
        templates: updatedTemplates,
        filteredTemplates: _filterTemplates(
          updatedTemplates,
          state.selectedCategory,
          state.searchQuery,
        ),
      );

      return formId;
    } catch (e) {
      _nextState = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async => _loadInitialTemplates();

  void clearError() {
    _nextState = state.copyWith(error: null);
  }

  List<FormTemplate> _filterTemplates(
    List<FormTemplate> templates,
    FormTemplateCategory? category,
    String searchQuery,
  ) {
    var filtered = templates;
    if (category != null) {
      filtered = filtered.where((t) => t.category == category).toList();
    }
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (t) =>
                t.name.toLowerCase().contains(query) ||
                t.description.toLowerCase().contains(query) ||
                t.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }
    return filtered;
  }
}

final templateLibraryControllerProvider =
    Provider<TemplateLibraryController>((ref) {
  final controller = TemplateLibraryController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
