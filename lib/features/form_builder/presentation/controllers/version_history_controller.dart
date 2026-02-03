import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/form_version_history.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/repositories/form_builder_repository.dart';

part 'version_history_controller.g.dart';

/// State class for version history data.
class VersionHistoryState {
  final List<FormVersionHistory> versions;
  final FormVersionHistory? selectedVersion;
  final BuilderForm? selectedForm;
  final String? currentVersion;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final bool isRestoring;

  const VersionHistoryState({
    this.versions = const [],
    this.selectedVersion,
    this.selectedForm,
    this.currentVersion,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.isRestoring = false,
  });

  VersionHistoryState copyWith({
    List<FormVersionHistory>? versions,
    FormVersionHistory? selectedVersion,
    BuilderForm? selectedForm,
    String? currentVersion,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool? isRestoring,
  }) {
    return VersionHistoryState(
      versions: versions ?? this.versions,
      selectedVersion: selectedVersion ?? this.selectedVersion,
      selectedForm: selectedForm ?? this.selectedForm,
      currentVersion: currentVersion ?? this.currentVersion,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }

  bool get hasError => error != null;
  bool get hasSelection => selectedVersion != null;
}

/// Controller for managing version history using Riverpod.
///
/// Provides async access to:
/// - List of all versions for a form
/// - Selected version details
/// - Version restoration functionality
@riverpod
class VersionHistoryController extends _$VersionHistoryController {
  @override
  VersionHistoryState build(String formId) {
    // Load initial data
    _loadVersionHistory();
    return const VersionHistoryState();
  }

  /// Loads all version history for the form.
  Future<void> _loadVersionHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final versions = await repository.getVersionHistory(formId);

      state = state.copyWith(versions: versions, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refreshes all version history data.
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final versions = await repository.getVersionHistory(formId);

      state = state.copyWith(
        versions: versions,
        isRefreshing: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }

  /// Selects a version to view details.
  Future<void> selectVersion(FormVersionHistory version) async {
    state = state.copyWith(
      selectedVersion: version,
      selectedForm: null,
      error: null,
    );

    // Load the form data for this version
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final form = await repository.getFormVersion(formId, version.version);

      state = state.copyWith(selectedForm: form);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load version details: $e');
    }
  }

  /// Views a specific version without restoring.
  Future<void> viewVersion(FormVersionHistory version) async {
    await selectVersion(version);
    // Navigate to preview if needed
    // This could trigger a navigation to form preview
  }

  /// Restores a previous version, creating a new current version.
  Future<bool> restoreVersion(FormVersionHistory version) async {
    if (state.selectedForm == null) {
      state = state.copyWith(error: 'Version data not loaded');
      return false;
    }

    state = state.copyWith(isRestoring: true, error: null);

    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final formToRestore = state.selectedForm!;

      // Create a new version based on the selected version
      final updatedForm = formToRestore.copyWith(
        id: formId,
        title: formToRestore.title,
        updatedAt: DateTime.now(),
      );

      // Save the restored form (creates a new version)
      await repository.saveForm(updatedForm);

      // Refresh the version history
      final versions = await repository.getVersionHistory(formId);

      state = state.copyWith(
        versions: versions,
        isRestoring: false,
        selectedVersion: null,
        selectedForm: null,
        currentVersion: versions.first.version,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isRestoring: false,
        error: 'Failed to restore version: $e',
      );
      return false;
    }
  }

  /// Clears the selected version.
  void clearSelection() {
    state = state.copyWith(
      selectedVersion: null,
      selectedForm: null,
      error: null,
    );
  }

  /// Clears any error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Sets the current version (from form data).
  void setCurrentVersion(String version) {
    state = state.copyWith(currentVersion: version);
  }
}
