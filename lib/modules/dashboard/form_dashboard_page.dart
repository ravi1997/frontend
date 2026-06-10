import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';

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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 760;
                      final header = Wrap(
                        spacing: DesignTokens.spaceS,
                        runSpacing: DesignTokens.spaceS,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () => context.push(
                              '/projects/${widget.projectId}/forms/${widget.formId}/responses',
                            ),
                            icon: const Icon(Icons.list_alt_outlined),
                            label: const Text('Responses'),
                          ),
                          FilledButton.icon(
                            onPressed: () => context.push(
                              '/projects/${widget.projectId}/forms/${widget.formId}/edit',
                            ),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit form'),
                          ),
                        ],
                      );

                      return isCompact
                          ? Column(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: cs.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: DesignTokens.spaceM),
                                header,
                              ],
                            )
                          : Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.pop(),
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Form dashboard',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: cs.onSurface,
                                      ),
                                ),
                                const Spacer(),
                                header,
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  _HeroCard(
                    projectId: widget.projectId,
                    formId: widget.formId,
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                      border: Border.all(color: cs.outline),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: cs.onSurface,
                      unselectedLabelColor: cs.onSurface.withValues(alpha: 0.55),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: DesignTokens.primarySoft,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Responses'),
                        Tab(text: 'Analytics'),
                        Tab(text: 'Builder'),
                      ],
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 640 : 560,
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
                                '/projects/${widget.projectId}/forms/${widget.formId}/analytics',
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
                                '/projects/${widget.projectId}/forms/${widget.formId}/analytics',
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
                              onPressed: () => context.push(
                                '/projects/${widget.projectId}/forms/${widget.formId}/edit',
                              ),
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
          final isCompact = constraints.maxWidth < 720;
          final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ) ??
              const TextStyle(fontSize: DesignTokens.fontXXL, fontWeight: FontWeight.w800, color: Colors.white);
          final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.5,
              ) ??
              const TextStyle(fontSize: DesignTokens.fontM, color: Colors.white70, height: 1.5);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Form dashboard', style: titleStyle),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'Project ID: $projectId${isCompact ? '\n' : '  '}Form ID: $formId',
                style: bodyStyle,
              ),
              const SizedBox(height: DesignTokens.spaceL),
              Wrap(
                spacing: DesignTokens.spaceS,
                runSpacing: DesignTokens.spaceS,
                children: const [
                  _HeroTag(label: 'Stub', value: 'Analytics and response panels are in progress'),
                  _HeroTag(label: 'Scope', value: 'Project-scoped route'),
                ],
              ),
            ],
          );
        },
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
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
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
        const SizedBox(height: DesignTokens.spaceM),
        Wrap(
          spacing: DesignTokens.spaceS,
          runSpacing: DesignTokens.spaceS,
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}
