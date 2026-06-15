import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/modules/forms/widgets/signature_pad_widget.dart';
import 'package:frontend/modules/forms/widgets/camera_capture_dialog.dart';
import 'package:frontend/modules/forms/widgets/language_switcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import '../../../../app/theme/app_colors.dart';
import 'package:frontend/shared/models/form_models.dart' hide Form;
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/models/section_layout_type.dart';
import 'package:frontend/modules/forms/responses/controllers/form_submission_controller.dart';
import '../../../../app/localization/locale_controller.dart';
import 'package:frontend/modules/forms/utility/preview_utils.dart';
import 'package:frontend/modules/forms/utility/form_logic_engine.dart';
import 'package:frontend/modules/forms/utility/layout_engine.dart';
import 'package:frontend/modules/forms/utility/form_action_button_utils.dart';
import 'package:frontend/modules/forms/utility/form_layout_utils.dart';
import 'package:frontend/modules/forms/utility/submission_error_utils.dart';
import 'package:frontend/modules/forms/models/form_question_option.dart';
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/core/app_exception.dart';

final previewFormDataProvider = StateProvider.autoDispose<Map<String, dynamic>>(
  (ref) => {},
);
final previewRepeatInstancesProvider =
    StateProvider.autoDispose<Map<String, int>>((ref) => {});
final previewCommittedSectionRowsProvider =
    StateProvider.autoDispose<Map<String, List<Map<String, dynamic>>>>(
      (ref) => {},
    );
final Map<String, List<TextEditingController>> _previewOtpControllers = {};
final Map<String, bool> _previewRichPreviewMode = {};

class FormPreviewPage extends ConsumerStatefulWidget {
  final BuilderForm form;
  final String projectId;

  const FormPreviewPage({super.key, required this.form, this.projectId = ''});

  @override
  ConsumerState<FormPreviewPage> createState() => _FormPreviewPageState();
}

class _FormPreviewPageState extends ConsumerState<FormPreviewPage> {
  int _currentStep = 0;
  bool _showSubmitted = false;
  bool _isReviewing = false;
  final _formKey = GlobalKey<FormState>();
  LogicEvaluationResult? _logicResult;
  final Map<String, String> _lastWebhookHashes = {};
  final Map<String, List<FormQuestionOption>> _dynamicOptions = {};
  final Map<String, String?> _fieldErrors = {};
  ProviderSubscription<Map<String, dynamic>>? _previewFormDataSubscription;

  @override
  void initState() {
    super.initState();
    _previewFormDataSubscription = ref.listenManual<Map<String, dynamic>>(
      previewFormDataProvider,
      (previous, next) => _handleDataChange(next),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final formData = ref.watch(previewFormDataProvider);
    _logicResult = FormLogicEngine.evaluate(widget.form, formData);
    final visibilityMap = _logicResult!.visibility;

    final formStyle = widget.form.style;
    final canvasColor = PreviewUtils.parseColor(
      formStyle.backgroundColor,
      AppColors.builderBackground,
    );
    final primaryColor = PreviewUtils.parseColor(
      formStyle.primaryColor,
      AppColors.primary,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      child: Scaffold(
        backgroundColor: canvasColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 0,
          leading: const SizedBox(),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PREVIEW MODE',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            const LanguageSwitcher(),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(previewFormDataProvider);
                ref.invalidate(previewRepeatInstancesProvider);
                ref.invalidate(previewCommittedSectionRowsProvider);
                setState(() {
                  _currentStep = 0;
                  _showSubmitted = false;
                  _isReviewing = false;
                  _dynamicOptions.clear();
                  _lastWebhookHashes.clear();
                  _fieldErrors.clear();
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: AppColors.textGrey,
                size: 20,
              ),
              label: const Text(
                'Reset',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.close,
                color: AppColors.textGrey,
                size: 20,
              ),
              label: const Text(
                'Close Preview',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            const SizedBox(width: 16),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.borderLight, height: 1),
          ),
        ),
        body: Form(key: _formKey, child: _buildBody(locale, visibilityMap)),
      ),
    );
  }

  @override
  void dispose() {
    _previewFormDataSubscription?.close();
    super.dispose();
  }

  String _interpolateUrl(String url, Map<String, dynamic> formData) {
    var finalUrl = url;
    formData.forEach((key, value) {
      finalUrl = finalUrl.replaceAll(
        '{$key}',
        Uri.encodeComponent(value?.toString() ?? ''),
      );
    });
    return finalUrl;
  }

  void _handleDataChange(Map<String, dynamic> formData) {
    final result = FormLogicEngine.evaluate(widget.form, formData);

    // 1. Handle value overrides (autofill)
    if (result.valueOverrides.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        bool changed = false;
        final currentData = ref.read(previewFormDataProvider);
        final newData = Map<String, dynamic>.from(currentData);

        result.valueOverrides.forEach((key, value) {
          if (currentData[key] != value) {
            newData[key] = value;
            changed = true;
          }
        });

        if (changed) {
          ref.read(previewFormDataProvider.notifier).state = newData;
        }
      });
    }

    // 2. Handle option overrides (cascading)
    if (result.optionOverrides.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _dynamicOptions.addAll(result.optionOverrides);

          // Reset invalid selections
          final currentData = ref.read(previewFormDataProvider);
          final updates = <String, dynamic>{};

          result.optionOverrides.forEach((fieldId, options) {
            final val = currentData[fieldId];
            if (val != null) {
              final exists = options.any((o) => o.value == val.toString());
              if (!exists) {
                updates[fieldId] = null;
              }
            }
          });

          if (updates.isNotEmpty) {
            ref
                .read(previewFormDataProvider.notifier)
                .update((s) => {...s, ...updates});
          }
        });
      });
    }

    // 3. Handle automation webhooks
    for (final wh in result.pendingWebhooks) {
      final resolvedUrl = _interpolateUrl(wh['url'] ?? '', formData);
      final baseKey = '${wh['url'] ?? ''}_${jsonEncode(wh['mappings'])}';
      if (_lastWebhookHashes[baseKey] != resolvedUrl) {
        _lastWebhookHashes[baseKey] = resolvedUrl;
        _triggerWebhook(wh, resolvedUrl);
      }
    }
  }

  Future<void> _triggerWebhook(
    Map<String, dynamic> config,
    String resolvedUrl,
  ) async {
    if (resolvedUrl.isEmpty) return;

    final mappings = config['mappings'] as List?;

    try {
      debugPrint('Triggering logic webhook: $resolvedUrl');

      final apiClient = ref.read(dioProvider);
      final response = await apiClient.get(resolvedUrl);
      final responseData = response.data;

      if (mappings != null && responseData is Map<String, dynamic>) {
        final updates = <String, dynamic>{};
        final optUpdates = <String, List<FormQuestionOption>>{};

        for (final m in mappings) {
          final key = m['responseKey'] as String?;
          final targetId = m['targetFieldId'] as String?;
          if (key != null && targetId != null) {
            final value = _getNestedValue(responseData, key);
            if (value != null) {
              if (value is List) {
                // If it's a list, treat as options update
                final newOptions = value
                    .map(
                      (o) => FormQuestionOption(
                        id: (o is Map ? (o['v'] ?? o['value'] ?? o['id']) : o)
                            .toString(),
                        label:
                            (o is Map ? (o['l'] ?? o['label'] ?? o['name']) : o)
                                .toString(),
                        value:
                            (o is Map ? (o['v'] ?? o['value'] ?? o['id']) : o)
                                .toString(),
                        order: 0,
                      ),
                    )
                    .toList();
                optUpdates[targetId] = newOptions;

                // Clear current value if not in new options
                final currentData = ref.read(previewFormDataProvider);
                final currentVal = currentData[targetId];
                if (currentVal != null) {
                  final exists = newOptions.any(
                    (o) => o.value == currentVal.toString(),
                  );
                  if (!exists) {
                    updates[targetId] = null;
                  }
                }
              } else {
                updates[targetId] = value;
              }
            }
          }
        }

        if (updates.isNotEmpty) {
          ref
              .read(previewFormDataProvider.notifier)
              .update((s) => {...s, ...updates});
        }
        if (optUpdates.isNotEmpty) {
          setState(() {
            _dynamicOptions.addAll(optUpdates);
          });
        }
      }
    } catch (e) {
      debugPrint('Webhook failed: $e');
    }
  }

  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    if (path.isEmpty) return data;
    final keys = path.split('.');
    dynamic current = data;
    for (final k in keys) {
      if (current is Map && current.containsKey(k)) {
        current = current[k];
      } else {
        return null;
      }
    }
    return current;
  }

  Widget _buildBody(String locale, Map<String, bool> visibilityMap) {
    if (_showSubmitted) {
      return _buildSuccessScreen(locale);
    }

    if (_isReviewing) {
      final formData = ref.watch(previewFormDataProvider);
      final visibleSections = widget.form.sections
          .where((s) => visibilityMap[s.id] ?? true)
          .toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: widget.form.style.maxWidth),
                child: Column(
                  children: [
                    const Icon(
                      Icons.rate_review,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Review Your Answers',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please double-check everything before submitting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ...visibleSections.map((section) {
              final visibleQuestions = section.questions
                  .where((q) => visibilityMap[q.id] ?? true)
                  .toList();
              if (visibleQuestions.isEmpty) {
                return const SizedBox.shrink();
              }

              final layout = section.layout;
              final isFullWidth = isWideSectionLayout(layout);
              final metadata = section.metaData;
              final maxSectionWidth = isFullWidth
                  ? sectionMaxWidth(layout, metadata)
                  : widget.form.style.maxWidth;

              final alignStr = metadata['alignment']?.toString() ?? 'left';
              AlignmentGeometry alignment = Alignment.centerLeft;
              if (alignStr == 'center') alignment = Alignment.center;
              if (alignStr == 'right') alignment = Alignment.centerRight;

              return Align(
                alignment: isFullWidth ? alignment : Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxSectionWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title.translate(locale).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.textGrey,
                          letterSpacing: 1,
                        ),
                      ),
                      const Divider(height: 24),
                      ...visibleQuestions.map((q) {
                        final val = formData[q.id];
                        String displayVal = val?.toString() ?? '—';
                        if (val is List) {
                          displayVal = val.join(', ');
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.label.translate(locale),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayVal,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.form.style.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _isReviewing = false),
                      child: const Text('Back to Edit'),
                    ),
                    _buildSubmitButton(small: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final formStyle = widget.form.style;

    if (widget.form.sections.isEmpty) {
      return _buildEmptyState();
    }

    Widget content;
    if (formStyle.layoutType == 'step') {
      content = _buildStepLayout(locale, visibilityMap);
    } else {
      content = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.form.title.translate(locale),
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: formStyle.sectionSpacing),
            _buildSectionsList(locale, visibilityMap),
            const SizedBox(height: 32),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                child: Column(
                  children: [
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Preview Mode: Workflow actions are not executed.',
                        style: TextStyle(
                          color: AppColors.textGrey.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: content,
    );
  }

  Widget _buildSuccessScreen(String locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Form Submitted Successfully!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thank you for your response.',
            style: TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => setState(() => _showSubmitted = false),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Back to Preview'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.fileLines,
            size: 48,
            color: AppColors.textGrey.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'This form is empty.',
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsList(String locale, Map<String, bool> visibilityMap) {
    final spacing = widget.form.style.sectionSpacing;
    final visibleSections = widget.form.sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (widget.form.layout == 'twoColumns') {
          crossAxisCount = 2;
        }
        if (widget.form.layout == 'threeColumns') {
          crossAxisCount = 3;
        }

        if (availableWidth < 600) {
          crossAxisCount = 1;
        } else if (availableWidth < 900 && crossAxisCount > 2) {
          crossAxisCount = 2;
        }

        final itemWidth =
            (availableWidth - (24 * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: 24,
          runSpacing: spacing,
          children: visibleSections.map((section) {
            final metadata = section.metaData;
            final maxSectionWidth =
                (metadata['maxWidth'] as num?)?.toDouble() ??
                widget.form.style.maxWidth;

            final alignStr = metadata['alignment']?.toString() ?? 'center';
            AlignmentGeometry alignment = Alignment.centerLeft;
            if (alignStr == 'center') alignment = Alignment.center;
            if (alignStr == 'right') alignment = Alignment.centerRight;

            return SizedBox(
              width: itemWidth,
              child: Align(
                alignment: alignment,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxSectionWidth),
                  child: _PreviewSectionWidget(
                    section: section,
                    questionSpacing: widget.form.style.questionSpacing,
                    visibilityMap: visibilityMap,
                    dynamicOptions: _dynamicOptions,
                    onTriggerAction: (config) => _triggerWebhook(
                      config,
                      _interpolateUrl(
                        config['url'] ?? '',
                        ref.read(previewFormDataProvider),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStepLayout(String locale, Map<String, bool> visibilityMap) {
    final sections = widget.form.sections;
    final visibleSections = sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    if (_currentStep >= visibleSections.length) {
      _currentStep = visibleSections.length - 1;
    }
    if (_currentStep < 0) {
      _currentStep = 0;
    }

    final currentSection = visibleSections.isEmpty
        ? null
        : visibleSections[_currentStep];
    final primaryColor = PreviewUtils.parseColor(
      widget.form.style.primaryColor,
      AppColors.primary,
    );

    if (currentSection == null) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value: visibleSections.isEmpty
              ? 0
              : (_currentStep + 1) / visibleSections.length,
          backgroundColor: AppColors.borderLight,
          color: primaryColor,
          minHeight: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.form.style.maxWidth,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Step ${_currentStep + 1} of ${visibleSections.length}',
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PreviewSectionWidget(
                      section: currentSection,
                      questionSpacing: widget.form.style.questionSpacing,
                      visibilityMap: visibilityMap,
                      dynamicOptions: _dynamicOptions,
                      onTriggerAction: (config) => _triggerWebhook(
                        config,
                        _interpolateUrl(
                          config['url'] ?? '',
                          ref.read(previewFormDataProvider),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: () => setState(() => _currentStep--),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Previous'),
                          )
                        else
                          const SizedBox(),
                        if (_currentStep < visibleSections.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? true) {
                                setState(() => _currentStep++);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Next'),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? true) {
                                setState(() => _isReviewing = true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Review & Submit'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton({bool small = false}) {
    final primaryColor = PreviewUtils.parseColor(
      widget.form.style.primaryColor,
      AppColors.primary,
    );
    final submissionState = ref.watch(formSubmissionControllerProvider);

    return buildPrimaryFormActionButton(
      onPressed: submissionState.isLoading
          ? null
          : () async {
                if (!(_formKey.currentState?.validate() ?? true)) {
                  ref
                      .read(snackbarServiceProvider)
                      .showError('Please fix errors in the form');
                  return;
                }

                final formData = ref.read(previewFormDataProvider);
                final submissionData = {
                  ...formData,
                  'preview': 'true',
                  'timestamp': DateFormat(
                    "E, d MMM y HH:mm:ss 'GMT'",
                  ).format(DateTime.now().toUtc()),
                };
                final result = FormLogicEngine.evaluate(widget.form, formData);
                final success = await ref
                    .read(formSubmissionControllerProvider.notifier)
                    .submit(
                      projectId: widget.projectId,
                      formId: widget.form.id,
                      answers: Map<String, dynamic>.from(submissionData),
                      visibilityMap: result.visibility,
                    );

                if (success) {
                  setState(() {
                    _showSubmitted = true;
                    _isReviewing = false;
                  });
                } else {
                  final errorState = ref
                      .read(formSubmissionControllerProvider)
                      .error;
                  if (errorState is ApiException &&
                      errorState.details != null &&
                      mounted) {
                    setState(() {
                      applySubmissionFieldErrors(
                        errorState.details,
                        (field, message) => _fieldErrors[field] = message,
                      );
                    });

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorState.message)));
                  }
                }
              },
      primaryColor: primaryColor,
      borderRadius: widget.form.style.globalBorderRadius,
      small: small,
      child: submissionState.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Submit'),
    );
  }

}

class _PreviewSectionWidget extends ConsumerStatefulWidget {
  final FormSection section;
  final double questionSpacing;
  final Map<String, bool> visibilityMap;
  final Map<String, List<FormQuestionOption>> dynamicOptions;
  final Future<void> Function(Map<String, dynamic>) onTriggerAction;

  const _PreviewSectionWidget({
    required this.section,
    required this.questionSpacing,
    required this.visibilityMap,
    required this.dynamicOptions,
    required this.onTriggerAction,
  });

  @override
  ConsumerState<_PreviewSectionWidget> createState() =>
      _PreviewSectionWidgetState();
}

class _PreviewSectionWidgetState extends ConsumerState<_PreviewSectionWidget> {
  bool _isExpanded = true;
  late final ScrollController _repeatTableScrollController;

  int _defaultRepeatCount(int? repeatMin) {
    if (repeatMin != null && repeatMin > 1) {
      return repeatMin;
    }
    return 1;
  }

  String _questionRepeatKey(FormQuestion question) {
    return '${widget.section.id}.${question.id}';
  }

  @override
  void initState() {
    super.initState();
    final metadata = widget.section.metaData;
    _isExpanded = metadata['startCollapsed'] == true ? false : true;
    _repeatTableScrollController = ScrollController();
  }

  @override
  void dispose() {
    _repeatTableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final style = section.style;
    final locale = ref.watch(localeControllerProvider).languageCode;
    final metadata = section.metaData;
    final canCollapse = metadata['allowCollapsing'] != false;
    final sectionIcon = metadata['icon'] as String?;
    final titleStyle = _sectionTypographyStyle(
      baseColor: metadata['titleColor']?.toString() ?? style.titleColor,
      fallbackColor: AppColors.textDark,
      sizeKey: 'titleSize',
      weightKey: 'titleWeight',
      fallbackSize: 18,
      metadata: metadata,
    );
    final descriptionStyle = _sectionTypographyStyle(
      baseColor: metadata['descColor']?.toString() ?? style.descriptionColor,
      fallbackColor: AppColors.textGrey,
      sizeKey: 'descSize',
      weightKey: 'descWeight',
      fallbackSize: 14,
      metadata: metadata,
    );
    final visibleQuestions = section.questions
        .where((q) => widget.visibilityMap[q.id] ?? true)
        .toList();
    final hasRepeatableContent =
        section.isRepeatable || visibleQuestions.any((q) => q.isRepeatable);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.borderRadius),
        side: BorderSide(
          color: PreviewUtils.parseColor(
            style.borderColor,
            AppColors.borderLight,
          ),
          width: style.borderWidth,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(style.padding),
        decoration: BoxDecoration(
          color: PreviewUtils.parseColor(style.backgroundColor, Colors.white),
          borderRadius: BorderRadius.circular(style.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: canCollapse
                  ? () => setState(() => _isExpanded = !_isExpanded)
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    if (sectionIcon != null && sectionIcon.isNotEmpty) ...[
                      Icon(
                        _iconForName(sectionIcon),
                        size: 20,
                        color: titleStyle.color ?? AppColors.textDark,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (section.title.translate(locale).isNotEmpty)
                            Text(
                              section.title.translate(locale),
                              style: titleStyle,
                            ),
                          if (section.description.translate(locale).isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                section.description.translate(locale),
                                style: descriptionStyle,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (canCollapse)
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textGrey,
                      ),
                  ],
                ),
              ),
            ),
            if (_isExpanded) ...[
              if (hasRepeatableContent) ...[
                _buildRepeatablePreviewTable(visibleQuestions, locale),
                const SizedBox(height: 16),
              ],
              _buildQuestionsGrid(visibleQuestions, widget.questionSpacing),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconForName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'person':
      case 'user':
        return Icons.person_outline;
      case 'location':
        return Icons.location_on_outlined;
      case 'payment':
        return Icons.payment;
      case 'contact':
        return Icons.contact_mail_outlined;
      case 'settings':
        return Icons.settings_outlined;
      case 'list':
        return Icons.list_alt;
      case 'help':
        return Icons.help_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  TextStyle _sectionTypographyStyle({
    required String baseColor,
    required Color fallbackColor,
    required String sizeKey,
    required String weightKey,
    required double fallbackSize,
    required Map<String, dynamic> metadata,
  }) {
    final color = PreviewUtils.parseColor(baseColor, fallbackColor);
    final size = (metadata[sizeKey] as num?)?.toDouble() ?? fallbackSize;
    final weight = switch (metadata[weightKey]?.toString()) {
      'medium' => FontWeight.w500,
      'bold' => FontWeight.bold,
      _ => FontWeight.normal,
    };
    return TextStyle(color: color, fontSize: size, fontWeight: weight);
  }

  Widget _buildRepeatablePreviewTable(
    List<FormQuestion> visibleQuestions,
    String locale,
  ) {
    final repeatableQuestions = visibleQuestions
        .where((q) => q.isRepeatable)
        .toList();
    final repeatInstances = ref.watch(previewRepeatInstancesProvider);
    final questionRepeatCounts = {
      for (final question in repeatableQuestions)
        question.id:
            repeatInstances[_questionRepeatKey(question)] ??
            _defaultRepeatCount(question.repeatMin),
    };
    final committedRows =
        ref.watch(previewCommittedSectionRowsProvider)[widget.section.id] ??
        <Map<String, dynamic>>[];
    final orderedTableQuestions = widget.section.isRepeatable
        ? (() {
            final questions = [...visibleQuestions];
            questions.sort((a, b) {
              int groupScore(FormQuestion q) {
                final label = q.label.translate(locale).toLowerCase();
                final id = q.id.toLowerCase();
                final text = '$label $id';
                final isLeft = text.contains('left');
                final isRight = text.contains('right');
                if (isLeft && !isRight) return 0;
                if (isRight && !isLeft) return 1;
                return 2;
              }

              final left = groupScore(a).compareTo(groupScore(b));
              if (left != 0) return left;
              return a.label
                  .translate(locale)
                  .compareTo(b.label.translate(locale));
            });
            return questions;
          })()
        : repeatableQuestions;
    final rowCount = widget.section.isRepeatable
        ? committedRows.length
        : questionRepeatCounts.values.fold<int>(
            1,
            (current, value) => value > current ? value : current,
          );

    final canAddSectionRow =
        widget.section.isRepeatable &&
        (widget.section.repeatMax == null ||
            committedRows.length < widget.section.repeatMax!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.section.isRepeatable
                ? 'Repeatable Section Preview'
                : 'Repeatable Question Preview',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.section.isRepeatable
                ? 'Each row represents one section entry.'
                : 'Each row represents one repeat of the repeatable questions in this section.',
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Scrollbar(
                  controller: _repeatTableScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  notificationPredicate: (notification) =>
                      notification.depth == 0,
                  child: SingleChildScrollView(
                    controller: _repeatTableScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 4),
                    child: DataTable(
                      horizontalMargin: 8,
                      columnSpacing: 8,
                      headingRowColor: WidgetStateProperty.all(Colors.white),
                      columns: [
                        const DataColumn(
                          label: SizedBox(
                            width: 32,
                            child: Text(
                              '#',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...orderedTableQuestions.map(
                          (q) => DataColumn(
                            label: SizedBox(
                              width: 110,
                              child: Text(
                                q.label.translate(locale),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const DataColumn(
                          label: SizedBox(
                            width: 64,
                            child: Text(
                              'Action',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(rowCount, (index) {
                        final row = committedRows[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(width: 32, child: Text('${index + 1}')),
                            ),
                            ...orderedTableQuestions.map((q) {
                              final value = row[q.id];
                              final cellText =
                                  value == null || value.toString().isEmpty
                                  ? '—'
                                  : (value is List
                                        ? value.join(', ')
                                        : value.toString());
                              return DataCell(
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    cellText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            DataCell(
                              SizedBox(
                                width: 64,
                                child: Row(
                                  children: [
                                    if (widget.section.isRepeatable)
                                      IconButton(
                                        tooltip: 'Remove row',
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          ref
                                              .read(
                                                previewCommittedSectionRowsProvider
                                                    .notifier,
                                              )
                                              .update((state) {
                                                final rows =
                                                    List<
                                                      Map<String, dynamic>
                                                    >.from(
                                                      state[widget
                                                              .section
                                                              .id] ??
                                                          const [],
                                                    );
                                                if (index < rows.length) {
                                                  rows.removeAt(index);
                                                }
                                                return {
                                                  ...state,
                                                  widget.section.id: rows,
                                                };
                                              });
                                        },
                                      )
                                    else if (index == rowCount - 1 &&
                                        canAddSectionRow)
                                      IconButton(
                                        tooltip: 'Add row',
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _commitSectionRow(
                                          orderedTableQuestions,
                                        ),
                                      )
                                    else
                                      const SizedBox(width: 40),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Text(
                    'Scroll horizontally to see all repeatable columns.',
                    style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.section.isRepeatable && canAddSectionRow)
                TextButton.icon(
                  onPressed: () => _commitSectionRow(orderedTableQuestions),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Add another ${widget.section.title.translate(locale)}',
                  ),
                ),
              ...repeatableQuestions
                  .where((q) {
                    final currentCount = questionRepeatCounts[q.id] ?? 1;
                    return q.repeatMax == null || currentCount < q.repeatMax!;
                  })
                  .map((q) {
                    return TextButton.icon(
                      onPressed: () {
                        final key = _questionRepeatKey(q);
                        ref
                            .read(previewRepeatInstancesProvider.notifier)
                            .update((state) {
                              final current =
                                  state[key] ??
                                  _defaultRepeatCount(q.repeatMin);
                              return {...state, key: current + 1};
                            });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('Add another ${q.label.translate(locale)}'),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void _commitSectionRow(List<FormQuestion> visibleQuestions) {
    final currentData = ref.read(previewFormDataProvider);
    final nextRow = <String, dynamic>{};
    for (final q in visibleQuestions) {
      nextRow[q.id] = currentData[q.id];
    }

    ref.read(previewCommittedSectionRowsProvider.notifier).update((state) {
      final rows = List<Map<String, dynamic>>.from(
        state[widget.section.id] ?? const [],
      );
      rows.add(nextRow);
      return {...state, widget.section.id: rows};
    });

    ref.read(previewFormDataProvider.notifier).update((state) {
      final next = Map<String, dynamic>.from(state);
      for (final q in visibleQuestions) {
        next.remove(q.id);
      }
      return next;
    });
  }

  Widget _buildQuestionsGrid(
    List<FormQuestion> visibleQuestions,
    double questionSpacing,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (widget.section.layout == sectionLayoutValue(SectionLayoutType.grid)) {
          crossAxisCount = widget.section.gridColumns;
        } else if (widget.section.layout ==
            sectionLayoutValue(SectionLayoutType.threeColumns)) {
          crossAxisCount = 3;
        }

        if (availableWidth < 400) {
          crossAxisCount = 1;
        } else if (availableWidth < 700 && crossAxisCount > 2) {
          crossAxisCount = 2;
        }

        final itemWidth =
            (availableWidth - (questionSpacing * (crossAxisCount - 1))) /
            crossAxisCount;

        final repeatInstances = ref.watch(previewRepeatInstancesProvider);
        return Wrap(
          spacing: questionSpacing,
          runSpacing: questionSpacing,
          children: visibleQuestions.expand((q) {
            double width = itemWidth;
            if (q.style.widthMode == 'fixed') {
              width = fixedFieldWidth(q.style.fixedWidth);
            } else {
              int span = LayoutEngine.getFieldSpan(q, crossAxisCount);
              width = (itemWidth * span) + (questionSpacing * (span - 1));
            }
            if (width > availableWidth) {
              width = availableWidth;
            }

            final repeatKey = _questionRepeatKey(q);
            final questionRepeatCount = q.isRepeatable
                ? (repeatInstances[repeatKey] ??
                      _defaultRepeatCount(q.repeatMin))
                : 1;

            return List.generate(questionRepeatCount, (questionIndex) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox(
                  width: width,
                  child: _PreviewFieldWidget(
                    question: q,
                    dynamicOptions: widget.dynamicOptions[q.id],
                    onTriggerAction: (config) => widget.onTriggerAction(config),
                    questionInstanceIndex: q.isRepeatable
                        ? questionIndex
                        : null,
                  ),
                ),
              );
            });
          }).toList(),
        );
      },
    );
  }
}

class _PreviewFieldWidget extends ConsumerStatefulWidget {
  final FormQuestion question;
  final List<FormQuestionOption>? dynamicOptions;
  final Future<void> Function(Map<String, dynamic>)? onTriggerAction;
  final int? questionInstanceIndex;

  const _PreviewFieldWidget({
    required this.question,
    this.dynamicOptions,
    this.onTriggerAction,
    this.questionInstanceIndex,
  });

  @override
  ConsumerState<_PreviewFieldWidget> createState() =>
      _PreviewFieldWidgetState();
}

class _PreviewFieldWidgetState extends ConsumerState<_PreviewFieldWidget> {
  late TextEditingController _controller;
  bool _isActionRunning = false;

  String get _fieldId {
    if (widget.questionInstanceIndex != null) {
      return '${widget.question.id}[${widget.questionInstanceIndex}]';
    }
    return widget.question.id;
  }

  @override
  void initState() {
    super.initState();
    final initialValue = ref.read(previewFormDataProvider)[_fieldId];
    _controller = TextEditingController(text: initialValue?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_PreviewFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final val = ref.read(previewFormDataProvider)[_fieldId];
    if (val?.toString() != _controller.text) {
      _controller.text = val?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final style = widget.question.style;
    final q = widget.question;

    final labelColor = PreviewUtils.parseColor(
      style.labelColor,
      AppColors.textDark,
    );
    final helperColor = PreviewUtils.parseColor(
      style.helperColor,
      AppColors.textGrey,
    );

    final labelWidget = Row(
      children: [
        Expanded(
          child: Text(
            q.label.translate(locale).isEmpty
                ? 'Untitled ${q.type.label}'
                : q.label.translate(locale) +
                      (widget.questionInstanceIndex != null
                          ? ' (${widget.questionInstanceIndex! + 1})'
                          : ''),
            style: TextStyle(
              color: labelColor,
              fontSize: style.labelFontSize,
              fontWeight: PreviewUtils.parseFontWeight(style.labelFontWeight),
            ),
          ),
        ),
        if (q.isRequired)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text('*', style: TextStyle(color: Colors.red)),
          ),
      ],
    );

    final String helperTranslated = q.helperText.translate(locale);
    final helperWidget = helperTranslated.isNotEmpty
        ? Text(
            helperTranslated,
            style: TextStyle(
              color: helperColor,
              fontSize: style.helperFontSize,
              fontWeight: PreviewUtils.parseFontWeight(style.helperFontWeight),
            ),
          )
        : null;

    final isActionField = q.actionConfig?.isNotEmpty ?? false;

    final fillColor = PreviewUtils.parseColor(
      style.backgroundColor,
      const Color(0xFFF0F7FF),
    );

    final borderColor = PreviewUtils.parseColor(
      style.borderColor,
      isActionField
          ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
          : const Color(0xFFCBD5E1),
    );

    return Container(
      margin: EdgeInsets.only(bottom: style.verticalMargin),
      padding: EdgeInsets.all(style.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.labelPosition != 'hidden') ...[
            if (style.labelPosition == 'left')
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: style.labelColumnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWidget,
                        if (helperWidget != null) ...[
                          const SizedBox(height: 4),
                          helperWidget,
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInput(
                      context,
                      ref,
                      locale,
                      fillColor,
                      borderColor,
                      isActionField,
                    ),
                  ),
                ],
              )
            else ...[
              labelWidget,
              if (helperWidget != null) ...[
                const SizedBox(height: 4),
                helperWidget,
              ],
              const SizedBox(height: 8),
              _buildInput(
                context,
                ref,
                locale,
                fillColor,
                borderColor,
                isActionField,
              ),
            ],
          ] else ...[
            _buildInput(
              context,
              ref,
              locale,
              fillColor,
              borderColor,
              isActionField,
            ),
            if (helperWidget != null) ...[
              const SizedBox(height: 4),
              helperWidget,
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInput(
    BuildContext context,
    WidgetRef ref,
    String locale,
    Color fillColor,
    Color borderColor,
    bool isActionField,
  ) {
    final q = widget.question;
    final style = q.style;

    final inputColor = PreviewUtils.parseColor(
      style.inputFontColor,
      AppColors.textDark,
    );
    final textStyle = TextStyle(
      color: inputColor,
      fontSize: style.inputFontSize,
      fontWeight: PreviewUtils.parseFontWeight(style.inputFontWeight),
    );

    final radius = style.borderRadius;

    OutlineInputBorder getBorder(Color color, {bool focused = false}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: color,
          width: focused ? 2 : style.borderWidth,
        ),
      );
    }

    final inputDecoration = InputDecoration(
      hintText: q.placeholder.translate(locale),
      hintStyle: textStyle.copyWith(color: AppColors.textGrey),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: getBorder(borderColor),
      enabledBorder: getBorder(borderColor),
      focusedBorder: getBorder(Theme.of(context).primaryColor, focused: true),
      errorBorder: getBorder(Colors.red),
      focusedErrorBorder: getBorder(Colors.red, focused: true),
      prefixIcon: style.prefixIcon.isNotEmpty
          ? Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(style.prefixIcon, style: textStyle),
              ),
            )
          : null,
      suffixIcon: _buildSuffix(context, q, textStyle),
    );

    String? validator(String? val) {
      return PreviewUtils.validateField(
        val,
        isRequired: q.isRequired,
        regex: q.validationRegex,
        minLength: q.minLength,
        maxLength: q.maxLength,
        minValue: q.minValue?.toDouble(),
        maxValue: q.maxValue?.toDouble(),
        customError: q.customErrorMessage,
      );
    }

    switch (q.type) {
      case QuestionType.shortText:
      case QuestionType.password:
      case QuestionType.number:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.tel:
      case QuestionType.url:
        return TextFormField(
          controller: _controller,
          style: textStyle,
          decoration: inputDecoration.copyWith(
            suffixText: (q.maxLength != null && !hasActionButton)
                ? '${_controller.text.length}/${q.maxLength}'
                : null,
          ),
          validator: validator,
          textInputAction: TextInputAction.next,
          keyboardType: q.type == QuestionType.number
              ? TextInputType.number
              : (q.type == QuestionType.email
                    ? TextInputType.emailAddress
                    : (q.type == QuestionType.mobile
                          ? TextInputType.phone
                          : TextInputType.text)),
          onChanged: (val) {
            ref
                .read(previewFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: val});
            setState(() {});
          },
        );

      case QuestionType.paragraph:
        return TextFormField(
          controller: _controller,
          style: textStyle,
          decoration: inputDecoration,
          maxLines: 5,
          minLines: 3,
          validator: validator,
          textInputAction: TextInputAction.newline,
          onChanged: (val) {
            ref
                .read(previewFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: val});
            setState(() {});
          },
        );

      case QuestionType.dropdown:
        final options = widget.dynamicOptions ?? q.options;
        final formData = ref.watch(previewFormDataProvider);
        const dropdownMenuTextStyle = TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
        );
        return DropdownButtonFormField<String>(
          initialValue: formData[_fieldId]?.toString(),
          style: textStyle,
          decoration: inputDecoration,
          dropdownColor: Colors.white,
          iconEnabledColor: AppColors.textGrey,
          menuMaxHeight: 360,
          items: options.map((opt) {
            return DropdownMenuItem<String>(
              value: opt.value,
              child: Text(opt.label, style: dropdownMenuTextStyle),
            );
          }).toList(),
          validator: (val) => q.isRequired && val == null ? 'Required' : null,
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(previewFormDataProvider.notifier)
                  .update((state) => {...state, _fieldId: val});
            }
          },
        );

      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        final options = q.options;
        final isRadio = q.type == QuestionType.multipleChoice;
        final formData = ref.watch(previewFormDataProvider);
        final currentValue = formData[_fieldId];

        // Check if these are image choices (enhanced UI)
        final isImageChoice = options.any(
          (opt) => opt.description.startsWith('http'),
        );

        return FormField<dynamic>(
          initialValue: currentValue,
          validator: (val) =>
              q.isRequired && (val == null || (val is List && val.isEmpty))
              ? 'Required'
              : null,
          builder: (state) {
            if (isImageChoice) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: options.map((opt) {
                      final isSelected = isRadio
                          ? currentValue == opt.value
                          : (currentValue as List?)?.contains(opt.value) ??
                                false;
                      final imageUrl = opt.description;
                      if (!imageUrl.startsWith('http')) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          if (isRadio) {
                            ref
                                .read(previewFormDataProvider.notifier)
                                .update((s) => {...s, _fieldId: opt.value});
                            state.didChange(opt.value);
                          } else {
                            final currentList = List<String>.from(
                              currentValue as List? ?? [],
                            );
                            if (isSelected) {
                              currentList.remove(opt.value);
                            } else {
                              currentList.add(opt.value);
                            }
                            ref
                                .read(previewFormDataProvider.notifier)
                                .update((s) => {...s, _fieldId: currentList});
                            state.didChange(currentList);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : AppColors.borderLight,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  opt.label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.hasError ? Colors.red : borderColor,
                    ),
                    borderRadius: BorderRadius.circular(radius),
                    color: fillColor,
                  ),
                  child: Column(
                    children: options.map((opt) {
                      final isSelected = isRadio
                          ? currentValue == opt.value
                          : (currentValue is List &&
                                currentValue.contains(opt.value));
                      return ListTile(
                        title: Text(opt.label, style: textStyle),
                        leading: Icon(
                          isRadio
                              ? (isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked)
                              : (isSelected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : AppColors.textGrey,
                        ),
                        dense: true,
                        onTap: () {
                          dynamic newValue;
                          if (isRadio) {
                            newValue = opt.value;
                          } else {
                            final list = List<String>.from(
                              currentValue is List ? currentValue : [],
                            );
                            if (list.contains(opt.value)) {
                              list.remove(opt.value);
                            } else {
                              list.add(opt.value);
                            }
                            newValue = list;
                          }
                          ref
                              .read(previewFormDataProvider.notifier)
                              .update((s) => {...s, _fieldId: newValue});
                          state.didChange(newValue);
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );

      case QuestionType.date:
        final formData = ref.watch(previewFormDataProvider);
        final dateStr = formData[_fieldId]?.toString() ?? '';
        return _buildPicker(
          text: dateStr.isEmpty ? 'Select Date' : dateStr,
          icon: Icons.calendar_today,
          decoration: inputDecoration,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(dateStr) ?? DateTime.now(),
              firstDate: q.dateMin ?? DateTime(1900),
              lastDate: q.dateMax ?? DateTime(2100),
            );
            if (date != null) {
              final val = DateFormat('yyyy-MM-dd').format(date);
              ref
                  .read(previewFormDataProvider.notifier)
                  .update((s) => {...s, _fieldId: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.time:
        final formData = ref.watch(previewFormDataProvider);
        final timeStr = formData[_fieldId]?.toString() ?? '';
        return _buildPicker(
          text: timeStr.isEmpty ? 'Select Time' : timeStr,
          icon: Icons.access_time,
          decoration: inputDecoration,
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              final val =
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
              ref
                  .read(previewFormDataProvider.notifier)
                  .update((s) => {...s, _fieldId: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.rating:
        final formData = ref.watch(previewFormDataProvider);
        final rating =
            double.tryParse(formData[_fieldId]?.toString() ?? '0') ?? 0;
        return Row(
          children: List.generate(5, (index) {
            final isSelected = index < rating;
            return IconButton(
              icon: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: isSelected ? Colors.orange : AppColors.textGrey,
                size: 32,
              ),
              onPressed: () {
                ref
                    .read(previewFormDataProvider.notifier)
                    .update((s) => {...s, _fieldId: index + 1});
              },
            );
          }),
        );

      case QuestionType.slider:
        final formData = ref.watch(previewFormDataProvider);
        final val =
            double.tryParse(
              formData[_fieldId]?.toString() ?? (q.minValue?.toString() ?? '0'),
            ) ??
            0.0;
        return Column(
          children: [
            Slider(
              value: val.clamp(
                q.minValue?.toDouble() ?? 0.0,
                q.maxValue?.toDouble() ?? 100.0,
              ),
              min: q.minValue?.toDouble() ?? 0.0,
              max: q.maxValue?.toDouble() ?? 100.0,
              divisions: 100,
              label: val.round().toString(),
              activeColor: Theme.of(context).primaryColor,
              onChanged: (newVal) {
                ref
                    .read(previewFormDataProvider.notifier)
                    .update((s) => {...s, _fieldId: newVal});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (q.minValue ?? 0).toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
                Text(
                  (q.maxValue ?? 100).toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ],
        );

      case QuestionType.fileUpload:
        return _buildFileUploadStub(q, inputDecoration, ref);

      case QuestionType.signature:
        return _buildSignatureField(q, ref, fillColor, borderColor);

      case QuestionType.matrixChoice:
        return _buildMatrixField(
          q,
          textStyle,
          ref,
          fillColor,
          borderColor,
          isActionField,
        );

      case QuestionType.divider:
        return const Divider(height: 32, thickness: 1);

      case QuestionType.spacer:
        return SizedBox(
          height: (q.metadata['spacerHeight'] as num?)?.toDouble() ?? 24,
        );

      case QuestionType.image:
        return _buildImageUploadField(q, ref);
      case QuestionType.otp:
        return _buildOtpField(q, inputDecoration, textStyle, ref);
      case QuestionType.richText:
      case QuestionType.markdownEditor:
        return _buildRichTextField(q, inputDecoration, textStyle, ref);
      case QuestionType.address:
      case QuestionType.addressLookup:
        return _buildSingleLineSpecialField(
          q,
          inputDecoration,
          textStyle,
          ref,
          locale,
          hint: 'Enter address',
        );
      case QuestionType.mapLocation:
        return _buildMultiLineSpecialField(
          q,
          inputDecoration,
          textStyle,
          ref,
          locale,
          hint: 'Enter location coordinates or address',
        );
      case QuestionType.booleanValue:
      case QuestionType.toggle:
        return _buildToggleField(q, ref, locale);
      case QuestionType.multiSelect:
      case QuestionType.multiCheckbox:
        return _buildMultiSelectField(q, ref, locale, textStyle);
      case QuestionType.multiFileUpload:
      case QuestionType.filePicker:
      case QuestionType.fileList:
      case QuestionType.file:
        return _buildFileFamilyField(q, ref, textStyle, locale);
      case QuestionType.imageGallery:
        return _buildImageGalleryField(q, ref, locale);
      case QuestionType.signaturePad:
        return _buildSignaturePadField(q, ref, locale);
      case QuestionType.colorPicker:
      case QuestionType.customField:
      case QuestionType.countrySelect:
      case QuestionType.stateSelect:
      case QuestionType.citySelect:
      case QuestionType.socialMediaHandle:
      case QuestionType.websiteUrl:
      case QuestionType.phoneNumber:
      case QuestionType.captcha:
      case QuestionType.unitSelect:
      case QuestionType.price:
      case QuestionType.age:
      case QuestionType.emailList:
      case QuestionType.qrCodeScan:
      case QuestionType.search:
        return _buildReadableSpecialField(q, textStyle, ref, locale);
      case QuestionType.calculate:
      case QuestionType.calculated:
        return _buildCalculatedField(q, ref, locale);
      case QuestionType.range:
        return _buildRangeField(q, ref, locale);
      case QuestionType.dateRange:
        return _buildDateRangeField(q, ref, locale);
      case QuestionType.timeRange:
        return _buildTimeRangeField(q, ref, locale);
      case QuestionType.stepper:
        return _buildStepperField(q, ref, locale);
    }
  }

  Widget _buildReadableSpecialField(
    FormQuestion q,
    TextStyle textStyle,
    WidgetRef ref,
    String locale,
  ) {
    if (q.type == QuestionType.captcha) {
      final checked = ref.watch(previewFormDataProvider)[_fieldId] == true;
      return CheckboxListTile(
        value: checked,
        onChanged: (val) {
          ref
              .read(previewFormDataProvider.notifier)
              .update((state) => {...state, _fieldId: val == true});
        },
        title: Text('I am not a robot', style: textStyle),
        contentPadding: EdgeInsets.zero,
      );
    }

    if (q.type == QuestionType.colorPicker) {
      final value =
          ref.watch(previewFormDataProvider)[_fieldId]?.toString() ?? '#000000';
      return TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: q.label.translate(locale),
          hintText: '#RRGGBB',
          suffixIcon: Container(
            margin: const EdgeInsets.all(10),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _tryParseColor(value) ?? Colors.transparent,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        onChanged: (val) => ref
            .read(previewFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val}),
      );
    }

    if (q.type == QuestionType.countrySelect ||
        q.type == QuestionType.stateSelect ||
        q.type == QuestionType.citySelect) {
      final options = (q.options)
          .map(
            (o) => o.label.translate(locale).isNotEmpty
                ? o.label.translate(locale)
                : o.value,
          )
          .where((v) => v.isNotEmpty)
          .toList();
      final current = ref.watch(previewFormDataProvider)[_fieldId]?.toString();
      if (options.isNotEmpty) {
        return DropdownButtonFormField<String>(
          initialValue: options.contains(current) ? current : null,
          decoration: InputDecoration(
            labelText: q.label.translate(locale),
            border: const OutlineInputBorder(),
          ),
          items: options
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => ref
              .read(previewFormDataProvider.notifier)
              .update((state) => {...state, _fieldId: val}),
        );
      }
    }

    if (q.type == QuestionType.qrCodeScan) {
      return _buildSingleLineSpecialField(
        q,
        InputDecoration(
          labelText: q.label.translate(locale),
          border: const OutlineInputBorder(),
        ),
        textStyle,
        ref,
        locale,
        hint: 'Scan or paste code',
      );
    }

    if (q.type == QuestionType.price ||
        q.type == QuestionType.age ||
        q.type == QuestionType.unitSelect) {
      return _buildSingleLineSpecialField(
        q,
        InputDecoration(
          labelText: q.label.translate(locale),
          border: const OutlineInputBorder(),
        ),
        textStyle,
        ref,
        locale,
        hint: q.type == QuestionType.price ? 'Enter price' : 'Enter value',
      );
    }

    return _buildSingleLineSpecialField(
      q,
      InputDecoration(
        labelText: q.label.translate(locale),
        border: const OutlineInputBorder(),
      ),
      textStyle,
      ref,
      locale,
      hint: q.type == QuestionType.websiteUrl
          ? 'Enter website URL'
          : q.type == QuestionType.socialMediaHandle
          ? 'Enter handle'
          : q.type == QuestionType.phoneNumber
          ? 'Enter phone number'
          : q.type == QuestionType.emailList
          ? 'Enter comma-separated emails'
          : 'Enter value',
    );
  }

  Color? _tryParseColor(String value) {
    final normalized = value.trim().replaceFirst('#', '');
    if (normalized.length == 6) {
      try {
        return Color(int.parse('FF$normalized', radix: 16));
      } catch (_) {}
    }
    return null;
  }

  Widget _buildOtpField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref,
  ) {
    final locale = ref.read(localeControllerProvider).languageCode;
    final codeLength = (q.metadata['codeLength'] as num?)?.toInt() ?? 6;
    final currentValue =
        ref.watch(previewFormDataProvider)[_fieldId]?.toString() ?? '';
    final controllers = _previewOtpControllers.putIfAbsent(
      _fieldId,
      () => List.generate(codeLength, (index) {
        final controller = TextEditingController();
        if (index < currentValue.length) {
          controller.text = currentValue[index];
        }
        return controller;
      }),
    );

    if (controllers.length != codeLength) {
      for (final c in controllers) {
        c.dispose();
      }
      _previewOtpControllers[_fieldId] = List.generate(codeLength, (index) {
        final controller = TextEditingController();
        if (index < currentValue.length) {
          controller.text = currentValue[index];
        }
        return controller;
      });
    }

    final otpFields = _previewOtpControllers[_fieldId]!;

    void syncOtp() {
      final value = otpFields.map((c) => c.text).join();
      ref
          .read(previewFormDataProvider.notifier)
          .update((state) => {...state, _fieldId: value});
      setState(() {});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.placeholder.translate(locale).isEmpty
              ? 'Enter $codeLength-digit code'
              : q.placeholder.translate(locale),
          style: textStyle.copyWith(color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(codeLength, (index) {
            return SizedBox(
              width: 48,
              child: TextFormField(
                controller: otpFields[index],
                style: textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: inputDecoration.copyWith(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    if (index < codeLength - 1) {
                      FocusScope.of(context).nextFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  } else if (index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                  syncOtp();
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRichTextField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref,
  ) {
    final locale = ref.read(localeControllerProvider).languageCode;
    final isMarkdown = q.type == QuestionType.markdownEditor;
    final previewMode = _previewRichPreviewMode[_fieldId] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(
                Icons.format_bold,
                size: 16,
                color: AppColors.primary,
              ),
              label: const Text('Bold'),
              backgroundColor: AppColors.builderElement.withValues(alpha: 0.35),
              side: BorderSide(color: AppColors.borderLight),
            ),
            Chip(
              avatar: const Icon(
                Icons.format_italic,
                size: 16,
                color: AppColors.primary,
              ),
              label: const Text('Italic'),
              backgroundColor: AppColors.builderElement.withValues(alpha: 0.35),
              side: BorderSide(color: AppColors.borderLight),
            ),
            if (isMarkdown)
              Chip(
                avatar: const Icon(
                  Icons.title,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: const Text('Heading'),
                backgroundColor:
                    AppColors.builderElement.withValues(alpha: 0.35),
                side: BorderSide(color: AppColors.borderLight),
              ),
            if (isMarkdown)
              Chip(
                avatar: const Icon(
                  Icons.format_list_bulleted,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: const Text('List'),
                backgroundColor:
                    AppColors.builderElement.withValues(alpha: 0.35),
                side: BorderSide(color: AppColors.borderLight),
              ),
            if (isMarkdown)
              Chip(
                avatar: const Icon(
                  Icons.link,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: const Text('Link'),
                backgroundColor:
                    AppColors.builderElement.withValues(alpha: 0.35),
                side: BorderSide(color: AppColors.borderLight),
              ),
            if (isMarkdown)
              ActionChip(
                avatar: Icon(
                  previewMode ? Icons.edit : Icons.visibility,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(previewMode ? 'Edit' : 'Preview'),
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.borderLight),
                onPressed: () {
                  setState(() {
                    _previewRichPreviewMode[_fieldId] = !previewMode;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (previewMode && isMarkdown)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ref
                          .watch(previewFormDataProvider)[_fieldId]
                          ?.toString()
                          .isNotEmpty ==
                      true
                  ? ref.watch(previewFormDataProvider)[_fieldId].toString()
                  : 'Markdown preview will appear here.',
              style: textStyle.copyWith(fontFamily: 'monospace', height: 1.4),
            ),
          )
        else
          TextFormField(
            controller: _controller,
            style: textStyle,
            decoration: inputDecoration.copyWith(
              hintText: q.placeholder.translate(locale).isEmpty
                  ? (isMarkdown
                        ? 'Write markdown...'
                        : 'Write your response...')
                  : q.placeholder.translate(locale),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: isMarkdown ? 10 : 8,
            minLines: isMarkdown ? 5 : 4,
            textInputAction: TextInputAction.newline,
            onChanged: (val) {
              ref
                  .read(previewFormDataProvider.notifier)
                  .update((state) => {...state, _fieldId: val});
              setState(() {});
            },
          ),
      ],
    );
  }

  Widget _buildSingleLineSpecialField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref,
    String locale, {
    required String hint,
  }) {
    return buildSpecialTextField(
      controller: _controller,
      textStyle: textStyle,
      decoration: inputDecoration.copyWith(
        hintText: q.placeholder.translate(locale).isEmpty
            ? hint
            : q.placeholder.translate(locale),
      ),
      onChanged: (val) {
        ref
            .read(previewFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val});
        setState(() {});
      },
    );
  }

  Widget _buildMultiLineSpecialField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref,
    String locale, {
    required String hint,
  }) {
    return buildSpecialTextField(
      controller: _controller,
      textStyle: textStyle,
      decoration: inputDecoration.copyWith(
        hintText: q.placeholder.translate(locale).isEmpty
            ? hint
            : q.placeholder.translate(locale),
      ),
      maxLines: 3,
      minLines: 2,
      onChanged: (val) {
        ref
            .read(previewFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val});
        setState(() {});
      },
    );
  }

  Widget _buildToggleField(FormQuestion q, WidgetRef ref, String locale) {
    final current = ref.read(previewFormDataProvider)[_fieldId] == true;
    final placeholder = q.placeholder;
    final title = placeholder == null || placeholder.trim().isEmpty
        ? q.type.label
        : placeholder;
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: current,
        onChanged: (val) {
          ref
              .read(previewFormDataProvider.notifier)
              .update((state) => {...state, _fieldId: val});
          setState(() {});
        },
        title: Text(title),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMultiSelectField(
    FormQuestion q,
    WidgetRef ref,
    String locale,
    TextStyle textStyle,
  ) {
    final options = q.options;
    final currentValue = ref.read(previewFormDataProvider)[_fieldId];
    final current = currentValue is List
        ? currentValue.cast<String>()
        : <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        final selected = current.contains(opt.value);
        return CheckboxListTile(
          value: selected,
          onChanged: (val) {
            final next = List<String>.from(current);
            if (val == true) {
              if (!next.contains(opt.value)) next.add(opt.value);
            } else {
              next.remove(opt.value);
            }
            ref
                .read(previewFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: next});
            setState(() {});
          },
          title: Text(opt.label, style: textStyle),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  bool get hasActionButton =>
      (widget.question.actionConfig ?? {})['hasButton'] ?? false;

  Widget? _buildSuffix(BuildContext context, FormQuestion q, TextStyle style) {
    final actionConfig = q.actionConfig ?? {};
    if ((actionConfig['hasButton'] ?? false)) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: ElevatedButton(
          onPressed: _isActionRunning
              ? null
              : () async {
                  setState(() => _isActionRunning = true);
                  if (widget.onTriggerAction != null) {
                    await widget.onTriggerAction!(actionConfig);
                  }
                  setState(() => _isActionRunning = false);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: _isActionRunning
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  actionConfig['buttonLabel'] ?? 'Search',
                  style: const TextStyle(fontSize: 12),
                ),
        ),
      );
    }

    if (q.style.suffixIcon.isNotEmpty) {
      return Center(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 8),
          child: Text(q.style.suffixIcon, style: style),
        ),
      );
    }
    return null;
  }

  Widget _buildImageUploadField(FormQuestion q, WidgetRef ref) {
    final formData = ref.watch(previewFormDataProvider);
    // Store image bytes as Uint8List in form data
    final imageBytes = formData[q.id];
    final hasImage = imageBytes is List && imageBytes.isNotEmpty;

    // ── Gallery picker (file browser) ─────────────────────────────
    Future<void> pickFromGallery() async {
      try {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1200,
        );
        if (picked != null) {
          final bytes = await picked.readAsBytes();
          ref
              .read(previewFormDataProvider.notifier)
              .update((s) => {...s, q.id: bytes});
        }
      } catch (e) {
        if (!mounted) return;
        ref.read(snackbarServiceProvider).showError('Could not pick image: $e');
      }
    }

    // ── Camera picker (browser getUserMedia) ──────────────────────
    Future<void> pickFromCamera() async {
      final bytes = await CameraCaptureDialog.show(context);
      if (bytes != null) {
        ref
            .read(previewFormDataProvider.notifier)
            .update((s) => {...s, q.id: bytes});
      }
    }

    void showPickerSheet() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetCtx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Select Image Source',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEFF6FF),
                    child: Icon(Icons.camera_alt, color: Color(0xFF3B82F6)),
                  ),
                  title: const Text('Camera'),
                  subtitle: const Text(
                    'Use browser camera — permission required',
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF0FDF4),
                    child: Icon(Icons.photo_library, color: Color(0xFF22C55E)),
                  ),
                  title: const Text('Gallery'),
                  subtitle: const Text('Choose from your files'),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    pickFromGallery();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: hasImage
          ? Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.memory(
                    imageBytes as Uint8List,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.brandBlue,
                            size: 18,
                          ),
                          onPressed: showPickerSheet,
                          tooltip: 'Change image',
                        ),
                      ),
                      const SizedBox(width: 6),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () => ref
                              .read(previewFormDataProvider.notifier)
                              .update((s) => {...s, q.id: null}),
                          tooltip: 'Remove image',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: showPickerSheet,
              borderRadius: BorderRadius.circular(8),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Tap to add image',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Camera or Gallery',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFileUploadStub(
    FormQuestion q,
    InputDecoration decoration,
    WidgetRef ref,
  ) {
    final formData = ref.watch(previewFormDataProvider);
    final fileEntry = formData[q.id];
    final fileName = fileEntry is Map
        ? fileEntry['name']?.toString() ?? ''
        : '';
    final fileSize = fileEntry is Map ? fileEntry['size'] as int? : null;

    // Determine allowed extensions from field validation config
    final allowedTypes = q.allowedFileTypes;
    final List<String>? extensions = allowedTypes.isNotEmpty
        ? _extensionsForTypes(allowedTypes)
        : null;

    Future<void> pickFile() async {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: extensions != null ? FileType.custom : FileType.any,
        allowedExtensions: extensions,
        withData: true,
      );
      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      ref.read(previewFormDataProvider.notifier).update(
            (s) => {
              ...s,
              q.id: {
                'name': file.name,
                'size': file.size,
                'bytes': file.bytes,
              },
            },
          );
    }

    String formatBytes(int bytes) {
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return InkWell(
      onTap: fileName.isEmpty ? pickFile : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: fileName.isEmpty
              ? Colors.grey.shade50
              : Theme.of(context).primaryColor.withValues(alpha: 0.05),
          border: Border.all(
            color: fileName.isEmpty
                ? AppColors.borderLight
                : Theme.of(context).primaryColor.withValues(alpha: 0.4),
            style: fileName.isEmpty ? BorderStyle.solid : BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: fileName.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to select a file',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    extensions != null
                        ? 'Allowed: .${extensions.join(', .')}'
                        : 'All file types accepted',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.insert_drive_file,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        if (fileSize != null)
                          Text(
                            formatBytes(fileSize),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => ref
                        .read(previewFormDataProvider.notifier)
                        .update((s) => {...s, q.id: null}),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.swap_horiz,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    tooltip: 'Change file',
                    onPressed: pickFile,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFileFamilyField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
    String locale,
  ) {
    final formData = ref.watch(previewFormDataProvider);
    final value = formData[q.id];
    final isMulti =
        q.type == QuestionType.multiFileUpload ||
        q.type == QuestionType.fileList;
    final isGallery = q.type == QuestionType.imageGallery;
    final allowedTypes = q.allowedFileTypes;
    final List<String>? extensions = allowedTypes.isNotEmpty
        ? _extensionsForTypes(allowedTypes)
        : null;

    Future<void> pickFiles() async {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: isMulti,
        type: isGallery
            ? FileType.image
            : (extensions != null ? FileType.custom : FileType.any),
        allowedExtensions: extensions,
        withData: true,
      );
      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

      final picked = result.files
          .map(
            (file) => <String, dynamic>{
              'name': file.name,
              'size': file.size,
              'bytes': file.bytes,
            },
          )
          .toList();

      ref.read(previewFormDataProvider.notifier).update((state) {
        final next = Map<String, dynamic>.from(state);
        next[q.id] = isMulti ? picked : picked.first;
        return next;
      });
    }

    final files = isMulti && value is List
        ? value.cast<Map>()
        : (value is Map ? [value] : <Map>[]);

    return InkWell(
      onTap: pickFiles,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: files.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isGallery
                        ? Icons.photo_library_outlined
                        : Icons.upload_file,
                    size: 40,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isGallery ? 'Tap to add images' : 'Tap to upload file',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isMulti ? 'Multiple files allowed' : 'Single file',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final f in files)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f['name']?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              ref.read(previewFormDataProvider.notifier).update(
                                (state) {
                                  final next = Map<String, dynamic>.from(state);
                                  if (isMulti && value is List) {
                                    final updated = List<Map>.from(value);
                                    updated.removeWhere(
                                      (e) => e['name'] == f['name'],
                                    );
                                    next[q.id] = updated;
                                  } else {
                                    next[q.id] = null;
                                  }
                                  return next;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  TextButton.icon(
                    onPressed: pickFiles,
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                      isMulti ? 'Add more' : 'Change file',
                      style: textStyle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildImageGalleryField(FormQuestion q, WidgetRef ref, String locale) {
    return _buildFileFamilyField(q, ref, const TextStyle(), locale);
  }

  Widget _buildSignaturePadField(FormQuestion q, WidgetRef ref, String locale) {
    final formData = ref.watch(previewFormDataProvider);
    final current = formData[q.id];
    if (current is Uint8List && current.isNotEmpty) {
      return Stack(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Image.memory(current)),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () =>
                  ref.read(previewFormDataProvider.notifier).update((state) {
                    final next = Map<String, dynamic>.from(state);
                    next[q.id] = null;
                    return next;
                  }),
            ),
          ),
        ],
      );
    }
    return SignaturePadWidget(
      onSigned: (data) {
        if (data.isNotEmpty) {
          try {
            ref.read(previewFormDataProvider.notifier).update((state) {
              final next = Map<String, dynamic>.from(state);
              next[q.id] = base64Decode(data);
              return next;
            });
          } catch (_) {}
        }
      },
    );
  }

  Widget _buildRangeField(FormQuestion q, WidgetRef ref, String locale) {
    final current =
        (ref.watch(previewFormDataProvider)[q.id] as num?)?.toDouble() ??
        (q.minValue?.toDouble() ?? 0.0);
    final min = q.minValue?.toDouble() ?? 0.0;
    final max = q.maxValue?.toDouble() ?? 100.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: current.clamp(min, max),
          min: min,
          max: max,
          divisions: ((max - min).abs() >= 1) ? ((max - min).toInt()) : null,
          label: current.round().toString(),
          onChanged: (v) =>
              ref.read(previewFormDataProvider.notifier).update((state) {
                final next = Map<String, dynamic>.from(state);
                next[q.id] = v;
                return next;
              }),
        ),
        Text('${current.toStringAsFixed(0)} / ${max.toStringAsFixed(0)}'),
      ],
    );
  }

  Widget _buildDateRangeField(FormQuestion q, WidgetRef ref, String locale) {
    final formData = ref.watch(previewFormDataProvider);
    final current = formData[q.id] as Map<String, dynamic>?;
    final label = current == null
        ? 'Select date range'
        : '${current['start'] ?? ''} - ${current['end'] ?? ''}';
    return _buildPicker(
      text: label,
      icon: Icons.date_range,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: q.dateMin ?? DateTime(1900),
          lastDate: q.dateMax ?? DateTime(2100),
          initialDateRange: current == null
              ? null
              : DateTimeRange(
                  start:
                      DateTime.tryParse(current['start']?.toString() ?? '') ??
                      DateTime.now(),
                  end:
                      DateTime.tryParse(current['end']?.toString() ?? '') ??
                      DateTime.now(),
                ),
        );
        if (picked != null) {
          ref.read(previewFormDataProvider.notifier).update((state) {
            final next = Map<String, dynamic>.from(state);
            next[q.id] = {
              'start': DateFormat('yyyy-MM-dd').format(picked.start),
              'end': DateFormat('yyyy-MM-dd').format(picked.end),
            };
            return next;
          });
        }
      },
    );
  }

  Widget _buildTimeRangeField(FormQuestion q, WidgetRef ref, String locale) {
    final formData = ref.watch(previewFormDataProvider);
    final current = formData[q.id] as Map<String, dynamic>?;
    final startText = current?['start']?.toString() ?? 'Start time';
    final endText = current?['end']?.toString() ?? 'End time';
    return Row(
      children: [
        Expanded(
          child: _buildPicker(
            text: startText,
            icon: Icons.schedule,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                ref.read(previewFormDataProvider.notifier).update((state) {
                  final next = Map<String, dynamic>.from(state);
                  next[q.id] = {
                    ...?current,
                    'start':
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                  };
                  return next;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPicker(
            text: endText,
            icon: Icons.schedule,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                ref.read(previewFormDataProvider.notifier).update((state) {
                  final next = Map<String, dynamic>.from(state);
                  next[q.id] = {
                    ...?current,
                    'end':
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                  };
                  return next;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStepperField(FormQuestion q, WidgetRef ref, String locale) {
    final current =
        (ref.watch(previewFormDataProvider)[q.id] as int?) ??
        (q.minValue?.toInt() ?? 0);
    final min = q.minValue?.toInt() ?? 0;
    final max = q.maxValue?.toInt() ?? 10;
    return Row(
      children: [
        IconButton(
          onPressed: current > min
              ? () =>
                    ref.read(previewFormDataProvider.notifier).update((state) {
                      final next = Map<String, dynamic>.from(state);
                      next[q.id] = current - 1;
                      return next;
                    })
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '$current',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: current < max
              ? () =>
                    ref.read(previewFormDataProvider.notifier).update((state) {
                      final next = Map<String, dynamic>.from(state);
                      next[q.id] = current + 1;
                      return next;
                    })
              : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildCalculatedField(FormQuestion q, WidgetRef ref, String locale) {
    final formula = q.metadata['formula']?.toString();
    final current = ref.watch(previewFormDataProvider)[q.id]?.toString();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.functions, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  formula?.isNotEmpty == true
                      ? 'Formula: $formula'
                      : 'Auto-calculated field',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            current?.isNotEmpty == true ? current! : 'Result will appear here',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'This value is read-only and expected to be derived from other answers.',
            style: TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  List<String> _extensionsForTypes(List<String> types) {
    final res = <String>[];
    for (final t in types) {
      if (t == 'images') res.addAll(['jpg', 'jpeg', 'png', 'webp']);
      if (t == 'documents') res.addAll(['pdf', 'doc', 'docx', 'txt']);
      if (t == 'spreadsheets') res.addAll(['xls', 'xlsx', 'csv']);
    }
    return res;
  }

  Widget _buildPicker({
    required String text,
    required IconData icon,
    required InputDecoration decoration,
    required VoidCallback onTap,
  }) {
    final borderRadius = _pickerBorderRadius(decoration);
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: InputDecorator(
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Icon(icon, size: 20, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  BorderRadius _pickerBorderRadius(InputDecoration decoration) {
    return switch (decoration.border) {
      final OutlineInputBorder border => border.borderRadius,
      final UnderlineInputBorder border => border.borderRadius,
      _ => BorderRadius.circular(8),
    };
  }

  Widget _buildSignatureField(
    FormQuestion q,
    WidgetRef ref,
    Color fill,
    Color border,
  ) {
    final formData = ref.watch(previewFormDataProvider);
    final signature = formData[q.id];

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: signature != null
          ? Stack(
              children: [
                Center(child: Image.memory(signature as Uint8List)),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => ref
                        .read(previewFormDataProvider.notifier)
                        .update((s) => {...s, q.id: null}),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () async {
                final bytes = await SignaturePadDialog.show(context);
                if (bytes != null) {
                  ref
                      .read(previewFormDataProvider.notifier)
                      .update((s) => {...s, q.id: bytes});
                }
              },
              child: const Center(
                child: Text(
                  'Tap to sign',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            ),
    );
  }

  Widget _buildMatrixField(
    FormQuestion q,
    TextStyle style,
    WidgetRef ref,
    Color fill,
    Color border,
    bool isAction,
  ) {
    final rows = (q.metadata['matrixRows'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    final cols = (q.metadata['matrixCols'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    final formData = ref.watch(previewFormDataProvider);
    final matrixData = formData[q.id] as Map<String, dynamic>? ?? {};

    return Container(
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 40,
          dataRowMinHeight: 40,
          columns: [
            const DataColumn(label: Text('')),
            ...cols.map((c) => DataColumn(label: Text(c, style: style))),
          ],
          rows: rows.map((r) {
            return DataRow(
              cells: [
                DataCell(
                  Text(r, style: style.copyWith(fontWeight: FontWeight.bold)),
                ),
                ...cols.map((c) {
                  return DataCell(
                    RadioGroup<String>(
                      groupValue: matrixData[r]?.toString(),
                      onChanged: (val) {
                        final newMatrix = Map<String, dynamic>.from(matrixData);
                        newMatrix[r] = val;
                        ref
                            .read(previewFormDataProvider.notifier)
                            .update((s) => {...s, q.id: newMatrix});
                      },
                      child: Radio<String>(value: c),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
