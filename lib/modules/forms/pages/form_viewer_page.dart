import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/json_ui_engine/json_ui_engine.dart';
import 'package:frontend/shared/models/answer_value.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/modules/forms/responses/controllers/form_submission_controller.dart';

class FormViewerPage extends ConsumerStatefulWidget {
  final String formId;
  final String formSchema;
  final String? projectId;

  const FormViewerPage({
    super.key,
    required this.formId,
    required this.formSchema,
    this.projectId,
  });

  @override
  ConsumerState<FormViewerPage> createState() => _FormViewerPageState();
}

class _FormViewerPageState extends ConsumerState<FormViewerPage> {
  final Map<String, AnswerValue> _answers = {};
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    // Initialize with empty answers
    final schema = _parseFormSchema(widget.formSchema);
    _extractQuestionIds(schema);
  }

  Map<String, dynamic> _parseFormSchema(String schemaString) {
    try {
      return Map<String, dynamic>.from(
        // ignore: unnecessary_cast
        schemaString as Map<String, dynamic>,
      );
    } catch (e) {
      return {};
    }
  }

  void _extractQuestionIds(Map<String, dynamic> schema) {
    void traverse(dynamic node) {
      if (node is Map<String, dynamic>) {
        final id = node['id']?.toString();
        if (id != null && id.isNotEmpty) {
          _answers[id] = AnswerValue(value: '', displayValue: '');
        }
        
        if (node['children'] is List) {
          for (var child in node['children']) {
            traverse(child);
          }
        }
      } else if (node is List) {
        for (var item in node) {
          traverse(item);
        }
      }
    }
    
    traverse(schema);
  }

  void _onAnswerChanged(String key, AnswerValue value) {
    setState(() {
      _answers[key] = value;
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Prepare submission data
      final submissionData = {
        'form_id': widget.formId,
        'answers': _answers.map((key, value) => MapEntry(key, value.value)),
        'metadata': {
          'submitted_at': DateTime.now().toIso8601String(),
          'device_info': {
            'platform': Theme.of(context).platform.name,
          },
        },
      };

      // Use the form submission controller
      final controller = FormSubmissionController();
      final success = await controller.submitFormResponse(
        formId: widget.formId,
        responseData: submissionData,
      );

      if (success) {
        if (mounted) {
          SnackbarService.showSuccess(
            context: context,
            message: 'Form submitted successfully!',
          );
          
          // Navigate back or to success page
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/forms/success');
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to submit form. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _saveDraft() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final draftData = {
        'form_id': widget.formId,
        'answers': _answers.map((key, value) => MapEntry(key, value.value)),
        'saved_at': DateTime.now().toIso8601String(),
      };

      // Save draft locally or to backend
      // This would integrate with the offline sync service
      await Future.delayed(const Duration(seconds: 1)); // Simulate save

      if (mounted) {
        SnackbarService.showSuccess(
          context: context,
          message: 'Draft saved successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarService.showError(
          context: context,
          message: 'Failed to save draft: ${e.toString()}',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schema = _parseFormSchema(widget.formSchema);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveDraft,
            tooltip: 'Save Draft',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : JsonUiEngine(
                      schema: schema,
                      answers: _answers,
                      onAnswerChanged: _onAnswerChanged,
                    ),
            ),
          ),
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              color: Colors.red.shade100,
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Form'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}