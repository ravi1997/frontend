import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/entities/project_summary.dart';

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

    final api = ref.read(apiClientProvider);
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
    await ref.read(dashboardControllerProvider.notifier).refresh();
  }

  Future<void> _archiveProject(ProjectSummary project) async {
    final api = ref.read(apiClientProvider);
    await api.delete(ApiEndpoints.deleteProject(project.id));
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

    final api = ref.read(apiClientProvider);
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
    await ref.read(dashboardControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Redirecting...'));
          }

          final dashboardState = ref.watch(dashboardControllerProvider);
          final data = dashboardState.asData?.value;
          final projects = _filteredProjects(data?.projects ?? const []);

          return Column(
            children: [
              _TopBar(
                userName: user.username,
                userEmail: user.email,
                onLogout: () =>
                    ref.read(authControllerProvider.notifier).logout(),
                onRefresh: () =>
                    ref.read(dashboardControllerProvider.notifier).refresh(),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(dashboardControllerProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
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
                              error: (error, _) => _ErrorBanner(
                                error: error.toString(),
                                onRetry: () => ref
                                    .read(dashboardControllerProvider.notifier)
                                    .refresh(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _ProjectsToolbar(
                              searchController: _searchController,
                              currentFilter: _filter,
                              onFilterChanged: (value) {
                                setState(() => _filter = value);
                              },
                              onSearchChanged: (_) => setState(() {}),
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
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 420,
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
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  List<ProjectSummary> _filteredProjects(List<ProjectSummary> projects) {
    final query = _searchController.text.trim().toLowerCase();
    return projects.where((project) {
      final matchesQuery =
          query.isEmpty ||
          project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query);
      final matchesFilter =
          _filter == 'All' ||
          project.status.toLowerCase() == _filter.toLowerCase();
      return matchesQuery && matchesFilter;
    }).toList();
  }
}

class _TopBar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final VoidCallback onRefresh;

  const _TopBar({
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Text(
            'RIDP Form Platform',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Refresh'),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                userName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                userEmail,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onCreateProject;
  final VoidCallback onRefresh;

  const _HeroCard({required this.onCreateProject, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects dashboard',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFBFDBFE),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'See every project the API knows about, then create or extend them from one place.',
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'The dashboard now reads project data from /projects and uses the project form endpoint when you add a form.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFFE2E8F0),
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
              ),
            ],
          ),
        ],
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
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Projects',
            value: projectsCount.toString(),
            icon: Icons.folder_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Forms',
            value: formsCount.toString(),
            icon: Icons.description_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Active',
            value: activeCount.toString(),
            icon: Icons.flash_on_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Responses',
            value: responseCount.toString(),
            icon: Icons.mark_chat_read_outlined,
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0369A1)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search projects',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
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
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: onCreateProject,
          icon: const Icon(Icons.add),
          label: const Text('New project'),
        ),
      ],
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
    final color = switch (project.status.toLowerCase()) {
      'active' => const Color(0xFF16A34A),
      'live' => const Color(0xFF2563EB),
      'archived' => const Color(0xFF6B7280),
      _ => const Color(0xFFF59E0B),
    };

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      project.status,
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
                  fontSize: 13,
                  height: 1.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Pill(label: 'Forms', value: project.forms.toString()),
                  _Pill(label: 'Members', value: project.members.toString()),
                  _Pill(
                    label: 'Responses',
                    value: project.responses.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.updatedAt == null
                          ? 'Updated recently'
                          : 'Updated ${project.updatedAt}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(error)),
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
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
