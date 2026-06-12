import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/responses/controllers/responses_controller.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';

class ResponseDetailPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final detailAsync = ref.watch(
      responseDetailProvider(projectId, formId, responseId),
    );
    final historyAsync = ref.watch(
      responseHistoryProvider(projectId, formId, responseId),
    );

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Response details'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(
                responseDetailProvider(projectId, formId, responseId),
              );
              ref.invalidate(
                responseHistoryProvider(projectId, formId, responseId),
              );
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (detailAsync) {
          null => _ErrorState(
            message: 'Failed to load response details',
            onRetry: () {
              ref.invalidate(
                responseDetailProvider(projectId, formId, responseId),
              );
              ref.invalidate(
                responseHistoryProvider(projectId, formId, responseId),
              );
            },
          ),
          AsyncLoading<FormResponse>() => const Center(
            child: CircularProgressIndicator(),
          ),
          AsyncError<FormResponse>(error: final error) => _ErrorState(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(
                responseDetailProvider(projectId, formId, responseId),
              );
              ref.invalidate(
                responseHistoryProvider(projectId, formId, responseId),
              );
            },
          ),
          AsyncData<FormResponse>(value: final response) => SingleChildScrollView(
            padding: Responsive.pagePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.maxContentWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCard(
                      projectId: projectId,
                      formId: formId,
                      response: response,
                    ),
                    const SizedBox(height: DesignTokens.spaceL),
                    _SectionCard(
                      title: 'Submission metadata',
                      child: _MetadataGrid(response: response),
                    ),
                    const SizedBox(height: DesignTokens.spaceL),
                    _SectionCard(
                      title: 'Answers',
                      child: response.answers.isEmpty
                          ? Text(
                              'No answers were recorded for this response.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.55,
                                    color: cs.onSurface.withValues(alpha: 0.72),
                                  ),
                            )
                          : Column(
                              children: response.answers.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: DesignTokens.spaceM,
                                      ),
                                      child: _AnswerCard(
                                        fieldLabel: entry.key,
                                        value: entry.value,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: DesignTokens.spaceL),
                    _SectionCard(
                      title: 'History',
                      child: switch (historyAsync) {
                        AsyncLoading<List<ResponseHistory>>() =>
                          const _HistoryLoadingCard(),
                        AsyncError<List<ResponseHistory>>(error: final error) =>
                          Text(
                            error.toString(),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  height: 1.55,
                                  color: cs.onSurface.withValues(alpha: 0.72),
                                ),
                          ),
                        AsyncData<List<ResponseHistory>>(
                          value: final history,
                        ) =>
                          history.isEmpty
                              ? Text(
                                  'No history entries were returned for this response.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        height: 1.55,
                                        color: cs.onSurface.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                )
                              : Column(
                                  children: history
                                      .map(
                                        (entry) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: DesignTokens.spaceM,
                                          ),
                                          child: _HistoryCard(entry: entry),
                                        ),
                                      )
                                      .toList(),
                                ),
                        null => Text(
                          'No history entries were returned for this response.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                height: 1.55,
                                color: cs.onSurface.withValues(alpha: 0.72),
                              ),
                        ),
                        Object() => Text(
                          'Unexpected history state.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                height: 1.55,
                                color: cs.onSurface.withValues(alpha: 0.72),
                              ),
                        ),
                      },
                    ),
                    const SizedBox(height: DesignTokens.spaceL),
                    Wrap(
                      spacing: DesignTokens.spaceS,
                      runSpacing: DesignTokens.spaceS,
                      children: [
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
          Object() => _ErrorState(
            message: 'Failed to load response details',
            onRetry: () {
              ref.invalidate(
                responseDetailProvider(projectId, formId, responseId),
              );
              ref.invalidate(
                responseHistoryProvider(projectId, formId, responseId),
              );
            },
          ),
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final String formId;
  final FormResponse response;

  const _HeroCard({
    required this.projectId,
    required this.formId,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final submittedAt = response.submittedAt == null
        ? 'Unknown'
        : DateFormat.yMMMd().add_jm().format(response.submittedAt!.toLocal());

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
            'Project ID: $projectId\nForm ID: $formId\nResponse ID: ${response.id ?? 'unknown'}',
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
              _HeroTag(label: 'Status', value: response.status),
              _HeroTag(label: 'Submitted', value: submittedAt),
              _HeroTag(label: 'Answers', value: '${response.answers.length}'),
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

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
          const SizedBox(height: DesignTokens.spaceM),
          child,
        ],
      ),
    );
  }
}

class _MetadataGrid extends StatelessWidget {
  final FormResponse response;

  const _MetadataGrid({required this.response});

  @override
  Widget build(BuildContext context) {
    final items = <_MetadataItem>[
      _MetadataItem(label: 'Organization', value: response.organizationId),
      _MetadataItem(label: 'Submitted by', value: response.submittedBy),
      _MetadataItem(label: 'IP address', value: response.ipAddress ?? '—'),
      _MetadataItem(label: 'User agent', value: response.userAgent ?? '—'),
      _MetadataItem(
        label: 'AI results',
        value: response.aiResults == null ? '—' : 'Available',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        if (compact) {
          return Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
                    child: _MetadataTile(item: item),
                  ),
                )
                .toList(),
          );
        }

        return Wrap(
          spacing: DesignTokens.spaceS,
          runSpacing: DesignTokens.spaceS,
          children: items
              .map(
                (item) => SizedBox(
                  width: (constraints.maxWidth - DesignTokens.spaceS) / 2,
                  child: _MetadataTile(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetadataItem {
  final String label;
  final String value;

  const _MetadataItem({required this.label, required this.value});
}

class _MetadataTile extends StatelessWidget {
  final _MetadataItem item;

  const _MetadataTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.onSurface, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final String fieldLabel;
  final dynamic value;

  const _AnswerCard({required this.fieldLabel, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatValue(value),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.onSurface, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is String) return value.isEmpty ? '—' : value;
    if (value is num || value is bool) return value.toString();
    return JsonEncoder.withIndent('  ').convert(value);
  }
}

class _HistoryCard extends StatelessWidget {
  final ResponseHistory entry;

  const _HistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final when = DateFormat.yMMMd().add_jm().format(
      entry.performedAt.toLocal(),
    );
    final changes = entry.changes.isEmpty
        ? 'No change details were returned.'
        : JsonEncoder.withIndent('  ').convert(entry.changes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.action,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Text(
                when,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Performed by ${entry.performedBy}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          Text(
            changes,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              height: 1.5,
              color: cs.onSurface.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryLoadingCard extends StatelessWidget {
  const _HistoryLoadingCard();

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
      child: const Center(child: CircularProgressIndicator()),
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
                  'Could not load response details',
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
