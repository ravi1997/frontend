import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';

class AnalyticsPage extends StatelessWidget {
  final String projectId;
  final String formId;

  const AnalyticsPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: DesignTokens.spaceS),
                      Text(
                        'Analytics dashboard',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  _HeroCard(projectId: projectId, formId: formId),
                  const SizedBox(height: DesignTokens.spaceL),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 920;
                      final cards = [
                        _MetricCard(
                          title: 'Response volume',
                          value: 'Coming soon',
                          subtitle: 'Form analytics data is not yet wired into this page.',
                          icon: Icons.query_stats_outlined,
                        ),
                        _MetricCard(
                          title: 'Completion rate',
                          value: 'Stub',
                          subtitle: 'This panel will surface submission completion trends.',
                          icon: Icons.check_circle_outline,
                        ),
                        _MetricCard(
                          title: 'Audience segments',
                          value: 'Stub',
                          subtitle: 'Breakdowns by language, source, or device will appear here.',
                          icon: Icons.groups_outlined,
                        ),
                      ];

                      if (compact) {
                        return Column(
                          children: cards
                              .map(
                                (card) => Padding(
                                  padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
                                  child: card,
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Row(
                        children: [
                          for (var i = 0; i < cards.length; i++) ...[
                            Expanded(child: cards[i]),
                            if (i != cards.length - 1) const SizedBox(width: DesignTokens.spaceM),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  _SectionCard(
                    title: 'Stub notice',
                    body:
                        'This analytics route is wired to the correct project-scoped URL, but the detailed charts are still a placeholder. Use the actions below to jump back to live routes.',
                    actions: [
                      FilledButton.tonalIcon(
                        onPressed: () => context.push(
                          '/projects/$projectId/forms/$formId/responses',
                        ),
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Open responses'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/projects/$projectId/forms/$formId'),
                        icon: const Icon(Icons.dashboard_outlined),
                        label: const Text('Form dashboard'),
                      ),
                    ],
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
            DesignTokens.primaryDark,
            DesignTokens.accent.withValues(alpha: 0.92),
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
            'Analytics dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Project ID: $projectId\nForm ID: $formId',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: DesignTokens.spaceL),
          Wrap(
            spacing: DesignTokens.spaceS,
            runSpacing: DesignTokens.spaceS,
            children: const [
              _HeroTag(label: 'Status', value: 'Stub'),
              _HeroTag(label: 'Scope', value: 'Project-scoped'),
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: DesignTokens.primarySoft,
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            child: Icon(icon, color: DesignTokens.primary),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.65),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final String body;
  final List<Widget> actions;

  const _SectionCard({
    required this.title,
    required this.body,
    this.actions = const [],
  });

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
                  height: 1.55,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spaceL),
            Wrap(
              spacing: DesignTokens.spaceS,
              runSpacing: DesignTokens.spaceS,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
