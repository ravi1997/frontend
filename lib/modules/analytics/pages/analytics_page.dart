import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:frontend/app/startup/responsive.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/analytics/analytics_controller.dart';
import 'package:frontend/modules/analytics/analytics_providers.dart';
import 'package:frontend/modules/analytics/analytics_distribution.dart';
import 'package:frontend/modules/analytics/analytics_summary.dart';
import 'package:frontend/modules/analytics/analytics_timeline.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  final String projectId;
  final String formId;

  const AnalyticsPage({
    super.key,
    required this.projectId,
    required this.formId,
  });

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(analyticsControllerProvider(widget.formId).notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(analyticsStateProvider(widget.formId));

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
                      const Spacer(),
                      IconButton(
                        tooltip: 'Refresh analytics',
                        onPressed: () {
                          ref
                              .read(
                                analyticsControllerProvider(
                                  widget.formId,
                                ).notifier,
                              )
                              .refresh();
                        },
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spaceM),
                  _HeroCard(
                    projectId: widget.projectId,
                    formId: widget.formId,
                    summary: state.summary,
                    isLoading: state.isLoading,
                  ),
                  if (state.hasError) ...[
                    const SizedBox(height: DesignTokens.spaceM),
                    _ErrorBanner(
                      message: state.error ?? 'Failed to load analytics',
                      onRetry: () {
                        ref
                            .read(
                              analyticsControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .refresh();
                      },
                    ),
                  ],
                  const SizedBox(height: DesignTokens.spaceL),
                  _MetricGrid(summary: state.summary),
                  const SizedBox(height: DesignTokens.spaceL),
                  _SectionCard(
                    title: 'Submission timeline',
                    subtitle: _timelineSubtitle(state.timeline),
                    child: _TimelineSection(timeline: state.timeline),
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  _SectionCard(
                    title: 'Field distributions',
                    subtitle: state.distribution == null
                        ? 'Waiting for distribution data.'
                        : '${state.distribution!.fieldDistributions.length} field${state.distribution!.fieldDistributions.length == 1 ? '' : 's'}',
                    child: _DistributionSection(
                      distribution: state.distribution,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spaceL),
                  Wrap(
                    spacing: DesignTokens.spaceS,
                    runSpacing: DesignTokens.spaceS,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => context.push(
                          '/projects/${widget.projectId}/forms/${widget.formId}/responses',
                        ),
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Open responses'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          '/projects/${widget.projectId}/forms/${widget.formId}',
                        ),
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

  String _timelineSubtitle(AnalyticsTimeline? timeline) {
    if (timeline == null) return 'Waiting for timeline data.';
    final period = timeline.period ?? '30-day window';
    final count = timeline.dataPoints.length;
    return '$period • $count point${count == 1 ? '' : 's'}';
  }
}

class _HeroCard extends StatelessWidget {
  final String projectId;
  final String formId;
  final AnalyticsSummary? summary;
  final bool isLoading;

  const _HeroCard({
    required this.projectId,
    required this.formId,
    required this.summary,
    required this.isLoading,
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
            children: [
              _HeroTag(
                label: 'Status',
                value: isLoading
                    ? 'Loading'
                    : (summary == null ? 'No data' : 'Live'),
              ),
              _HeroTag(
                label: 'Total',
                value: summary == null ? '—' : '${summary!.totalSubmissions}',
              ),
              _HeroTag(
                label: 'Completion',
                value: summary == null
                    ? '—'
                    : _formatPercent(summary!.completionRate),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPercent(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
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

class _MetricGrid extends StatelessWidget {
  final AnalyticsSummary? summary;

  const _MetricGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetricItem(
        title: 'Response volume',
        value: summary == null ? '—' : '${summary!.totalSubmissions}',
        subtitle: 'Total submissions captured for this form.',
        icon: Icons.query_stats_outlined,
      ),
      _MetricItem(
        title: 'Completion rate',
        value: summary == null ? '—' : _formatPercent(summary!.completionRate),
        subtitle: 'Share of responses that reached completion.',
        icon: Icons.check_circle_outline,
      ),
      _MetricItem(
        title: 'Unique responders',
        value: summary?.uniqueResponders == null
            ? '—'
            : '${summary!.uniqueResponders}',
        subtitle: 'Distinct responders when the backend supplies this metric.',
        icon: Icons.groups_outlined,
      ),
      _MetricItem(
        title: 'Average completion time',
        value: summary?.averageCompletionTime == null
            ? '—'
            : _formatDuration(summary!.averageCompletionTime!),
        subtitle: 'Mean time to completion when available from analytics.',
        icon: Icons.timer_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;
        final cards = items.map((item) => _MetricCard(item: item)).toList();

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

        return Wrap(
          spacing: DesignTokens.spaceM,
          runSpacing: DesignTokens.spaceM,
          children: cards
              .map(
                (card) => SizedBox(
                  width: (constraints.maxWidth - DesignTokens.spaceM) / 2,
                  child: card,
                ),
              )
              .toList(),
        );
      },
    );
  }

  String _formatPercent(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
  }

  String _formatDuration(double minutes) {
    if (minutes < 1) return '${(minutes * 60).round()}s';
    if (minutes < 60) return '${minutes.toStringAsFixed(1)}m';
    final hours = minutes / 60;
    return '${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)}h';
  }
}

class _MetricItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricItem item;

  const _MetricCard({required this.item});

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
            child: Icon(item.icon, color: DesignTokens.primary),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
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
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
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
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.45,
              color: cs.onSurface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceM),
          child,
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final AnalyticsTimeline? timeline;

  const _TimelineSection({required this.timeline});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final points = timeline?.dataPoints ?? const <TimelineDataPoint>[];
    if (points.isEmpty) {
      return Text(
        'No timeline data returned yet.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.55,
          color: cs.onSurface.withValues(alpha: 0.72),
        ),
      );
    }

    return Column(
      children: points
          .map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
              child: _TimelineRow(point: point),
            ),
          )
          .toList(),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineDataPoint point;

  const _TimelineRow({required this.point});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rate = point.rate == null ? null : _formatPercent(point.rate!);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spaceM),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DesignTokens.primarySoft,
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            child: Text(
              DateFormat('d').format(point.date.toLocal()),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: DesignTokens.primary,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(point.date.toLocal()),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${point.count} event${point.count == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          if (rate != null)
            Text(
              rate,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
        ],
      ),
    );
  }

  String _formatPercent(double rate) {
    final percent = rate <= 1 ? rate * 100 : rate;
    return '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
  }
}

class _DistributionSection extends StatelessWidget {
  final AnalyticsDistribution? distribution;

  const _DistributionSection({required this.distribution});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fields =
        distribution?.fieldDistributions ?? const <FieldDistribution>[];
    if (fields.isEmpty) {
      return Text(
        'No field distribution data returned yet.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.55,
          color: cs.onSurface.withValues(alpha: 0.72),
        ),
      );
    }

    return Column(
      children: fields
          .map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceM),
              child: _DistributionCard(field: field),
            ),
          )
          .toList(),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  final FieldDistribution field;

  const _DistributionCard({required this.field});

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
            field.fieldLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            field.totalResponses == null
                ? 'Distribution'
                : '${field.totalResponses} response${field.totalResponses == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS),
          ...field.options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spaceS),
              child: _DistributionOptionRow(option: option),
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionOptionRow extends StatelessWidget {
  final DistributionOption option;

  const _DistributionOptionRow({required this.option});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final percent = option.percentage <= 1
        ? option.percentage * 100
        : option.percentage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent / 100,
          minHeight: 8,
          borderRadius: BorderRadius.circular(999),
          backgroundColor: cs.surfaceContainerHighest,
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(color: cs.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: cs.onErrorContainer),
          const SizedBox(width: DesignTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Some analytics data could not be loaded',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onErrorContainer.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: DesignTokens.spaceM),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_outlined),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
