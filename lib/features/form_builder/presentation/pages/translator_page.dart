import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/translation_controller.dart';
import '../../domain/entities/translation_language.dart';
import '../../domain/entities/translation_job.dart';
import '../controllers/form_builder_controller.dart'; // Added import for FormBuilderController
import 'package:file_saver/file_saver.dart'; // Added import for FileSaver
import 'dart:convert'; // Added for jsonEncode
import 'dart:typed_data'; // Added for Uint8List
import '../../domain/entities/builder_form.dart'; // Add import for BuilderForm

/// Bulk Translator Page.
///
/// Provides interface for translating forms to multiple languages.
class TranslatorPage extends ConsumerStatefulWidget {
  final String formId;

  const TranslatorPage({super.key, required this.formId});

  @override
  ConsumerState<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends ConsumerState<TranslatorPage> {
  List<TranslationLanguage> _languages = [];
  final List<String> _selectedTargetLanguages = [];
  String _sourceLanguage = 'en';
  bool _isLoading = false;
  final _previewTextController = TextEditingController();
  String _previewResult = '';

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _loadTranslationJobs();
  }

  int _countTranslatableFields(BuilderForm form) {
    int count = 0;

    bool hasEn(Object? field) {
      if (field is Map) return field.containsKey('en');
      return field != null;
    }

    if (hasEn(form.title)) {
      count++;
    }

    for (final section in form.sections) {
      if (hasEn(section.title)) {
        count++;
      }
      if (hasEn(section.description)) {
        count++;
      }

      for (final question in section.questions) {
        if (hasEn(question.label)) {
          count++;
        }
        if (hasEn(question.helperText)) {
          count++;
        }
        if (hasEn(question.placeholder)) {
          count++;
        }

        if (question.options != null) {
          count += question.options!.length;
        }
      }
    }
    return count;
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await ref
          .read(translationControllerProvider.notifier)
          .loadLanguages();
      setState(() => _languages = languages);
    } catch (e) {
      _showError('Failed to load languages: $e');
    }
  }

  Future<void> _loadTranslationJobs() async {
    await ref
        .read(translationControllerProvider.notifier)
        .loadTranslationJobs(widget.formId);
  }

  Future<void> _startTranslation() async {
    if (_selectedTargetLanguages.isEmpty) {
      _showError('Please select at least one target language');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final formState = ref.read(formBuilderControllerProvider(widget.formId));
      final form = formState.value?.form;

      if (form == null) {
        _showError('Form data not available to start translation.');
        setState(() => _isLoading = false);
        return;
      }

      await ref
          .read(translationControllerProvider.notifier)
          .startTranslation(
            formId: widget.formId,
            sourceLanguage: _sourceLanguage,
            targetLanguages: _selectedTargetLanguages,
            totalFields: _countTranslatableFields(
              form,
            ), // Get actual field count
          );
      _showSuccess('Translation started!');
      await _loadTranslationJobs();
    } catch (e) {
      _showError('Failed to start translation: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _previewTranslation(String targetLanguage) async {
    if (_previewTextController.text.isEmpty) {
      _showError('Please enter text to translate');
      return;
    }

    try {
      final result = await ref
          .read(translationControllerProvider.notifier)
          .previewTranslation(
            text: _previewTextController.text,
            sourceLanguage: _sourceLanguage,
            targetLanguage: targetLanguage,
          );
      setState(() => _previewResult = result);
    } catch (e) {
      _showError('Preview failed: $e');
    }
  }

  Future<void> _cancelJob(String jobId) async {
    try {
      await ref
          .read(translationControllerProvider.notifier)
          .cancelTranslationJob(jobId);
      await _loadTranslationJobs();
      _showSuccess('Translation cancelled');
    } catch (e) {
      _showError('Failed to cancel: $e');
    }
  }

  Future<void> _deleteJob(String jobId) async {
    try {
      await ref
          .read(translationControllerProvider.notifier)
          .deleteTranslationJob(jobId);
      await _loadTranslationJobs();
    } catch (e) {
      _showError('Failed to delete: $e');
    }
  }

  Future<void> _downloadTranslations(String jobId) async {
    // Added download function
    try {
      final translatedContent = await ref
          .read(translationControllerProvider.notifier)
          .getTranslatedContent(
            jobId,
          ); // Assuming this method exists in the controller

      if (translatedContent != null) {
        // Format the content as JSON
        final String fileName =
            'form_${widget.formId}_translations_$jobId.json';
        final String fileContent = jsonEncode(translatedContent);

        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: Uint8List.fromList(utf8.encode(fileContent)),
          fileExtension: 'json',
          mimeType: MimeType.json,
        );
        _showSuccess('Translations downloaded successfully!');
      } else {
        _showError('No translated content found for this job.');
      }
    } catch (e) {
      _showError('Failed to download translations: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = ref.watch(translationControllerProvider);
    final activeJobs = jobs
        .where(
          (j) =>
              j.status == TranslationJobStatus.pending ||
              j.status == TranslationJobStatus.inProgress,
        )
        .toList();
    final completedJobs = jobs
        .where(
          (j) =>
              j.status == TranslationJobStatus.completed ||
              j.status == TranslationJobStatus.failed,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Translator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadLanguages();
              _loadTranslationJobs();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            _buildPreviewCard(),
            const SizedBox(height: 24),
            _buildTranslationActions(),
            const SizedBox(height: 24),
            _buildActiveJobs(activeJobs),
            const SizedBox(height: 24),
            _buildJobHistory(completedJobs),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Languages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sourceLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Source Language',
                      border: OutlineInputBorder(),
                    ),
                    items: _languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang.code,
                        child: Text(
                          '${lang.name} (${lang.nativeName ?? lang.name})',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _sourceLanguage = value!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Target Languages'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _languages.map((lang) {
                          final isSelected = _selectedTargetLanguages.contains(
                            lang.code,
                          );
                          return FilterChip(
                            selected: isSelected,
                            label: Text(lang.code.toUpperCase()),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTargetLanguages.add(lang.code);
                                } else {
                                  _selectedTargetLanguages.remove(lang.code);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview Translation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _previewTextController,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _selectedTargetLanguages.map((langCode) {
                  final lang = _languages.firstWhere(
                    (l) => l.code == langCode,
                    orElse: () =>
                        TranslationLanguage(code: langCode, name: langCode),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _previewTranslation(langCode),
                      icon: const Icon(Icons.translate),
                      label: Text(lang.code.toUpperCase()),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_previewResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.translate, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_previewResult)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading || _selectedTargetLanguages.isEmpty
                ? null
                : _startTranslation,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(
              _isLoading ? 'Translating...' : 'Start Bulk Translation',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveJobs(List<TranslationJob> jobs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Translations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (jobs.isEmpty)
              const Text('No active translation jobs')
            else
              ...jobs.map((job) => _buildJobCard(job)),
          ],
        ),
      ),
    );
  }

  Widget _buildJobHistory(List<TranslationJob> jobs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translation History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (jobs.isEmpty)
              const Text('No completed translation jobs')
            else
              ...jobs.map((job) => _buildJobCard(job, showActions: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(TranslationJob jobItem, {bool showActions = false}) {
    return ListTile(
      title: Row(
        children: [
          Text('→ ${jobItem.targetLanguages.join(', ').toUpperCase()}'),
          const Spacer(),
          _getStatusChip(jobItem.status),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (jobItem.status == TranslationJobStatus.inProgress)
            LinearProgressIndicator(value: jobItem.progress / 100),
          Text(
            'Created: ${jobItem.createdAt.toString().split('.').first}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: showActions
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (jobItem.status == TranslationJobStatus.completed)
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _downloadTranslations(
                      jobItem.id,
                    ), // Call download function
                  ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteJob(jobItem.id),
                ),
              ],
            )
          : jobItem.status == TranslationJobStatus.inProgress
          ? TextButton(
              onPressed: () => _cancelJob(jobItem.id),
              child: const Text('Cancel'),
            )
          : null,
    );
  }

  Widget _getStatusChip(TranslationJobStatus status) {
    Color color;
    String text;

    switch (status) {
      case TranslationJobStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case TranslationJobStatus.inProgress:
        color = Colors.blue;
        text = 'In Progress';
        break;
      case TranslationJobStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case TranslationJobStatus.failed:
        color = Colors.red;
        text = 'Failed';
        break;
      case TranslationJobStatus.cancelled:
        color = Colors.grey;
        text = 'Cancelled';
        break;
    }

    return Chip(
      label: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  @override
  void dispose() {
    _previewTextController.dispose();
    super.dispose();
  }
}
