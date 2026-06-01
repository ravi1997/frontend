import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_saver/file_saver.dart';
import 'package:frontend/features/responses/presentation/controllers/responses_controller.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/responses/domain/utils/csv_exporter.dart';
import 'package:frontend/features/responses/presentation/widgets/export_options_dialog.dart';
import 'package:frontend/features/responses/presentation/widgets/filter_builder_dialog.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

// Fix 1: Auto-dispose providers to prevent stale filters/queries leaking between different forms
final _searchQueryProvider = StateProvider.autoDispose<String?>((ref) => null);
final _activeFiltersProvider = StateProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) => const [],
);

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
    final searchQuery = ref.watch(_searchQueryProvider);
    final activeFilters = ref.watch(_activeFiltersProvider);
    final responsesAsync = activeFilters.isNotEmpty
        ? ref.watch(
            filteredFormResponsesProvider(
              projectId,
              formId,
              filters: activeFilters,
            ),
          )
        : ref.watch(
            formResponsesProvider(projectId, formId, searchQuery: searchQuery),
          );
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: authState.when(
        data: (user) => Column(
          children: [
            _TopBar(
              projectId: projectId,
              formId: formId,
              searchQuery: searchQuery,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  if (activeFilters.isNotEmpty) {
                    return ref.refresh(
                      filteredFormResponsesProvider(
                        projectId,
                        formId,
                        filters: activeFilters,
                      ).future,
                    );
                  }
                  return ref.refresh(
                    formResponsesProvider(
                      projectId,
                      formId,
                      searchQuery: searchQuery,
                    ).future,
                  );
                },
                child: responsesAsync.when(
                  // Fix 2: Render single, optimized list to allow lazy loading/item recycling
                  data: (responses) => _ResponseListContent(
                    formId: formId,
                    projectId: projectId,
                    responses: responses,
                    searchQuery: searchQuery,
                    activeFilters: activeFilters,
                  ),
                  loading: () => const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: _LoadingSkeleton(),
                    ),
                  ),
                  error: (err, stack) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: _ErrorSection(error: err.toString()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  final String projectId;
  final String formId;
  final String? searchQuery;
  const _TopBar({
    required this.projectId,
    required this.formId,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fix 3: Responsive horizontal padding
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 900 ? 48.0 : 16.0;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF374151),
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'MahaSamgrah Setu / Form Responses',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          _ActionButtons(
            projectId: projectId,
            formId: formId,
            searchQuery: searchQuery,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final String projectId;
  final String formId;
  final String? searchQuery;
  const _ActionButtons({
    required this.projectId,
    required this.formId,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsesAsync = ref.watch(
      formResponsesProvider(projectId, formId, searchQuery: searchQuery),
    );

    return responsesAsync.maybeWhen(
      data: (responses) => responses.isNotEmpty
          ? ElevatedButton.icon(
              onPressed: () => _ResponseListPageUtils._exportCsv(
                context,
                ref,
                projectId,
                formId,
                searchQuery,
                responses,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              icon: const Icon(Icons.file_download_outlined, size: 18),
              label: Text(
                'Export Data',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : const SizedBox.shrink(),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _HeaderSection extends ConsumerWidget {
  final String formId;
  const _HeaderSection({required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Form Analytics',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'View and manage all submissions for your form.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _ResponseListContent extends StatelessWidget {
  final String formId;
  final String projectId;
  final List<FormResponse> responses;
  final String? searchQuery;
  final List<Map<String, dynamic>> activeFilters;

  const _ResponseListContent({
    required this.formId,
    required this.projectId,
    required this.responses,
    this.searchQuery,
    required this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 900 ? 48.0 : 16.0;
    final verticalPadding = screenWidth > 900 ? 32.0 : 20.0;

    // Fix 4: Combined list layout using ListView.builder to allow item recycling and lazy loading
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      itemCount: responses.isEmpty ? 3 : responses.length + 2,
      itemBuilder: (context, index) {
        Widget wrapWithWidthConstraint(Widget child) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              width: double.infinity,
              child: child,
            ),
          );
        }

        // Row 1: Header + Stats Grid
        if (index == 0) {
          return wrapWithWidthConstraint(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(formId: formId),
                const SizedBox(height: 32),
                _StatsGrid(responses: responses),
              ],
            ),
          );
        }

        // Row 2: Filters + Chips Bar
        if (index == 1) {
          return wrapWithWidthConstraint(
            Column(
              children: [
                const SizedBox(height: 48),
                _FilterBar(formId: formId, projectId: projectId),
                if (activeFilters.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _ActiveFilterChips(filters: activeFilters),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        }

        // Row 3: Empty State (if list is empty)
        if (responses.isEmpty) {
          if (index == 2) {
            return wrapWithWidthConstraint(_EmptyState());
          }
          return const SizedBox.shrink();
        }

        // Dynamic Card Row (Lazy-loaded cards with rounded corner decoration wrapper)
        final cardIndex = index - 2;
        if (cardIndex < responses.length) {
          final isFirst = cardIndex == 0;
          final isLast = cardIndex == responses.length - 1;

          Widget card = _ResponseCard(
            formId: formId,
            response: responses[cardIndex],
          );

          if (!isLast) {
            card = Column(
              children: [
                card,
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
              ],
            );
          }

          return wrapWithWidthConstraint(
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: const BorderSide(color: Color(0xFFE5E7EB)),
                  right: const BorderSide(color: Color(0xFFE5E7EB)),
                  top: isFirst ? const BorderSide(color: Color(0xFFE5E7EB)) : BorderSide.none,
                  bottom: isLast ? const BorderSide(color: Color(0xFFE5E7EB)) : BorderSide.none,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
                  topRight: isFirst ? const Radius.circular(12) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
                ),
              ),
              child: card,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<FormResponse> responses;
  const _StatsGrid({required this.responses});

  @override
  Widget build(BuildContext context) {
    // Fix 5: Extract DateTime.now() outside of loop to save CPU cycles
    final now = DateTime.now();
    final todayCount = responses
        .where(
          (r) =>
              r.submittedAt != null &&
              r.submittedAt!.day == now.day &&
              r.submittedAt!.month == now.month &&
              r.submittedAt!.year == now.year,
        )
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 24;
        
        // Fix 6: Two-column breakpoint on tablets/medium screens
        int columns = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 900 ? 2 : 3);
        final double cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _SimpleStatsCard(
              title: 'Total Responses',
              value: responses.length.toString(),
              subtitle: 'Submissions to date',
              icon: Icons.people_outline,
              width: cardWidth,
              iconColor: const Color(0xFF2563EB),
              bgIconColor: const Color(0xFFEFF6FF),
            ),
            _SimpleStatsCard(
              title: 'Today',
              value: todayCount.toString(),
              subtitle: 'New submissions',
              icon: Icons.bolt,
              width: cardWidth,
              iconColor: const Color(0xFFF59E0B),
              bgIconColor: const Color(0xFFFFFBEB),
            ),
            _SimpleStatsCard(
              title: 'Completion Rate',
              value: '100%',
              subtitle: 'Successful entries',
              icon: Icons.check_circle_outline,
              width: cardWidth,
              iconColor: const Color(0xFF10B981),
              bgIconColor: const Color(0xFFECFDF5),
            ),
          ],
        );
      },
    );
  }
}

class _SimpleStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final double width;
  final Color iconColor;
  final Color bgIconColor;

  const _SimpleStatsCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.width,
    required this.iconColor,
    required this.bgIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgIconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
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

class _FilterBar extends ConsumerWidget {
  final String formId;
  final String projectId;
  const _FilterBar({required this.formId, required this.projectId});

  static const _accent = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(_activeFiltersProvider);
    final hasFilters = activeFilters.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) =>
                ref.read(_searchQueryProvider.notifier).state =
                    value.trim().isEmpty ? null : value.trim(),
            decoration: InputDecoration(
              hintText: 'Ask AI about these responses...',
              prefixIcon: const Icon(
                FontAwesomeIcons.wandMagicSparkles,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: hasFilters ? _accent.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasFilters ? _accent : const Color(0xFFE5E7EB),
              width: hasFilters ? 1.5 : 1.0,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final form = await ref
                  .read(formBuilderRepositoryProvider)
                  .getForm(projectId, formId);
              if (!context.mounted) return;

              final questions = <FormQuestion>[];
              for (final section in form.sections) {
                questions.addAll(section.questions);
              }

              final result = await showFilterBuilderDialog(
                context: context,
                questions: questions,
                initialFilters: activeFilters,
              );

              if (result != null) {
                ref.read(_activeFiltersProvider.notifier).state = result;
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: 18,
                    color: hasFilters ? _accent : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasFilters ? 'Filters (${activeFilters.length})' : 'Filter',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: hasFilters
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: hasFilters ? _accent : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveFilterChips extends ConsumerWidget {
  final List<Map<String, dynamic>> filters;
  const _ActiveFilterChips({required this.filters});

  static const _accent = Color(0xFF6366F1);

  String _chipLabel(Map<String, dynamic> f) {
    final field = f['field'] as String? ?? '';
    final op = f['operator'] as String? ?? '';
    final val = f['value'];

    final fieldLabel = field == 'submitted_at' ? 'Submission Date' : field;
    final opLabel = _opLabel(op);

    if (val == null) return '$fieldLabel $opLabel';
    if (val is List) {
      if (op == 'between') {
        return '$fieldLabel $opLabel ${val[0]} → ${val[1]}';
      }
      return '$fieldLabel $opLabel ${val.join(', ')}';
    }
    if (val is bool) {
      return '$fieldLabel $opLabel ${val ? 'true' : 'false'}';
    }
    return '$fieldLabel $opLabel $val';
  }

  String _opLabel(String op) {
    const map = {
      'equals': '=',
      'not_equals': '≠',
      'contains': 'contains',
      'starts_with': 'starts',
      'ends_with': 'ends',
      'in': 'in',
      'not_in': 'not in',
      'in_list': 'in',
      'not_in_list': 'not in',
      'is_empty': 'is empty',
      'is_not_empty': 'not empty',
      'gt': '>',
      'gte': '≥',
      'lt': '<',
      'lte': '≤',
      'greater_than': '>',
      'greater_than_equals': '≥',
      'less_than': '<',
      'less_than_equals': '≤',
      'between': 'between',
      'before': 'before',
      'after': 'after',
      'is_true': 'is true',
      'is_false': 'is false',
    };
    return map[op] ?? op;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        ...filters.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Chip(
              key: ValueKey(i),
              backgroundColor: _accent.withValues(alpha: 0.12),
              side: BorderSide(color: _accent.withValues(alpha: 0.35)),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              label: Text(
                _chipLabel(f),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _accent,
                ),
              ),
              deleteIcon: Icon(
                Icons.close_rounded,
                size: 14,
                color: _accent.withValues(alpha: 0.75),
              ),
              onDeleted: () {
                final updated = List<Map<String, dynamic>>.from(filters)
                  ..removeAt(i);
                ref.read(_activeFiltersProvider.notifier).state = updated;
              },
            ),
          );
        }),
        ActionChip(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          label: Text(
            'Clear all',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade400,
            ),
          ),
          onPressed: () =>
              ref.read(_activeFiltersProvider.notifier).state = const [],
        ),
      ],
    );
  }
}

class _ResponseCard extends StatelessWidget {
  final String formId;
  final FormResponse response;

  const _ResponseCard({required this.formId, required this.response});

  @override
  Widget build(BuildContext context) {
    final dateStr = response.submittedAt != null
        ? DateFormat('MMM dd, yyyy HH:mm').format(response.submittedAt!)
        : 'Unknown Date';

    String preview = 'No data';
    if (response.answers.isNotEmpty) {
      final values = <String>[];
      for (var entry in response.answers.values) {
        if (entry is Map) {
          final firstVal = entry.values.firstWhere(
            (v) => v != null,
            orElse: () => null,
          );
          if (firstVal != null) values.add(firstVal.toString());
        } else if (entry != null) {
          values.add(entry.toString());
        }
        if (values.length >= 3) break;
      }
      if (values.isNotEmpty) preview = values.join(' • ');
    }

    return InkWell(
      onTap: () => context.push('/forms/$formId/responses/${response.id}'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submission on $dateStr',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.inbox,
            size: 48,
            color: Color(0xFFD1D5DB),
          ),
          const SizedBox(height: 16),
          Text(
            'No Responses Yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep sharing your form to gather data.',
            style: GoogleFonts.inter(color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String error;
  const _ErrorSection({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('Error loading responses: $error'),
        ],
      ),
    );
  }
}

class _ResponseListPageUtils {
  static Future<void> _exportCsv(
    BuildContext context,
    WidgetRef ref,
    String projectId,
    String formId,
    String? searchQuery,
    List<FormResponse> responses,
  ) async {
    final form = await ref
        .read(formBuilderRepositoryProvider)
        .getForm(projectId, formId);
    if (!context.mounted) return;

    final options = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExportOptionsDialog(form: form),
    );

    if (options == null || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final String format = options['format'];
      final DateTimeRange? dateRange = options['dateRange'];

      var filteredResponses = responses;
      if (dateRange != null) {
        filteredResponses = responses
            .where(
              (r) =>
                  r.submittedAt != null &&
                  r.submittedAt!.isAfter(dateRange.start) &&
                  r.submittedAt!.isBefore(
                    dateRange.end.add(const Duration(days: 1)),
                  ),
            )
            .toList();
      }

      String content = '';
      String extension = 'csv';
      MimeType mimeType = MimeType.csv;

      if (format == 'CSV' || format == 'Excel') {
        content = CsvExporter.generateCsv(filteredResponses, form);
        if (format == 'Excel') {
          extension = 'xlsx';
          mimeType = MimeType.microsoftExcel;
        }
      } else if (format == 'JSON') {
        content = jsonEncode(
          filteredResponses
              .map(
                (r) => {
                  'id': r.id,
                  'form_id': r.formId,
                  'organization_id': r.organizationId,
                  'submitted_by': r.submittedBy,
                  'submitted_at': r.submittedAt?.toIso8601String(),
                  'answers': r.answers,
                  'ip_address': r.ipAddress,
                  'user_agent': r.userAgent,
                  'ai_results': r.aiResults,
                  'status': r.status,
                },
              )
              .toList(),
        );
        extension = 'json';
        mimeType = MimeType.json;
      } else {
        content = 'PDF Export Placeholder';
        extension = 'pdf';
        mimeType = MimeType.pdf;
      }

      final fileName =
          'responses_${formId.replaceAll(RegExp(r'[^\w\s]+'), '')}_${DateTime.now().millisecondsSinceEpoch}';
      final bytes = Uint8List.fromList(utf8.encode(content));

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        fileExtension: extension,
        mimeType: mimeType,
      );

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Export Complete')));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
