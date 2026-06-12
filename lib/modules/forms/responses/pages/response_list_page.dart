import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/responses/controllers/responses_controller.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';

class ResponseListPage extends ConsumerWidget {
  final String projectId;
  final String formId;

  const ResponseListPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final responsesAsync = ref.watch(formResponsesProvider(projectId, formId));

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Form responses'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(formResponsesProvider(projectId, formId));
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (responsesAsync) {
          null => _ErrorState(
            message: 'Failed to load responses',
            onRetry: () =>
                ref.invalidate(formResponsesProvider(projectId, formId)),
          ),
          AsyncLoading<List<FormResponse>>() => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncError<List<FormResponse>>(error: final error) => _ErrorState(
            message: error.toString(),
            onRetry: () =>
                ref.invalidate(formResponsesProvider(projectId, formId)),
          ),
          AsyncData<List<FormResponse>>(value: final responses) =>
            ListView.separated(
              padding: Responsive.pagePadding(context),
              itemCount: responses.isEmpty ? 2 : responses.length + 1,
              separatorBuilder: (context, _) =>
                  const SizedBox(height: DesignTokens.spaceM),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _HeroCard(
                    projectId: projectId,
                    formId: formId,
                    responseCount: responses.length,
                  );
                }

                if (responses.isEmpty) {
                  return _EmptyStateCard(projectId: projectId, formId: formId);
                }

                final response = responses[index - 1];
                return _ResponseCard(
                  response: response,
                  onTap: response.id == null
                      ? null
                      : () => context.push(
                          '/projects/$projectId/forms/$formId/responses/${response.id}',
                        ),
                );
              },
            ),
          Object() => _ErrorState(
            message: 'Failed to load responses',
            onRetry: () =>
                ref.invalidate(formResponsesProvider(projectId, formId)),
          ),
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final String formId;
  final int responseCount;

  const _HeroCard({
    required this.projectId,
    required this.formId,
    required this.responseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryDark,
            DesignTokens.primary.withValues(alpha: 0.92),
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
            'Form responses',
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
            children: [
              _HeroTag(label: 'Responses', value: '$responseCount'),
              const _HeroTag(label: 'Scope', value: 'Project-scoped'),
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

class _ResponseCard extends StatelessWidget {
  final FormResponse response;
  final VoidCallback? onTap;

  const _ResponseCard({required this.response, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final responseId = response.id ?? 'unknown';
    final submittedAt = response.submittedAt == null
        ? 'Unknown submission time'
        : DateFormat.yMMMd().add_jm().format(response.submittedAt!.toLocal());
    final preview = _previewAnswers(response.answers);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      child: InkWell(
        onTap: onTap,
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
                          responseId,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Submitted by ${response.submittedBy.isEmpty ? 'unknown user' : response.submittedBy}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.75),
                              ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(status: response.status),
                ],
              ),
              const SizedBox(height: DesignTokens.spaceM),
              Wrap(
                spacing: DesignTokens.spaceS,
                runSpacing: DesignTokens.spaceS,
                children: [
                  _MetaPill(icon: Icons.schedule_outlined, label: submittedAt),
                  _MetaPill(
                    icon: Icons.fact_check_outlined,
                    label:
                        '${response.answers.length} answer${response.answers.length == 1 ? '' : 's'}',
                  ),
                ],
              ),
              if (preview.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spaceM),
                Text(
                  preview,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: cs.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ],
              if (onTap != null) ...[
                const SizedBox(height: DesignTokens.spaceM),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open details'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _previewAnswers(Map<String, dynamic> answers) {
    if (answers.isEmpty) return '';
    final entries = answers.entries.take(3).map((entry) {
      final value = entry.value;
      final formatted = value is Map || value is List
          ? value.toString()
          : value?.toString() ?? 'null';
      return '${entry.key}: $formatted';
    }).toList();
    return entries.join('\n');
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final normalized = status.toLowerCase();
    final background = switch (normalized) {
      'submitted' => DesignTokens.success.withValues(alpha: 0.14),
      'draft' => DesignTokens.warning.withValues(alpha: 0.14),
      'rejected' || 'error' => DesignTokens.error.withValues(alpha: 0.14),
      _ => cs.surfaceContainerHighest,
    };
    final foreground = switch (normalized) {
      'submitted' => DesignTokens.success,
      'draft' => DesignTokens.warning,
      'rejected' || 'error' => DesignTokens.error,
      _ => cs.onSurface,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Text(
        status.isEmpty ? 'unknown' : status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceM,
        vertical: DesignTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurface.withValues(alpha: 0.75)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final String projectId;
  final String formId;

  const _EmptyStateCard({required this.projectId, required this.formId});

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
            'No responses yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            'Once respondents submit this form, their submissions will appear here.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceL),
          Wrap(
            spacing: DesignTokens.spaceS,
            runSpacing: DesignTokens.spaceS,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.push(
                  '/projects/$projectId/forms/$formId/analytics',
                ),
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('Open analytics'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    context.push('/projects/$projectId/forms/$formId'),
                icon: const Icon(Icons.dashboard_outlined),
                label: const Text('Form dashboard'),
              ),
            ],
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
                  'Could not load responses',
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
