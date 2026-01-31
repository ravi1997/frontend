import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:file_saver/file_saver.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/responses/presentation/controllers/responses_controller.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';
import 'package:frontend/features/responses/domain/utils/csv_exporter.dart';

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
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: responsesAsync.when(
        data: (responses) => RefreshIndicator(
          onRefresh: () => ref.refresh(formResponsesProvider(formId).future),
          child: responses.isEmpty
              ? _buildEmptyState()
              : _buildResponseList(context, responses),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
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
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Fetch Form Definition for headers
      final form = await ref
          .read(formBuilderRepositoryProvider)
          .getForm(formId);

      // 2. Generate CSV Content
      final csvString = CsvExporter.generateCsv(responses, form);

      // 3. Save File
      // Using generic name 'responses_{formId}_{timestamp}'
      final safeFormId = formId.replaceAll(RegExp(r'[^\w\s]+'), '');
      final fileName =
          'responses_${safeFormId}_${DateTime.now().millisecondsSinceEpoch}';

      final bytes = Uint8List.fromList(utf8.encode(csvString));

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );

      // 4. Feedback
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
