import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/form_models.dart';
import 'package:frontend/features/form_builder/models/form_version_history.dart';
import 'package:frontend/features/form_builder/services/form_builder_repository.dart';

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
}

class VersionHistoryController extends ChangeNotifier {
  VersionHistoryController(this.ref, this.formKey) {
    _init();
  }

  final Ref ref;
  final String formKey;
  late final String _projectId;
  late final String _formId;
  VersionHistoryState _state = const VersionHistoryState(isLoading: true);

  VersionHistoryState get state => _state;
  set state(VersionHistoryState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _init() async {
    final parts = formKey.split('::');
    _projectId = parts.first;
    _formId = parts.sublist(1).join('::');
    await _loadVersionHistory();
  }

  Future<void> _loadVersionHistory() async {
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final versions = await repository.getVersionHistory(_projectId, _formId);
      final sortedVersions = List<FormVersionHistory>.from(versions)
        ..sort((a, b) => b.created_at.compareTo(a.created_at));
      state = state.copyWith(
        versions: sortedVersions,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final versions = await repository.getVersionHistory(_projectId, _formId);
      final sortedVersions = List<FormVersionHistory>.from(versions)
        ..sort((a, b) => b.created_at.compareTo(a.created_at));
      state = state.copyWith(
        versions: sortedVersions,
        isRefreshing: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }

  Future<void> selectVersion(FormVersionHistory version) async {
    state = state.copyWith(
      selectedVersion: version,
      selectedForm: null,
      error: null,
    );
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final form = await repository.getFormVersion(_projectId, _formId, version.version);
      state = state.copyWith(selectedForm: form);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load version details: $e');
    }
  }

  Future<void> viewVersion(FormVersionHistory version) async {
    await selectVersion(version);
  }

  Future<bool> restoreVersion(FormVersionHistory version) async {
    if (state.selectedForm == null) {
      state = state.copyWith(error: 'Version data not loaded');
      return false;
    }
    state = state.copyWith(isRestoring: true, error: null);
    try {
      final repository = ref.read(formBuilderRepositoryProvider);
      final formToRestore = state.selectedForm!;
      final updatedForm = formToRestore.copyWith(
        id: _formId,
        title: formToRestore.title,
        activeVersion: version.version,
      );
      await repository.saveForm(updatedForm, projectId: _projectId);
      final versions = await repository.getVersionHistory(_projectId, _formId);
      final sortedVersions = List<FormVersionHistory>.from(versions)
        ..sort((a, b) => b.created_at.compareTo(a.created_at));
      state = state.copyWith(
        versions: sortedVersions,
        isRestoring: false,
        selectedVersion: null,
        selectedForm: null,
        currentVersion: sortedVersions.first.version,
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

  void clearSelection() {
    state = state.copyWith(
      selectedVersion: null,
      selectedForm: null,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setCurrentVersion(String version) {
    state = state.copyWith(currentVersion: version);
  }
}

final versionHistoryControllerProvider =
    Provider.family<VersionHistoryController, String>((ref, formKey) {
  final controller = VersionHistoryController(ref, formKey);
  ref.onDispose(controller.dispose);
  return controller;
});
