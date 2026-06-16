import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/analytics/analysis_dashboard.dart';
import 'package:frontend/modules/analytics/analytics_providers.dart';

class ProjectAnalysisBoardsListPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectAnalysisBoardsListPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectAnalysisBoardsListPage> createState() =>
      _ProjectAnalysisBoardsListPageState();
}

class _ProjectAnalysisBoardsListPageState
    extends ConsumerState<ProjectAnalysisBoardsListPage> {
  late Future<List<AnalysisDashboard>> _dashboardsFuture;

  @override
  void initState() {
    super.initState();
    _loadDashboards();
  }

  void _loadDashboards() {
    _dashboardsFuture = ref
        .read(analysisDashboardRepositoryProvider)
        .listDashboards();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Analysis dashboards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _createDashboard(context),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Create board'),
          ),
          const SizedBox(width: DesignTokens.spaceXS),
          IconButton(
            tooltip: 'Refresh dashboards',
            onPressed: () {
              setState(_loadDashboards);
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<AnalysisDashboard>>(
          future: _dashboardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () => setState(_loadDashboards),
              );
            }

            final dashboards = snapshot.data ?? const <AnalysisDashboard>[];
            return SingleChildScrollView(
              padding: Responsive.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCard(
                        projectId: widget.projectId,
                        dashboardCount: dashboards.length,
                      ),
                      const SizedBox(height: DesignTokens.spaceL),
                      if (dashboards.isEmpty)
                        _EmptyState(projectId: widget.projectId)
                      else
                        ...dashboards.map(
                          (dashboard) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: DesignTokens.spaceM,
                            ),
                            child: _DashboardCard(
                              dashboard: dashboard,
                              onOpen: () => _showDetails(context, dashboard),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, AnalysisDashboard dashboard) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _DashboardDetailsSheet(
        projectId: widget.projectId,
        dashboard: dashboard,
      ),
    );
  }

  Future<void> _createDashboard(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New analysis board'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Board title*',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final created = await ref.read(analysisDashboardRepositoryProvider).createDashboard(
            AnalysisDashboard(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: titleCtrl.text.trim(),
              slug: null,
              description: descCtrl.text.trim().isEmpty
                  ? null
                  : descCtrl.text.trim(),
            ),
          );
      if (!context.mounted) return;
      setState(_loadDashboards);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Created ${created.title}'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create board: $e')),
      );
    }
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final int dashboardCount;

  const _HeroCard({required this.projectId, required this.dashboardCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.darkBackground,
            DesignTokens.primaryDark.withValues(alpha: 0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis dashboards',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Project ID: $projectId',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              height: 1.5,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceL),
          Wrap(
            spacing: DesignTokens.spaceS,
            runSpacing: DesignTokens.spaceS,
            children: [
              _HeroTag(label: 'Dashboards', value: '$dashboardCount'),
              const _HeroTag(label: 'Scope', value: 'Repository-backed'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String label;
  final String value;

  const _HeroTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final AnalysisDashboard dashboard;
  final VoidCallback onOpen;

  const _DashboardCard({required this.dashboard, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final updatedAt = dashboard.updatedAt == null
        ? 'Unknown'
        : DateFormat.yMMMd().add_jm().format(dashboard.updatedAt!.toLocal());

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spaceL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
            border: Border.all(color: cs.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dashboard.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                        ),
                        if ((dashboard.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            dashboard.description!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.72),
                                  height: 1.55,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceM),
              Wrap(
                spacing: DesignTokens.spaceS,
                runSpacing: DesignTokens.spaceS,
                children: [
                  _InfoPill(label: 'Layout', value: dashboard.layout),
                  _InfoPill(
                    label: 'Widgets',
                    value: '${dashboard.widgets.length}',
                  ),
                  _InfoPill(label: 'Roles', value: '${dashboard.roles.length}'),
                  _InfoPill(label: 'Updated', value: updatedAt),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.78),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashboardDetailsSheet extends ConsumerStatefulWidget {
  final String projectId;
  final AnalysisDashboard dashboard;

  const _DashboardDetailsSheet({
    required this.projectId,
    required this.dashboard,
  });

  @override
  ConsumerState<_DashboardDetailsSheet> createState() =>
      _DashboardDetailsSheetState();
}

class _DashboardDetailsSheetState
    extends ConsumerState<_DashboardDetailsSheet> {
  bool _running = false;

  Future<void> _runBoard(BuildContext context) async {
    setState(() => _running = true);
    try {
      final result = await ref
          .read(analysisDashboardRepositoryProvider)
          .executeBoard(widget.projectId, widget.dashboard.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Board executed: ${result['message'] ?? 'Calculations executed successfully'}',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Board execution failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _running = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(
            DesignTokens.spaceL,
            0,
            DesignTokens.spaceL,
            DesignTokens.spaceL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.dashboard.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                widget.dashboard.slug ?? widget.dashboard.id,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.66),
                ),
              ),
              const SizedBox(height: DesignTokens.spaceM),
              if ((widget.dashboard.description ?? '').isNotEmpty)
                Text(
                  widget.dashboard.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              const SizedBox(height: DesignTokens.spaceL),
              _sectionTitle(context, 'Metadata'),
              const SizedBox(height: DesignTokens.spaceS),
              Wrap(
                spacing: DesignTokens.spaceS,
                runSpacing: DesignTokens.spaceS,
                children: [
                  _InfoPill(label: 'Layout', value: widget.dashboard.layout),
                  _InfoPill(
                    label: 'Widgets',
                    value: '${widget.dashboard.widgets.length}',
                  ),
                  _InfoPill(label: 'Roles', value: '${widget.dashboard.roles.length}'),
                  _InfoPill(
                    label: 'Created',
                    value: _formatDate(widget.dashboard.createdAt),
                  ),
                  _InfoPill(
                    label: 'Updated',
                    value: _formatDate(widget.dashboard.updatedAt),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceL),
              _sectionTitle(context, 'Actions'),
              const SizedBox(height: DesignTokens.spaceS),
              FilledButton.icon(
                onPressed: _running ? null : () => _runBoard(context),
                icon: _running
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: const Text('Run board'),
              ),
              const SizedBox(height: DesignTokens.spaceL),
              _sectionTitle(context, 'Widgets'),
              const SizedBox(height: DesignTokens.spaceS),
              if (widget.dashboard.widgets.isEmpty)
                Text(
                  'No widgets are configured on this dashboard.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                )
              else
                Column(
                  children: widget.dashboard.widgets
                      .map(
                        (widget) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: DesignTokens.spaceS,
                          ),
                          child: _WidgetTile(widget: widget),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat.yMMMd().format(date.toLocal());
  }
}

class _WidgetTile extends StatelessWidget {
  final AnalysisWidget widget;

  const _WidgetTile({required this.widget});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.type} • ${widget.calculationType}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.68),
            ),
          ),
          if (widget.groupByField != null || widget.aggregateField != null) ...[
            const SizedBox(height: 4),
            Text(
              [
                if (widget.groupByField != null)
                  'Group by ${widget.groupByField}',
                if (widget.aggregateField != null)
                  'Aggregate ${widget.aggregateField}',
              ].join(' • '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.68),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String projectId;

  const _EmptyState({required this.projectId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceXL),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No dashboards yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Create an analysis dashboard from the backend or keep this section hidden until dashboards are configured.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: Responsive.pagePadding(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Container(
            padding: const EdgeInsets.all(DesignTokens.spaceXL),
            decoration: BoxDecoration(
              color: cs.errorContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
              border: Border.all(color: cs.error.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Could not load dashboards',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onErrorContainer,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onErrorContainer.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceL),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_outlined),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
