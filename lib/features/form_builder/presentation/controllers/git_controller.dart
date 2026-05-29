import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/network/api_client_wrapper.dart';

class GitBranchCommit {
  final String id;
  final String parentCommitId;
  final String authorId;
  final DateTime timestamp;
  final String message;
  final List<dynamic> patch;

  GitBranchCommit({
    required this.id,
    required this.parentCommitId,
    required this.authorId,
    required this.timestamp,
    required this.message,
    required this.patch,
  });

  factory GitBranchCommit.fromJson(Map<String, dynamic> json) {
    return GitBranchCommit(
      id: json['id'] ?? '',
      parentCommitId: json['parent_commit_id'] ?? '',
      authorId: json['author_id'] ?? '',
      timestamp: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      message: json['message'] ?? '',
      patch: json['patch'] ?? [],
    );
  }
}

class GitConflict {
  final String path;
  final dynamic mine;
  final dynamic theirs;
  final String mineOp;
  final String theirsOp;

  GitConflict({
    required this.path,
    required this.mine,
    required this.theirs,
    required this.mineOp,
    required this.theirsOp,
  });

  factory GitConflict.fromJson(Map<String, dynamic> json) {
    return GitConflict(
      path: json['path'] ?? '',
      mine: json['mine'],
      theirs: json['theirs'],
      mineOp: json['mine_op'] ?? '',
      theirsOp: json['theirs_op'] ?? '',
    );
  }
}

class GitState {
  final List<GitBranchCommit> commits;
  final String activeBranch;
  final List<String> branches;
  final List<GitConflict> conflicts;
  final bool isLoading;
  final String? error;

  GitState({
    this.commits = const [],
    this.activeBranch = 'main',
    this.branches = const ['main', 'draft/patient-OPD', 'workspace/redesign'],
    this.conflicts = const [],
    this.isLoading = false,
    this.error,
  });

  GitState copyWith({
    List<GitBranchCommit>? commits,
    String? activeBranch,
    List<String>? branches,
    List<GitConflict>? conflicts,
    bool? isLoading,
    String? error,
  }) {
    return GitState(
      commits: commits ?? this.commits,
      activeBranch: activeBranch ?? this.activeBranch,
      branches: branches ?? this.branches,
      conflicts: conflicts ?? this.conflicts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class GitController extends StateNotifier<GitState> {
  final ApiClient _apiClient;

  GitController(this._apiClient) : super(GitState());

  /// Sets the active branch workspace in the top bar.
  void switchBranch(String branchName) {
    state = state.copyWith(activeBranch: branchName);
  }

  /// Lists commit history tree for a specific form.
  Future<void> loadCommits(String projectId, String formId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(
        '/mahasangraha/api/v1/projects/$projectId/forms/$formId/commits',
      );
      final list = (response.data['data'] as List?) ?? [];
      final commits = list
          .map((json) => GitBranchCommit.fromJson(json))
          .toList();
      state = state.copyWith(commits: commits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Creates a new snapshot commit of the form configuration (saving a draft).
  Future<String?> createCommit(
    String projectId,
    String formId,
    String message,
    Map<String, dynamic> formData,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.post(
        '/mahasangraha/api/v1/projects/$projectId/forms/$formId/commits',
        data: {'message': message, 'form_data': formData},
      );
      state = state.copyWith(isLoading: false);
      final commitId = response.data['data']['commit_id'] as String?;
      if (commitId != null) {
        await loadCommits(projectId, formId);
      }
      return commitId;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Executes branch 3-way merge conflict resolution.
  Future<bool> mergeBranches(
    String projectId,
    String formId,
    String theirsCommitId,
    String mineCommitId,
  ) async {
    state = state.copyWith(isLoading: true, error: null, conflicts: []);
    try {
      final response = await _apiClient.post(
        '/mahasangraha/api/v1/projects/$projectId/forms/$formId/merge',
        data: {
          'theirs_commit_id': theirsCommitId,
          'mine_commit_id': mineCommitId,
        },
      );

      state = state.copyWith(isLoading: false);
      final resData = response.data['data'] as Map<String, dynamic>;

      if (resData['status'] == 'conflict') {
        final conflictList = (resData['conflicts'] as List?) ?? [];
        final conflicts = conflictList
            .map((json) => GitConflict.fromJson(json))
            .toList();
        state = state.copyWith(conflicts: conflicts);
        return false;
      }

      await loadCommits(projectId, formId);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final gitControllerProvider =
    StateNotifierProvider.family<GitController, GitState, String>((
      ref,
      formKey,
    ) {
      final apiClient = ref.watch(apiClientProvider);
      return GitController(apiClient);
    });
