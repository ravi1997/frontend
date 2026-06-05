import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
import 'package:frontend/core/networking/api_client_wrapper.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/modules/auth/auth_controller.dart';
import 'package:frontend/modules/dashboard/dashboard_models.dart';

class ProjectDashboardPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDashboardPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDashboardPage> createState() =>
      _ProjectDashboardPageState();
}

class _ProjectDashboardPageState extends ConsumerState<ProjectDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  Map<String, dynamic>? _project;
  List<dynamic> _forms = const [];
  bool _loading = true;
  bool _formsLoading = true;
  bool _memberDataMismatch = false;
  String? _error;
  String? _formsError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProject();
    _loadForms();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProject() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(ApiEndpoints.getProject(widget.projectId));
      final data = response.data;
      Map<String, dynamic> projectData;
      if (data is Map<String, dynamic>) {
        projectData = data;
      } else if (data is Map) {
        projectData = Map<String, dynamic>.from(data);
      } else {
        projectData = {};
      }

      _project = projectData;

      // Sanity check for member data shape
      final rawMembers = projectData['members'] ?? projectData['collaborators'];
      _memberDataMismatch = rawMembers != null && rawMembers is! List;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadForms() async {
    setState(() {
      _formsLoading = true;
      _formsError = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(
        ApiEndpoints.listProjectForms(widget.projectId),
      );
      final data = response.data;
      if (data is List) {
        _forms = data;
      } else if (data is Map && data['items'] is List) {
        _forms = List<dynamic>.from(data['items'] as List);
      } else {
        _forms = const [];
      }
    } catch (e) {
      _formsError = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _formsLoading = false;
        });
      }
    }
  }

  Future<void> _refreshAll() async {
    await _loadProject();
    await _loadForms();
  }

  Map<String, int> _formStatusCounts() {
    final counts = <String, int>{};
    for (final item in _forms) {
      final map = item is Map<String, dynamic>
          ? item
          : Map<String, dynamic>.from(item as Map);
      final status = map['status']?.toString().toLowerCase() ?? 'draft';
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  List<Map<String, String>> _buildActivityItems(String projectTitle) {
    final items = <Map<String, String>>[
      {
        'title': 'Project opened',
        'subtitle': 'You are viewing $projectTitle',
        'time': 'Now',
      },
      {
        'title': 'Forms loaded',
        'subtitle': '${_forms.length} forms available in this project',
        'time': _formsLoading ? '...' : 'Live',
      },
    ];

    if (_project?['updated_at'] != null) {
      items.add({
        'title': 'Project updated',
        'subtitle': _project!['updated_at'].toString(),
        'time': 'Recent',
      });
    }

    return items;
  }

  List<Map<String, dynamic>> _buildRecentForms() {
    return _forms
        .map(
          (item) => item is Map<String, dynamic>
              ? item
              : Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  List<String> _extractProjectMembers() {
    if (_project == null) return [];
    final summary = ProjectSummary.fromJson(_project!);
    return summary.collaborators;
  }

  Future<void> _editProject() async {
    final titleController = TextEditingController(
      text: _project?['title']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: _project?['description']?.toString() ?? '',
    );
    final helpController = TextEditingController(
      text: _project?['help_text']?.toString() ?? '',
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit project'),
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
                controller: descriptionController,
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
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (shouldSave != true) return;

    final api = ref.read(apiClientProvider);
    await api.put(
      ApiEndpoints.updateProject(widget.projectId),
      data: {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'help_text': helpController.text.trim(),
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    helpController.dispose();

    await _loadProject();
  }

  Future<void> _archiveProject() async {
    final api = ref.read(apiClientProvider);
    await api.delete(ApiEndpoints.deleteProject(widget.projectId));
    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleManagementAction(String value) async {
    switch (value) {
      case 'edit':
        await _editProject();
        break;
      case 'form':
        await _createFormFromProject();
        break;
      case 'refresh':
        await _refreshAll();
        break;
      case 'archive':
        await _archiveProject();
        break;
    }
  }

  Future<void> _createFormFromProject() async {
    final formTitleController = TextEditingController();
    final slugController = TextEditingController();
    final descriptionController = TextEditingController();
    final helpTextController = TextEditingController();
    final tagInputController = TextEditingController();
    final languageInputController = TextEditingController();
    final defaultLanguageController = TextEditingController(text: 'en');
    final tags = <String>['intake'];
    final languages = <String>['en', 'hi'];
    bool isPublic = false;
    bool isTemplate = false;
    String uiType = 'flex';

    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Add form to ${_project?['title'] ?? 'project'}'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: formTitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) {
                      if (slugController.text.isEmpty) {
                        slugController.text = value
                            .trim()
                            .toLowerCase()
                            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
                            .replaceAll(RegExp(r'^-|-$'), '');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: slugController,
                    decoration: const InputDecoration(labelText: 'Slug'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: helpTextController,
                    decoration: const InputDecoration(labelText: 'Help text'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _ChipInputField(
                    label: 'Supported languages',
                    chips: languages,
                    controller: languageInputController,
                    hintText: 'en',
                    onAdd: (value) {
                      final language = value.trim();
                      if (language.isEmpty || languages.contains(language)) {
                        return;
                      }
                      setModalState(() => languages.add(language));
                    },
                    onDelete: (value) {
                      setModalState(() => languages.remove(value));
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: defaultLanguageController,
                    decoration: const InputDecoration(
                      labelText: 'Default language',
                      hintText: 'en',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: uiType,
                    decoration: const InputDecoration(labelText: 'UI type'),
                    items: const [
                      DropdownMenuItem(value: 'flex', child: Text('Flex')),
                      DropdownMenuItem(value: 'grid', child: Text('Grid')),
                      DropdownMenuItem(value: 'wizard', child: Text('Wizard')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() => uiType = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ChipInputField(
                    label: 'Tags',
                    chips: tags,
                    controller: tagInputController,
                    hintText: 'intake',
                    onAdd: (value) {
                      final tag = value.trim();
                      if (tag.isEmpty || tags.contains(tag)) {
                        return;
                      }
                      setModalState(() => tags.add(tag));
                    },
                    onDelete: (value) {
                      setModalState(() => tags.remove(value));
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isPublic,
                    title: const Text('Public form'),
                    onChanged: (value) => setModalState(() => isPublic = value),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isTemplate,
                    title: const Text('Save as template'),
                    onChanged: (value) =>
                        setModalState(() => isTemplate = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = formTitleController.text.trim();
                if (title.isEmpty) return;
                final slug = slugController.text.trim().isEmpty
                    ? title
                          .toLowerCase()
                          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
                          .replaceAll(RegExp(r'^-|-$'), '')
                    : slugController.text.trim();
                Navigator.of(dialogContext).pop({
                  'title': title,
                  'slug': slug,
                  'description': descriptionController.text.trim(),
                  'help_text': helpTextController.text.trim(),
                  'status': 'draft',
                  'ui_type': uiType,
                  'supported_languages': languages,
                  'default_language': defaultLanguageController.text.trim(),
                  'tags': tags,
                  'is_public': isPublic,
                  'is_template': isTemplate,
                  'sections': const [],
                  'created_by': ref.read(authControllerProvider).value?.id,
                });
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );

    if (payload == null) return;

    final api = ref.read(apiClientProvider);
    final response = await api.post(
      ApiEndpoints.createProjectForm(widget.projectId),
      data: payload,
    );
    await _loadForms();

    final data = response.data;
    String? formId;
    if (data is Map<String, dynamic>) {
      formId = data['id']?.toString() ?? data['_id']?.toString();
      final nestedData = data['data'];
      if (formId == null && nestedData is Map) {
        formId = nestedData['id']?.toString() ?? nestedData['_id']?.toString();
      }
    } else if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      formId = map['id']?.toString() ?? map['_id']?.toString();
      final nestedData = map['data'];
      if (formId == null && nestedData is Map) {
        final nestedMap = Map<String, dynamic>.from(nestedData);
        formId = nestedMap['id']?.toString() ?? nestedMap['_id']?.toString();
      }
    }

    if (formId != null && formId.isNotEmpty && mounted) {
      context.push('/projects/${widget.projectId}/forms/$formId');
    }
  }

  Future<void> _copyShareLink() async {
    final link = '${Uri.base.origin}/projects/${widget.projectId}';
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project share link copied to clipboard.'),
        ),
      );
    }
  }

  Future<void> _inviteMember() async {
    final controller = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Invite member'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Email address',
            hintText: 'name@company.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Send invite'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (email == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invite flow is ready for $email, but the backend invite API is not wired yet.',
        ),
      ),
    );
  }

  Future<void> _manageAccess() async {
    if (!mounted) return;
    final members = _extractProjectMembers();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Access overview',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Project status: ${_project?['status'] ?? 'draft'}',
                  style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                if (members.isEmpty)
                  Text(
                    'No collaborators were returned by the API.',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: members
                        .map((member) => Chip(label: Text(member)))
                        .toList(),
                  ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _inviteMember();
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Invite member'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _project?['title']?.toString() ?? 'Project dashboard';
    final description =
        _project?['description']?.toString() ?? 'No project details available.';
    final status = _project?['status']?.toString() ?? 'draft';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Scaffold(
                body: ErrorStateWidget(
                  title: 'Failed to load project',
                  message: 'We couldn\'t load the project details from the server.',
                  error: _error!,
                  onBack: () => context.pop(),
                  onRetry: _loadProject,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Project dashboard',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: _refreshAll,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: _createFormFromProject,
                              icon: const Icon(Icons.add),
                              label: const Text('New form'),
                            ),
                            const SizedBox(width: 12),
                            PopupMenuButton<String>(
                              onSelected: _handleManagementAction,
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit project'),
                                ),
                                PopupMenuItem(
                                  value: 'form',
                                  child: Text('Add form'),
                                ),
                                PopupMenuItem(
                                  value: 'refresh',
                                  child: Text('Refresh'),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 'archive',
                                  child: Text('Archive project'),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111827),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Manage',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
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
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                description,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: const Color(0xFFE2E8F0),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _StatusChip(
                                    label: 'Project ID',
                                    value: widget.projectId,
                                  ),
                                  _StatusChip(label: 'Status', value: status),
                                  _StatusChip(
                                    label: 'Forms',
                                    value: _formsLoading
                                        ? 'Loading...'
                                        : _forms.length.toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _HeroActionButton(
                                    icon: Icons.edit_outlined,
                                    label: 'Edit project',
                                    onPressed: _editProject,
                                  ),
                                  _HeroActionButton(
                                    icon: Icons.add_circle_outline,
                                    label: 'Create form',
                                    onPressed: _createFormFromProject,
                                  ),
                                  _HeroActionButton(
                                    icon:
                                        Icons.settings_backup_restore_outlined,
                                    label: 'Refresh',
                                    onPressed: _refreshAll,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _InsightCard(
                                title: 'Forms',
                                value: _formsLoading
                                    ? '--'
                                    : _forms.length.toString(),
                                subtitle: 'Forms inside this project',
                                icon: Icons.description_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InsightCard(
                                title: 'State',
                                value: status,
                                subtitle: 'Current project status',
                                icon: Icons.flag_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InsightCard(
                                title: 'Actions',
                                value: '5',
                                subtitle: 'Quick actions available',
                                icon: Icons.tune_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InsightCard(
                                title: 'Members',
                                value: _extractProjectMembers().isEmpty
                                    ? '0'
                                    : _extractProjectMembers().length
                                          .toString(),
                                subtitle: 'Visible collaborators',
                                icon: Icons.group_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InsightCard(
                                title: 'Updated',
                                value:
                                    _project?['updated_at']?.toString() ??
                                    'Recent',
                                subtitle: 'Last project activity',
                                icon: Icons.schedule_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _InsightCard(
                                title: 'Access',
                                value: 'Open',
                                subtitle: 'Project permissions',
                                icon: Icons.verified_user_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _SectionCard(
                                title: 'Forms by status',
                                bodyWidget: _FormsBreakdown(
                                  counts: _formStatusCounts(),
                                  loading: _formsLoading,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SectionCard(
                                title: 'Activity timeline',
                                bodyWidget: _ActivityTimeline(
                                  items: _buildActivityItems(title),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _SectionCard(
                          title: 'Members & Access',
                          bodyWidget: _MembersAccessPanel(
                            members: _extractProjectMembers(),
                            projectId: widget.projectId,
                            projectStatus: status,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: const Color(0xFF0F172A),
                            unselectedLabelColor: const Color(0xFF64748B),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Forms'),
                              Tab(text: 'Members'),
                              Tab(text: 'Analytics'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 520,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _OverviewTab(
                                projectId: widget.projectId,
                                title: title,
                                description: description,
                                status: status,
                              ),
                              _FormsTab(
                                projectId: widget.projectId,
                                forms: _forms,
                                loading: _formsLoading,
                                error: _formsError,
                                onRetry: _loadForms,
                              ),
                              _MembersTab(
                                members: _extractProjectMembers(),
                                hasMismatch: _memberDataMismatch,
                                onInvite: _inviteMember,
                                onManageAccess: _manageAccess,
                                onCopyShareLink: _copyShareLink,
                              ),
                              _AnalyticsTab(
                                projectId: widget.projectId,
                                forms: _buildRecentForms(),
                                statusCounts: _formStatusCounts(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final String projectId;
  final String title;
  final String description;
  final String status;

  const _OverviewTab({
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(title: 'Project summary', body: description),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'What you can do here',
          body:
              'View project forms, manage members, and add project-level analytics later.',
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Metadata',
          body: 'Project ID: $projectId\nStatus: $status\nTitle: $title',
        ),
      ],
    );
  }
}

class _FormsTab extends StatelessWidget {
  final String projectId;
  final List<dynamic> forms;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;

  const _FormsTab({
    required this.projectId,
    required this.forms,
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return _TabMessage(
        title: 'Could not load forms',
        message: error!,
        actionLabel: 'Retry',
        onAction: onRetry,
      );
    }
    if (forms.isEmpty) {
      return const _TabMessage(
        title: 'No forms yet',
        message: 'Create a form inside this project to start collecting data.',
      );
    }

    return ListView.separated(
      itemCount: forms.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final form = forms[index];
        final map = form is Map<String, dynamic>
            ? form
            : Map<String, dynamic>.from(form as Map);
        final formTitle = map['title']?.toString() ?? 'Untitled form';
        final formStatus = map['status']?.toString() ?? 'draft';
        final formId = map['id']?.toString() ?? map['_id']?.toString() ?? '';

        return _ListTileCard(
          title: formTitle,
          subtitle: 'Status: $formStatus',
          trailing: formId.isEmpty ? null : Text(formId),
          onTap: formId.isEmpty
              ? null
              : () => context.push('/projects/$projectId/forms/$formId'),
        );
      },
    );
  }
}

class _MembersTab extends StatelessWidget {
  final List<String> members;
  final bool hasMismatch;
  final VoidCallback onInvite;
  final VoidCallback onManageAccess;
  final VoidCallback onCopyShareLink;

  const _MembersTab({
    required this.members,
    this.hasMismatch = false,
    required this.onInvite,
    required this.onManageAccess,
    required this.onCopyShareLink,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'Members & access',
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: onInvite,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Invite member'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onManageAccess,
                    icon: const Icon(Icons.security_outlined),
                    label: const Text('Manage access'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onCopyShareLink,
                    icon: const Icon(Icons.link_outlined),
                    label: const Text('Copy share link'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (hasMismatch)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.amber.shade800, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'The collaborator data from the API has an unexpected format. Showing a simplified view.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (members.isEmpty)
                Text(
                  'No collaborators found yet. Teammates added here will be able to edit or view this project.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: members
                      .map(
                        (member) => Chip(
                          label: Text(member),
                          avatar: const Icon(Icons.person, size: 18),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnalyticsTab extends StatelessWidget {
  final String projectId;
  final List<Map<String, dynamic>> forms;
  final Map<String, int> statusCounts;

  const _AnalyticsTab({
    required this.projectId,
    required this.forms,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = statusCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      children: [
        _SectionCard(
          title: 'Forms trend',
          bodyWidget: _FormsTrendChart(
            counts: statusCounts,
            total: forms.length,
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Recent forms',
          bodyWidget: forms.isEmpty
              ? const _TabMessage(
                  title: 'No forms yet',
                  message: 'Create a form to start seeing project activity.',
                )
              : Column(
                  children: forms
                      .take(5)
                      .map(
                        (form) =>
                            _RecentFormTile(form: form, projectId: projectId),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Status snapshot',
          bodyWidget: ordered.isEmpty
              ? const Text('No status data available yet.')
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ordered
                      .map(
                        (entry) => _MiniStatRow(
                          label: entry.key,
                          value: entry.value.toString(),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _TabMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _TabMessage({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ListTileCard({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF0369A1),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _HeroActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0369A1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatusChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? bodyWidget;
  final String body;

  const _SectionCard({required this.title, this.body = '', this.bodyWidget});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          if (bodyWidget != null)
            bodyWidget!
          else
            Text(
              body,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: const Color(0xFF64748B),
              ),
            ),
        ],
      ),
    );
  }
}

class _FormsBreakdown extends StatelessWidget {
  final Map<String, int> counts;
  final bool loading;

  const _FormsBreakdown({required this.counts, required this.loading});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (counts.isEmpty) {
      return Text(
        'No forms have been created for this project yet.',
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF64748B)),
      );
    }

    final ordered = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: ordered
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MiniStatRow(
                label: entry.key,
                value: entry.value.toString(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActivityTimeline extends StatelessWidget {
  final List<Map<String, String>> items;

  const _ActivityTimeline({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _TimelineItem(
                title: item['title'] ?? '',
                subtitle: item['subtitle'] ?? '',
                time: item['time'] ?? '',
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MembersAccessPanel extends StatelessWidget {
  final List<String> members;
  final String projectId;
  final String projectStatus;

  const _MembersAccessPanel({
    required this.members,
    required this.projectId,
    required this.projectStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Use the Members tab to invite collaborators.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Invite member'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Open access management from the Members tab.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.security_outlined),
              label: const Text('Manage access'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: '${Uri.base.origin}/projects/$projectId'),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied.')),
                  );
                }
              },
              icon: const Icon(Icons.link_outlined),
              label: const Text('Copy share link'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Project status: $projectStatus',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        if (members.isEmpty)
          Text(
            'No member list was returned by the API. You can still manage access once the backend exposes collaborators.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: members
                .map(
                  (member) => Chip(
                    label: Text(member),
                    avatar: const Icon(Icons.person, size: 18),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF1D4ED8),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStatRow extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF334155),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> chips;
  final TextEditingController controller;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onDelete;

  const _ChipInputField({
    required this.label,
    required this.chips,
    required this.controller,
    required this.onAdd,
    required this.onDelete,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                onAdd(value);
                controller.clear();
              },
              icon: const Icon(Icons.add),
            ),
          ),
          onSubmitted: (value) {
            final trimmed = value.trim();
            if (trimmed.isEmpty) return;
            onAdd(trimmed);
            controller.clear();
          },
        ),
        const SizedBox(height: 10),
        if (chips.isEmpty)
          Text(
            'No $label added yet.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (value) => InputChip(
                    label: Text(value),
                    onDeleted: () => onDelete(value),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _FormsTrendChart extends StatelessWidget {
  final Map<String, int> counts;
  final int total;

  const _FormsTrendChart({required this.counts, required this.total});

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No chart data yet.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF64748B),
          ),
        ),
      );
    }

    final ordered = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total forms: $total',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ...ordered.map((entry) {
          final fraction = total == 0 ? 0.0 : entry.value / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(entry.value.toString()),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _RecentFormTile extends StatelessWidget {
  final Map<String, dynamic> form;
  final String projectId;

  const _RecentFormTile({required this.form, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final formId = form['id']?.toString() ?? form['_id']?.toString() ?? '';
    final title = form['title']?.toString() ?? 'Untitled form';
    final status = form['status']?.toString() ?? 'draft';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: formId.isEmpty
            ? null
            : () => context.push('/projects/$projectId/forms/$formId'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(Icons.description_outlined, color: Color(0xFF0369A1)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $status',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (formId.isNotEmpty)
                IconButton(
                  onPressed: () =>
                      context.push('/projects/$projectId/forms/$formId'),
                  icon: const Icon(Icons.chevron_right),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// _ErrorState was replaced by global ErrorStateWidget
