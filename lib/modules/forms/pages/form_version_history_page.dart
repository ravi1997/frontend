import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/modules/forms/services/version_history_controller.dart';
import 'package:frontend/modules/forms/widgets/version_history_list_tile.dart';

class FormVersionHistoryPage extends ConsumerStatefulWidget {
  final String projectId;
  final String formId;
  final String formTitle;

  const FormVersionHistoryPage({
    super.key,
    required this.projectId,
    required this.formId,
    required this.formTitle,
  });

  @override
  ConsumerState<FormVersionHistoryPage> createState() =>
      _FormVersionHistoryPageState();
}

class _FormVersionHistoryPageState extends ConsumerState<FormVersionHistoryPage> {
  late final String _controllerKey;
  bool _didRefresh = false;

  @override
  void initState() {
    super.initState();
    _controllerKey = '${widget.projectId}::${widget.formId}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRefresh) return;
    _didRefresh = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(versionHistoryControllerProvider(_controllerKey)).refresh();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(versionHistoryControllerProvider(_controllerKey));
    final state = controller.state;

    return Scaffold(
      backgroundColor: AppColors.builderBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text('${widget.formTitle} — Version History'),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, VersionHistoryState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(versionHistoryControllerProvider(_controllerKey))
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.versions.isEmpty) {
      return const Center(
        child: Text('No versions available.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: state.versions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final version = state.versions[index];
        return VersionHistoryListTile(
          version: version,
          isSelected: state.selectedVersion?.version == version.version,
          onTap: () => ref
              .read(versionHistoryControllerProvider(_controllerKey))
              .selectVersion(version),
          onView: () => ref
              .read(versionHistoryControllerProvider(_controllerKey))
              .viewVersion(version),
          onRestore: () async {
            final ok = await ref
                .read(versionHistoryControllerProvider(_controllerKey))
                .restoreVersion(version);
            if (!mounted) return;
            if (!ok && ref.read(versionHistoryControllerProvider(_controllerKey)).state.error != null) {
              _showError(
                ref.read(versionHistoryControllerProvider(_controllerKey)).state.error!,
              );
            }
          },
        );
      },
    );
  }
}
