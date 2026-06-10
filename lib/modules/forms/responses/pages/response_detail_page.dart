import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';

class ResponseDetailPage extends StatelessWidget {
  final String projectId;
  final String formId;
  final String responseId;

  const ResponseDetailPage({
    super.key,
    required this.projectId,
    required this.formId,
    required this.responseId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Response details'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCard(
                    projectId: projectId,
                    formId: formId,
                    responseId: responseId,
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  _StubCard(
                    title: 'Response detail stub',
                    body:
                        'The response detail route is wired, but the detailed review layout has not been implemented yet. This placeholder is intentionally labeled so it is easy to replace later.',
                    actions: [
                      FilledButton.tonalIcon(
                        onPressed: () => context.push(
                          '/projects/$projectId/forms/$formId/responses',
                        ),
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Back to responses'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/projects/$projectId/forms/$formId/analytics',
                        ),
                        icon: const Icon(Icons.analytics_outlined),
                        label: const Text('Open analytics'),
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
  final String responseId;

  const _HeroCard({
    required this.projectId,
    required this.formId,
    required this.responseId,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Response details',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Project ID: $projectId\nForm ID: $formId\nResponse ID: $responseId',
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

class _StubCard extends StatelessWidget {
  final String title;
  final String body;
  final List<Widget> actions;

  const _StubCard({
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
