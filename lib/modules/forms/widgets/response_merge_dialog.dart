import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';
import 'package:frontend/modules/forms/responses/response_repository_provider.dart';
import 'package:frontend/modules/forms/responses/data/services/sync_service.dart';

class ResponseMergeDialog extends ConsumerStatefulWidget {
  final String pendingUploadId;
  final String projectId;
  final FormResponse localResponse;
  final FormResponse serverResponse;

  const ResponseMergeDialog({
    super.key,
    required this.pendingUploadId,
    required this.projectId,
    required this.localResponse,
    required this.serverResponse,
  });

  @override
  ConsumerState<ResponseMergeDialog> createState() => _ResponseMergeDialogState();
}

class _ResponseMergeDialogState extends ConsumerState<ResponseMergeDialog> {
  final Map<String, String> _resolutions = {}; // field -> 'local' or 'server'
  late List<String> _conflictingFields;

  @override
  void initState() {
    super.initState();
    _findConflicts();
  }

  void _findConflicts() {
    _conflictingFields = [];
    final allKeys = {...widget.localResponse.answers.keys, ...widget.serverResponse.answers.keys};

    for (final key in allKeys) {
      final localVal = widget.localResponse.answers[key];
      final serverVal = widget.serverResponse.answers[key];

      if (localVal != serverVal) {
        _conflictingFields.add(key);
        _resolutions[key] = 'local'; // default to local/workspace version
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.codeMerge, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Response 3-Way Conflict Resolver',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'This response was edited on the server while you were offline. Choose which values to keep for each conflicting field.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Conflict List
              Expanded(
                child: _conflictingFields.isEmpty
                    ? const Center(
                        child: Text(
                          'No conflicting fields found.',
                          style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _conflictingFields.length,
                        itemBuilder: (context, index) {
                          final field = _conflictingFields[index];
                          final localVal = widget.localResponse.answers[field]?.toString() ?? '(Not Answered)';
                          final serverVal = widget.serverResponse.answers[field]?.toString() ?? '(Not Answered)';
                          final resolution = _resolutions[field] ?? 'local';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Field Key Label
                                  Text(
                                    'Field: $field',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Side by Side Selection
                                  Row(
                                    children: [
                                      // Local Option
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[field] = 'local';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: resolution == 'local'
                                                  ? AppColors.primary.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'local'
                                                    ? AppColors.primary
                                                    : Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Your Offline Version',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  localVal,
                                                  style: const TextStyle(color: AppColors.textDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Server Option
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _resolutions[field] = 'server';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: resolution == 'server'
                                                  ? Colors.amber.withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: resolution == 'server'
                                                    ? Colors.amber.shade700
                                                    : Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Server Version',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber.shade700,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  serverVal,
                                                  style: const TextStyle(color: AppColors.textDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Action buttons footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.circleCheck, size: 16),
                    label: const Text(
                      'Save & Submit Resolved',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: () async {
                      final repository = ref.read(responseRepositoryProvider);
                      final syncService = ref.read(syncServiceProvider.notifier);
                      
                      // Reconstruct resolved answers mapping
                      final resolvedAnswers = Map<String, dynamic>.from(widget.localResponse.answers);
                      _resolutions.forEach((field, source) {
                        if (source == 'server') {
                          resolvedAnswers[field] = widget.serverResponse.answers[field];
                        }
                      });

                      final resolvedResponse = FormResponse(
                        id: widget.localResponse.id,
                        formId: widget.localResponse.formId,
                        organizationId: widget.localResponse.organizationId,
                        submittedBy: widget.localResponse.submittedBy,
                        submittedAt: DateTime.now(),
                        answers: resolvedAnswers,
                        status: 'submitted',
                      );

                      try {
                        await repository.submitProjectResponse(widget.projectId, resolvedResponse);
                        
                        // Successfully resolved and submitted! Clean from database queue
                        final db = ref.read(localDatabaseProvider);
                        await db.deletePendingUpload(widget.pendingUploadId);
                        
                        // Force refresh of pending items
                        await syncService.syncPendingSubmissions();

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ref.read(snackbarServiceProvider).showSuccess('Conflict resolved and submission saved!');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ref.read(snackbarServiceProvider).showError('Failed to save resolved submission: $e');
                        }
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
