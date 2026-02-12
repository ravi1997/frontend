import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_saver/file_saver.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/responses/presentation/controllers/responses_controller.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';
import 'package:frontend/features/responses/domain/utils/csv_exporter.dart';

import 'package:frontend/features/responses/presentation/widgets/export_options_dialog.dart';

class ResponseListPage extends ConsumerWidget {
  final String formId;

  const ResponseListPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsesAsync = ref.watch(formResponsesProvider(formId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Form Responses',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          responsesAsync.when(
            data: (responses) => responses.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => _exportCsv(context, ref, responses),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: responsesAsync.when(
        data: (responses) => Column(
          children: [
            _buildAISearchBar(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(formResponsesProvider(formId).future),
                child: responses.isEmpty
                    ? _buildEmptyState()
                    : _buildResponseList(context, responses),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildAISearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: TextField(
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText:
              'Search with AI (e.g., "Find all responses from yesterday about complaints")',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          prefixIcon: const Icon(
            FontAwesomeIcons.wandMagicSparkles,
            size: 16,
            color: AppColors.primary,
          ),
          filled: true,
          fillColor: AppColors.background.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: (value) {
          // TODO: Call AI Smart Search Endpoint
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI Search: Finding results for "$value"...'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text(
            'No responses yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseList(
    BuildContext context,
    List<FormResponse> responses,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: responses.length,
      itemBuilder: (context, index) {
        final response = responses[index];
        final dateStr = DateFormat(
          'MMM dd, yyyy HH:mm',
        ).format(response.submittedAt);
        final preview = response.answers.values.take(3).join(', ');

        return Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Submission: $dateStr',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              preview.isEmpty ? 'No data' : preview,
              style: const TextStyle(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
            onTap: () => context.push('/responses/${response.id}'),
          ),
        );
      },
    );
  }

  Future<void> _exportCsv(
    BuildContext context,
    WidgetRef ref,
    List<FormResponse> responses,
  ) async {
    // 1. Fetch Form Definition for headers
    final form = await ref.read(formBuilderRepositoryProvider).getForm(formId);

    if (!context.mounted) return;

    // 2. Show advanced export options dialog
    final options = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExportOptionsDialog(form: form),
    );

    if (options == null) return;

    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final String format = options['format'];
      final DateTimeRange? dateRange = options['dateRange'];

      // Filter responses by date range
      var filteredResponses = responses;
      if (dateRange != null) {
        filteredResponses = responses
            .where(
              (r) =>
                  r.submittedAt.isAfter(dateRange.start) &&
                  r.submittedAt.isBefore(
                    dateRange.end.add(const Duration(days: 1)),
                  ),
            )
            .toList();
      }

      // 3. Generate Content (For now, we still only have CSV generator, but we can mock others or use local processing)
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
        content = jsonEncode(filteredResponses.map((r) => r.toJson()).toList());
        extension = 'json';
        mimeType = MimeType.json;
      } else {
        // PDF fallback for now
        content =
            'PDF Export Placeholder for ${filteredResponses.length} responses';
        extension = 'pdf';
        mimeType = MimeType.pdf;
      }

      // 4. Save File
      final safeFormId = formId.replaceAll(RegExp(r'[^\w\s]+'), '');
      final fileName =
          'responses_${safeFormId}_${DateTime.now().millisecondsSinceEpoch}';

      final bytes = Uint8List.fromList(utf8.encode(content));

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        fileExtension: extension,
        mimeType: mimeType,
      );

      // 5. Feedback
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export Complete'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
