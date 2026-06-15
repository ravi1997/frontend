import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/dashboard/dashboard_controller.dart';
import 'package:frontend/modules/dashboard/dashboard_models.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final helpController = TextEditingController();

    final created = await showDialog<ProjectSummary>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create project'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Project title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: helpController,
                decoration: const InputDecoration(labelText: 'Help text'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              Navigator.of(context).pop(
                ProjectSummary(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  description: descController.text.trim(),
                  helpText: helpController.text.trim(),
                  status: 'draft',
                  forms: 0,
                  responses: 0,
                  members: 1,
                  collaborators: const [],
                  tags: const [],
                  updatedAt: DateTime.now().toIso8601String(),
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    titleController.dispose();
    descController.dispose();
    helpController.dispose();

    if (created == null) return;

    final api = ref.read(dioProvider);
    await api.post(
      ApiEndpoints.createProject,
      data: {
        'title': created.title,
        'description': created.description,
        'help_text': created.helpText ?? '',
        'status': created.status,
        'organization_id': ref
            .read(authControllerProvider)
            .value
            ?.organizationId,
        'sub_projects': const [],
        'forms': const [],
        'tags': created.tags,
        'triggers': const [],
      },
    );
    if (!mounted) return;
    await ref.read(dashboardControllerProvider.notifier).refresh();
  }

  Future<void> _archiveProject(ProjectSummary project) async {
    final api = ref.read(dioProvider);
    await api.delete(ApiEndpoints.deleteProject(project.id));
    if (!mounted) return;
    await ref.read(dashboardControllerProvider.notifier).refresh();
  }

  Future<void> _addForm(ProjectSummary project) async {
    final formTitleController = TextEditingController();

    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add form to ${project.title}'),
        content: TextField(
          controller: formTitleController,
          decoration: const InputDecoration(labelText: 'Form title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = formTitleController.text.trim();
              if (value.isEmpty) return;
              Navigator.of(context).pop(value);
            },
            child: const Text('Create form'),
          ),
        ],
      ),
    );

    formTitleController.dispose();

    if (title == null || title.isEmpty) return;

    final api = ref.read(dioProvider);
    await api.post(
      ApiEndpoints.createProjectForm(project.id),
      data: {
        'title': title,
        'slug': title.toLowerCase().replaceAll(' ', '-'),
        'description': 'Form created from dashboard',
        'help_text': 'Created inside ${project.title}',
        'status': 'draft',
        'ui_type': 'flex',
        'supported_languages': const ['en'],
        'default_language': 'en',
        'tags': const [],
        'is_public': false,
        'is_template': false,
        'sections': const [],
      },
    );
    if (!mounted) return;
    await ref.read(dashboardControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Redirecting...'));
          }

          final dashboardState = ref.watch(dashboardControllerProvider);
          final data = dashboardState.asData?.value;
          final searchQuery = ref.watch(dashboardSearchQueryProvider);
          final projects = _filteredProjects(
            data?.projects ?? const [],
            searchQuery,
          );
          final padding = Responsive.pagePadding(context);

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(dashboardControllerProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCard(
                        onCreateProject: _createProject,
                        onRefresh: () => ref
                            .read(dashboardControllerProvider.notifier)
                            .refresh(),
                      ),
                      const SizedBox(height: 24),
                      dashboardState.when(
                        data: (data) => _StatsRow(
                          projectsCount: data.projects.length,
                          formsCount: data.stats.totalForms,
                          activeCount: data.stats.activeForms,
                          responseCount: data.stats.totalResponses,
                        ),
                        loading: () => const _StatsSkeleton(),
                        error: (error, _) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _ErrorBanner(
                            error: error.toString(),
                            onRetry: () => ref
                                .read(dashboardControllerProvider.notifier)
                                .refresh(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ProjectsToolbar(
                        searchController: _searchController,
                        currentFilter: _filter,
                        onFilterChanged: (value) {
                          setState(() => _filter = value);
                        },
                        onSearchChanged: (value) {
                          ref
                              .read(dashboardSearchQueryProvider.notifier)
                              .setQuery(value);
                        },
                        onCreateProject: _createProject,
                      ),
                      const SizedBox(height: 16),
                      if (dashboardState.isLoading)
                        const _ProjectsSkeleton()
                      else if (projects.isEmpty)
                        const _EmptyState(
                          title: 'No projects yet',
                          subtitle:
                              'Create your first project to group forms and workflows.',
                        )
                      else
                        LayoutBuilder(
                          builder: (ctx, constraints) {
                            final cols = Responsive.cardColumns(ctx);
                            final extent = cols == 1
                                ? constraints.maxWidth
                                : (constraints.maxWidth - 16 * (cols - 1)) /
                                      cols;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: extent.clamp(200, 480),
                                    mainAxisExtent: 248,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: projects.length,
                              itemBuilder: (context, index) {
                                final project = projects[index];
                                return _ProjectCard(
                                  project: project,
                                  onTap: () =>
                                      context.push('/projects/${project.id}'),
                                  onAddForm: () => _addForm(project),
                                  onArchive: () => _archiveProject(project),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateWidget(
          message: 'Failed to load user profile.',
          error: error.toString(),
          onRetry: () => ref.refresh(authControllerProvider),
        ),
      ),
    );
  }

  List<ProjectSummary> _filteredProjects(
    List<ProjectSummary> projects,
    String query,
  ) {
    final search = query.trim().toLowerCase();
    return projects.where((project) {
      final matchesQuery =
          search.isEmpty ||
          project.title.toLowerCase().contains(search) ||
          project.description.toLowerCase().contains(search);
      final matchesFilter =
          _filter == 'All' ||
          project.status.toLowerCase() == _filter.toLowerCase();
      return matchesQuery && matchesFilter;
    }).toList();
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onCreateProject;
  final VoidCallback onRefresh;

  const _HeroCard({required this.onCreateProject, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projects dashboard',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.78),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'See every project the API knows about, then create or extend them from one place.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'The dashboard now reads project data from /projects and uses the project form endpoint when you add a form.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: onCreateProject,
                    icon: const Icon(Icons.add),
                    label: const Text('Create project'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.onPrimary,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                  ),
                ],
              ),
              if (compact) const SizedBox(height: 4),
            ],
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int projectsCount;
  final int formsCount;
  final int activeCount;
  final int responseCount;

  const _StatsRow({
    required this.projectsCount,
    required this.formsCount,
    required this.activeCount,
    required this.responseCount,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'Projects', value: projectsCount, icon: Icons.folder_outlined),
      (label: 'Forms', value: formsCount, icon: Icons.description_outlined),
      (label: 'Active', value: activeCount, icon: Icons.flash_on_outlined),
      (
        label: 'Responses',
        value: responseCount,
        icon: Icons.mark_chat_read_outlined,
      ),
    ];
    final cols = Responsive.statColumns(context);
    // On mobile/tablet show as a 2×2 wrap; on laptop/desktop show as single row.
    if (cols == 2) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items
            .map(
              (e) => SizedBox(
                width:
                    (MediaQuery.sizeOf(context).width -
                        Responsive.pageHPad(context) * 2 -
                        12) /
                    2,
                child: _StatCard(
                  label: e.label,
                  value: e.value.toString(),
                  icon: e.icon,
                ),
              ),
            )
            .toList(),
      );
    }
    return Row(
      children: items
          .expand(
            (e) => [
              Expanded(
                child: _StatCard(
                  label: e.label,
                  value: e.value.toString(),
                  icon: e.icon,
                ),
              ),
              if (e != items.last) const SizedBox(width: 16),
            ],
          )
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: DesignTokens.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            child: Icon(icon, color: DesignTokens.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: DesignTokens.fontXL,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: DesignTokens.fontS,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectsToolbar extends StatelessWidget {
  final TextEditingController searchController;
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreateProject;

  const _ProjectsToolbar({
    required this.searchController,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onCreateProject,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;

        final filterDropdown = DropdownButton<String>(
          value: currentFilter,
          items:
              const ['All', 'draft', 'Active', 'Planning', 'Live', 'Archived']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) onFilterChanged(value);
          },
        );

        final createButton = FilledButton.icon(
          onPressed: onCreateProject,
          icon: const Icon(Icons.add),
          label: const Text('New project'),
        );

        final searchField = TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search projects',
            prefixIcon: Icon(Icons.search),
          ),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [filterDropdown, createButton],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: searchField),
            const SizedBox(width: 12),
            filterDropdown,
            const SizedBox(width: 12),
            createButton,
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectSummary project;
  final VoidCallback onTap;
  final VoidCallback onAddForm;
  final VoidCallback onArchive;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onAddForm,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = switch (project.status.toLowerCase()) {
      'active' => DesignTokens.success,
      'live' => DesignTokens.info,
      'archived' => DesignTokens.darkTextMuted,
      _ => DesignTokens.warning,
    };

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spaceM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            border: Border.all(color: cs.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontL,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusFull,
                      ),
                    ),
                    child: Text(
                      project.status,
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontXS,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                project.description.isEmpty
                    ? 'No description yet'
                    : project.description,
                style: GoogleFonts.inter(
                  fontSize: DesignTokens.fontS,
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(label: 'Forms', value: project.forms.toString()),
                  _Pill(label: 'Members', value: project.members.toString()),
                  _Pill(
                    label: 'Responses',
                    value: project.responses.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.updatedAt == null
                          ? 'Updated recently'
                          : 'Updated ${project.updatedAt}',
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontXS,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onAddForm,
                    child: const Text('Add form'),
                  ),
                  TextButton(
                    onPressed: onArchive,
                    child: const Text('Archive'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String value;

  const _Pill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceXS + 2,
      ),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.inter(
          fontSize: DesignTokens.fontXS,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: DesignTokens.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: DesignTokens.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(error)),
          const SizedBox(width: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.statColumns(context);

    if (cols == 2) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _SkeletonBox(height: 92),
              _SkeletonBox(height: 92),
              _SkeletonBox(height: 92),
              _SkeletonBox(height: 92),
            ].map((box) => SizedBox(width: width, child: box)).toList(),
          );
        },
      );
    }

    return const Row(
      children: [
        Expanded(child: _SkeletonBox(height: 92)),
        SizedBox(width: 16),
        Expanded(child: _SkeletonBox(height: 92)),
        SizedBox(width: 16),
        Expanded(child: _SkeletonBox(height: 92)),
        SizedBox(width: 16),
        Expanded(child: _SkeletonBox(height: 92)),
      ],
    );
  }
}

class _ProjectsSkeleton extends StatelessWidget {
  const _ProjectsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonBox(height: 92),
        SizedBox(height: 16),
        _SkeletonBox(height: 248),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;

  const _SkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: cs.outline),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 48,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: DesignTokens.fontBase,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: DesignTokens.fontS,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
