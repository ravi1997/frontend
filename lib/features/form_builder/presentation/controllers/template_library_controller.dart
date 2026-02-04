import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/form_template.dart';
import '../providers/template_library_providers.dart';

part 'template_library_controller.g.dart';

/// State class for the template library controller.
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

@riverpod
class TemplateLibraryController extends _$TemplateLibraryController {
  @override
  FutureOr<TemplateLibraryState> build() async {
    final repository = ref.read(templateLibraryRepositoryProvider);
    final templates = await repository.getAllTemplates();
    return TemplateLibraryState(
      templates: templates,
      filteredTemplates: templates,
    );
  }

  Future<void> loadTemplates() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(templateLibraryRepositoryProvider);
      final templates = await repository.getAllTemplates();
      final currentState = state.value;
      state = AsyncValue.data(
        currentState!.copyWith(
          templates: templates,
          filteredTemplates: _filterTemplates(
            templates,
            currentState.selectedCategory,
            currentState.searchQuery,
          ),
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      final currentState = state.value;
      state = AsyncValue.data(
        currentState!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> filterByCategory(FormTemplateCategory? category) async {
    final currentState = state.value;
    if (currentState == null) return;

    final filtered = _filterTemplates(
      currentState.templates,
      category,
      currentState.searchQuery,
    );
    state = AsyncValue.data(
      currentState.copyWith(
        selectedCategory: category,
        filteredTemplates: filtered,
      ),
    );
  }

  Future<void> searchTemplates(String query) async {
    final currentState = state.value;
    if (currentState == null) return;

    final filtered = _filterTemplates(
      currentState.templates,
      currentState.selectedCategory,
      query,
    );
    state = AsyncValue.data(
      currentState.copyWith(searchQuery: query, filteredTemplates: filtered),
    );
  }

  Future<void> selectTemplate(FormTemplate template) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(selectedTemplate: template));
  }

  void clearSelectedTemplate() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(clearSelectedTemplate: true));
  }

  Future<String> createFormFromTemplate(
    String templateId,
    String formName,
  ) async {
    final currentState = state.value;
    if (currentState == null) throw Exception('Controller not initialized');

    try {
      final repository = ref.read(templateLibraryRepositoryProvider);
      final formId = await repository.createFormFromTemplate(
        templateId,
        formName,
      );

      // Increment usage count in local state
      final updatedTemplates = currentState.templates.map((t) {
        if (t.id == templateId) {
          return t.copyWith(usageCount: t.usageCount + 1);
        }
        return t;
      }).toList();

      final filtered = _filterTemplates(
        updatedTemplates,
        currentState.selectedCategory,
        currentState.searchQuery,
      );

      state = AsyncValue.data(
        currentState.copyWith(
          templates: updatedTemplates,
          filteredTemplates: filtered,
        ),
      );

      return formId;
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadTemplates();
  }

  void clearError() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(error: null));
  }

  List<FormTemplate> _filterTemplates(
    List<FormTemplate> templates,
    FormTemplateCategory? category,
    String searchQuery,
  ) {
    var filtered = templates;

    // Filter by category
    if (category != null) {
      filtered = filtered.where((t) => t.category == category).toList();
    }

    // Filter by search query
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
