import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/modules/dashboard_builder/models/dashboard_canvas_models.dart';
import 'package:frontend/modules/dashboard_builder/repositories/dashboard_builder_repository.dart';

/// Shows all dashboards for a project and allows creating new ones.
/// Embedded inside [ProjectDashboardPage] as a tab or section.
class ProjectDashboardsSection extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDashboardsSection({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDashboardsSection> createState() =>
      _ProjectDashboardsSectionState();
}

class _ProjectDashboardsSectionState
    extends ConsumerState<ProjectDashboardsSection> {
  List<DashboardModel> _dashboards = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ref
          .read(dashboardBuilderRepositoryProvider)
          .listForProject(widget.projectId);
      setState(() {
        _dashboards = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _create() async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'New Dashboard',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Dashboard name*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.of(ctx).pop(true);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final dash = await ref.read(dashboardBuilderRepositoryProvider).create(
            projectId: widget.projectId,
            name: nameCtrl.text.trim(),
            description: descCtrl.text.trim(),
          );
      if (!mounted) return;
      context.push(
        '/projects/${widget.projectId}/dashboards/${dash.id}',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Text(
              'Dashboards',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _create,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('New Dashboard'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Body
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          _ErrorBanner(message: _error!, onRetry: _load)
        else if (_dashboards.isEmpty)
          _EmptyState(onCreate: _create)
        else
          _DashboardGrid(
            dashboards: _dashboards,
            projectId: widget.projectId,
            onRefresh: _load,
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withAlpha((0.5 * 255).round()),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dashboard_outlined, size: 56, color: cs.outlineVariant),
          const SizedBox(height: 16),
          Text(
            'No dashboards yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a free-form canvas dashboard to visualise your analysis results.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create your first dashboard'),
          ),
        ],
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  final List<DashboardModel> dashboards;
  final String projectId;
  final VoidCallback onRefresh;

  const _DashboardGrid({
    required this.dashboards,
    required this.projectId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 4 / 3,
      ),
      itemCount: dashboards.length,
      itemBuilder: (context, i) => _DashboardCard(
        dashboard: dashboards[i],
        projectId: projectId,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _DashboardCard extends ConsumerStatefulWidget {
  final DashboardModel dashboard;
  final String projectId;
  final VoidCallback onRefresh;

  const _DashboardCard({
    required this.dashboard,
    required this.projectId,
    required this.onRefresh,
  });

  @override
  ConsumerState<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends ConsumerState<_DashboardCard> {
  bool _hover = false;

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete dashboard?'),
        content: Text(
            'This will permanently delete "${widget.dashboard.name}". This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref
          .read(dashboardBuilderRepositoryProvider)
          .delete(widget.dashboard.id);
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dash = widget.dashboard;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => context.push(
          '/projects/${widget.projectId}/dashboards/${dash.id}',
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hover ? cs.primary : cs.outlineVariant,
              width: _hover ? 2 : 1,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: cs.primary.withAlpha((0.15 * 255).round()),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.06 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primaryContainer.withAlpha((0.6 * 255).round()),
                        cs.secondaryContainer.withAlpha((0.4 * 255).round()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.dashboard_rounded,
                          size: 40,
                          color: cs.primary.withAlpha((0.5 * 255).round()),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dash.canvas.widgets.length} widget${dash.canvas.widgets.length == 1 ? '' : 's'}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Info section
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dash.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          if (dash.isPublic)
                            Row(
                              children: [
                                Icon(Icons.public_rounded,
                                    size: 10, color: Colors.green[600]),
                                const SizedBox(width: 3),
                                Text(
                                  'Public',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded,
                          size: 18, color: cs.onSurfaceVariant),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Open editor'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (action) {
                        if (action == 'open') {
                          context.push(
                            '/projects/${widget.projectId}/dashboards/${dash.id}',
                          );
                        } else if (action == 'delete') {
                          _delete();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
