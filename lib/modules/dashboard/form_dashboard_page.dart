import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/shared/models/form_models.dart';

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

class _FormDashboardPageState extends ConsumerState<FormDashboardPage> {
  late Future<BuilderForm> _formFuture;

  @override
  void initState() {
    super.initState();
    _formFuture = _loadForm();
  }

  Future<BuilderForm> _loadForm() {
    return ref
        .read(formBuilderRepositoryProvider)
        .getForm(widget.projectId, widget.formId);
  }

  @override
  Widget build(BuildContext context) {
    final currentTab =
        GoRouterState.of(context).uri.queryParameters['tab'] ?? 'overview';
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context),
              ),
              child: FutureBuilder<BuilderForm>(
                future: _formFuture,
                builder: (context, snapshot) {
                  final form = snapshot.data;
                  final loadError = snapshot.error;
                  return Column(
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
                        form: form,
                        isLoading:
                            snapshot.connectionState == ConnectionState.waiting,
                        error: loadError,
                      ),
                      const SizedBox(height: DesignTokens.spaceL),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusL,
                          ),
                          border: Border.all(color: cs.outline),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _RouteTabChip(
                              label: 'Overview',
                              selected: currentTab == 'overview',
                              onTap: () => context.go(
                                '/projects/${widget.projectId}/forms/${widget.formId}?tab=overview',
                              ),
                            ),
                            _RouteTabChip(
                              label: 'Responses',
                              selected: currentTab == 'responses',
                              onTap: () => context.go(
                                '/projects/${widget.projectId}/forms/${widget.formId}?tab=responses',
                              ),
                            ),
                            _RouteTabChip(
                              label: 'Analytics',
                              selected: currentTab == 'analytics',
                              onTap: () => context.go(
                                '/projects/${widget.projectId}/forms/${widget.formId}?tab=analytics',
                              ),
                            ),
                            _RouteTabChip(
                              label: 'Builder',
                              selected: currentTab == 'builder',
                              onTap: () => context.go(
                                '/projects/${widget.projectId}/forms/${widget.formId}?tab=builder',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spaceL),
                      _FormDashboardTabContent(
                        currentTab: currentTab,
                        projectId: widget.projectId,
                        formId: widget.formId,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RouteTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? cs.onPrimary : cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: DesignTokens.primary,
      backgroundColor: cs.surface,
      side: BorderSide(color: cs.outline),
    );
  }
}

class _FormDashboardTabContent extends StatelessWidget {
  final String currentTab;
  final String projectId;
  final String formId;

  const _FormDashboardTabContent({
    required this.currentTab,
    required this.projectId,
    required this.formId,
  });

  @override
  Widget build(BuildContext context) {
    final child = switch (currentTab) {
      'responses' => _FormDashboardTab(
        title: 'Responses',
        message:
            'This tab is a shortcut to the submissions dashboard for the selected form.',
        actions: [
          _DashboardAction(
            label: 'Open responses',
            icon: Icons.list_alt_outlined,
            onPressed: () =>
                context.push('/projects/$projectId/forms/$formId/responses'),
          ),
        ],
      ),
      'analytics' => _FormDashboardTab(
        title: 'Analytics',
        message:
            'Use this area to inspect response trends, completion rates, and submission activity.',
        actions: [
          _DashboardAction(
            label: 'Open analytics',
            icon: Icons.analytics_outlined,
            onPressed: () =>
                context.push('/projects/$projectId/forms/$formId/analytics'),
          ),
        ],
      ),
      'builder' => _FormDashboardTab(
        title: 'Builder',
        message:
            'Jump into the builder when you are ready to edit sections, questions, and styling.',
        actions: [
          _DashboardAction(
            label: 'Edit form',
            icon: Icons.edit_outlined,
            onPressed: () =>
                context.push('/projects/$projectId/forms/$formId/edit'),
          ),
        ],
      ),
      _ => _FormDashboardTab(
        title: 'Overview',
        message:
            'Project-scoped form details will appear here, along with status, publishing state, and quick actions.',
        actions: [
          _DashboardAction(
            label: 'Open responses',
            icon: Icons.list_alt_outlined,
            onPressed: () =>
                context.push('/projects/$projectId/forms/$formId/responses'),
          ),
          _DashboardAction(
            label: 'View analytics',
            icon: Icons.show_chart_outlined,
            onPressed: () =>
                context.push('/projects/$projectId/forms/$formId/analytics'),
          ),
        ],
      ),
    };
    return SizedBox(
      height: Responsive.isMobile(context) ? 640 : 560,
      child: child,
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final String formId;
  final BuilderForm? form;
  final bool isLoading;
  final Object? error;

  const _HeroCard({
    required this.projectId,
    required this.formId,
    required this.form,
    required this.isLoading,
    required this.error,
  });

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
          final titleStyle =
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ) ??
              const TextStyle(
                fontSize: DesignTokens.fontXXL,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              );
          final bodyStyle =
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                height: 1.5,
              ) ??
              const TextStyle(
                fontSize: DesignTokens.fontM,
                color: Colors.white70,
                height: 1.5,
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Form dashboard', style: titleStyle),
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                error != null
                    ? 'Unable to load form details'
                    : form?.title ?? 'Loading form details...',
                style: bodyStyle,
              ),
              if (error != null) ...[
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  'The dashboard can still open responses, analytics, and the builder while the form metadata request is unavailable.',
                  style: bodyStyle,
                ),
              ],
              const SizedBox(height: DesignTokens.spaceS),
              Text(
                'Project ID: $projectId${isCompact ? '\n' : '  '}Form ID: $formId',
                style: bodyStyle,
              ),
              const SizedBox(height: DesignTokens.spaceL),
              Builder(
                builder: (_) {
                  final sectionCount = form?.sections.length;
                  final quickPresetCount = form?.quickResponses.length;
                  return Wrap(
                    spacing: DesignTokens.spaceS,
                    runSpacing: DesignTokens.spaceS,
                    children: [
                      _HeroTag(
                        label: 'Status',
                        value: error != null
                            ? 'Failed to load'
                            : isLoading
                            ? 'Loading'
                            : form?.status ?? 'Unknown',
                      ),
                      _HeroTag(
                        label: 'Sections',
                        value: sectionCount?.toString() ?? '—',
                      ),
                      _HeroTag(
                        label: 'Quick presets',
                        value: quickPresetCount?.toString() ?? '—',
                      ),
                    ],
                  );
                },
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
