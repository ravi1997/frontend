import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FormDashboardPage extends ConsumerStatefulWidget {
  final String projectId;
  final String formId;

  const FormDashboardPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

  @override
  ConsumerState<FormDashboardPage> createState() => _FormDashboardPageState();
}

class _FormDashboardPageState extends ConsumerState<FormDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
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
                        'Form dashboard',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () =>
                            context.push('/builder/${widget.formId}'),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit form'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _HeroCard(projectId: widget.projectId, formId: widget.formId),
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
                        Tab(text: 'Responses'),
                        Tab(text: 'Analytics'),
                        Tab(text: 'Builder'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 560,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _FormDashboardTab(
                          title: 'Overview',
                          message:
                              'Project-scoped form details will appear here, along with status, publishing state, and quick actions.',
                          actions: [
                            _DashboardAction(
                              label: 'Open responses',
                              icon: Icons.list_alt_outlined,
                              onPressed: () => context.push(
                                '/projects/${widget.projectId}/forms/${widget.formId}/responses',
                              ),
                            ),
                            _DashboardAction(
                              label: 'View analytics',
                              icon: Icons.show_chart_outlined,
                              onPressed: () => context.push(
                                '/forms/${widget.formId}/analytics',
                              ),
                            ),
                          ],
                        ),
                        _FormDashboardTab(
                          title: 'Responses',
                          message:
                              'This tab is a shortcut to the submissions dashboard for the selected form.',
                          actions: [
                            _DashboardAction(
                              label: 'Open responses',
                              icon: Icons.list_alt_outlined,
                              onPressed: () => context.push(
                                '/projects/${widget.projectId}/forms/${widget.formId}/responses',
                              ),
                            ),
                          ],
                        ),
                        _FormDashboardTab(
                          title: 'Analytics',
                          message:
                              'Use this area to inspect response trends, completion rates, and submission activity.',
                          actions: [
                            _DashboardAction(
                              label: 'Open analytics',
                              icon: Icons.analytics_outlined,
                              onPressed: () => context.push(
                                '/forms/${widget.formId}/analytics',
                              ),
                            ),
                          ],
                        ),
                        _FormDashboardTab(
                          title: 'Builder',
                          message:
                              'Jump into the builder when you are ready to edit sections, questions, and styling.',
                          actions: [
                            _DashboardAction(
                              label: 'Edit form',
                              icon: Icons.edit_outlined,
                              onPressed: () =>
                                  context.push('/builder/${widget.formId}'),
                            ),
                          ],
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

class _HeroCard extends StatelessWidget {
  final String projectId;
  final String formId;

  const _HeroCard({required this.projectId, required this.formId});

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
            'Form dashboard',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Project ID: $projectId\nForm ID: $formId',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFFE2E8F0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormDashboardTab extends StatelessWidget {
  final String title;
  final String message;
  final List<_DashboardAction> actions;

  const _FormDashboardTab({
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(title: title, body: message),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions
              .map(
                (action) => FilledButton.icon(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon),
                  label: Text(action.label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DashboardAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _DashboardAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String body;

  const _SectionCard({required this.title, required this.body});

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
