import 'dart:convert';
import 'dart:async';
import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../widgets/signature_pad_widget.dart';
import '../widgets/camera_capture_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/entities/form_layout_type.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../../responses/presentation/controllers/form_submission_controller.dart';
import '../../../../core/localization/locale_controller.dart';
import '../utils/preview_utils.dart';
import '../utils/form_logic_engine.dart';
import '../utils/layout_engine.dart';
import '../../domain/entities/form_question_option.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../domain/repositories/form_builder_repository.dart';

final submitFormProvider = FutureProvider.autoDispose
    .family<BuilderForm, ({String formId, String projectId})>((ref, args) {
      return ref
          .watch(formBuilderRepositoryProvider)
          .getForm(args.projectId, args.formId);
    });

final submitFormDataProvider = StateProvider.autoDispose<Map<String, dynamic>>(
  (ref) => {},
);
final Map<String, List<TextEditingController>> _submitOtpControllers = {};
final Map<String, bool> _submitRichPreviewMode = {};

final repeatInstancesProvider = StateProvider.autoDispose<Map<String, int>>(
  (ref) => {},
);

class FormSubmitPage extends ConsumerStatefulWidget {
  final String formId;
  final String projectId;

  const FormSubmitPage({
    super.key,
    required this.formId,
    required this.projectId,
  });

  @override
  ConsumerState<FormSubmitPage> createState() => _FormSubmitPageState();
}

class _FormSubmitPageState extends ConsumerState<FormSubmitPage> {
  int _currentStep = 0;
  bool _showSubmitted = false;
  bool _isReviewing = false;
  final _formKey = GlobalKey<FormState>();
  LogicEvaluationResult? _logicResult;
  final Map<String, String> _lastWebhookHashes = {};
  final Map<String, List<FormQuestionOption>> _dynamicOptions = {};
  final Map<String, bool> _loadingFields = {};
  final Map<String, String?> _fieldErrors = {};
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
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

  int _defaultRepeatCount(int? repeatMin) {
    if (repeatMin != null && repeatMin > 1) {
      return repeatMin;
    }
    return 1;
  }

  String _questionRepeatKey(
    FormSection section,
    FormQuestion question, {
    bool inRepeatedSection = false,
  }) {
    return inRepeatedSection ? '${section.id}.${question.id}' : question.id;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveProjectId = widget.projectId;
    final asyncForm = ref.watch(
      submitFormProvider((
        formId: widget.formId,
        projectId: effectiveProjectId,
      )),
    );

    return asyncForm.when(
      data: (form) => _buildFormContent(context, form),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildFormContent(BuildContext context, BuilderForm form) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final formData = ref.watch(submitFormDataProvider);
    _logicResult = FormLogicEngine.evaluate(form, formData);
    final visibilityMap = _logicResult!.visibility;

    final formStyle = form.style;
    final canvasColor = PreviewUtils.parseColor(
      formStyle.backgroundColor,
      AppColors.builderBackground,
    );
    final primaryColor = PreviewUtils.parseColor(
      formStyle.primaryColor,
      AppColors.primary,
    );

    ref.listen<Map<String, dynamic>>(
      submitFormDataProvider,
      (previous, next) => _handleDataChange(form, next),
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
                  '',
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
            _buildLanguageSwitcher(),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(submitFormDataProvider);
                setState(() {
                  _currentStep = 0;
                  _showSubmitted = false;
                  _isReviewing = false;
                  _dynamicOptions.clear();
                  _lastWebhookHashes.clear();
                  _loadingFields.clear();
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
                'Close',
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
        body: Form(
          key: _formKey,
          child: _buildBody(
            form,
            locale,
            visibilityMap,
            _logicResult!.requiredStatus,
          ),
        ),
      ),
    );
  }

  void _handleDataChange(BuilderForm form, Map<String, dynamic> formData) {
    final result = FormLogicEngine.evaluate(form, formData);

    // 1. Handle value overrides (autofill)
    if (result.valueOverrides.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        bool changed = false;
        final currentData = ref.read(submitFormDataProvider);
        final newData = Map<String, dynamic>.from(currentData);

        result.valueOverrides.forEach((key, value) {
          if (currentData[key] != value) {
            newData[key] = value;
            changed = true;
          }
        });

        if (changed) {
          ref.read(submitFormDataProvider.notifier).state = newData;
        }
      });
    }

    // 2. Handle option overrides (cascading)
    if (result.optionOverrides.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _dynamicOptions.addAll(result.optionOverrides);

          // Reset invalid selections
          final currentData = ref.read(submitFormDataProvider);
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
                .read(submitFormDataProvider.notifier)
                .update((s) => {...s, ...updates});
          }
        });
      });
    }

    // 3. Handle automation webhooks
    if (result.pendingWebhooks.isNotEmpty) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        final currentData = ref.read(submitFormDataProvider);
        for (final wh in result.pendingWebhooks) {
          final resolvedUrl = _interpolateUrl(wh['url'], currentData);
          final baseKey = '${wh['url']}_${jsonEncode(wh['mappings'])}';
          if (_lastWebhookHashes[baseKey] != resolvedUrl) {
            _lastWebhookHashes[baseKey] = resolvedUrl;
            _triggerWebhook(wh, resolvedUrl);
          }
        }
      });
    }
  }

  Future<void> _triggerWebhook(
    Map<String, dynamic> config,
    String resolvedUrl,
  ) async {
    final mappings = config['mappings'] as List?;

    // Identify target fields for loading state
    final targetFieldIds =
        mappings
            ?.map((m) => m['targetFieldId'] as String?)
            .whereType<String>()
            .toList() ??
        [];

    try {
      setState(() {
        for (final id in targetFieldIds) {
          _loadingFields[id] = true;
          _fieldErrors[id] = null;
        }
      });

      debugPrint('Triggering logic webhook: $resolvedUrl');

      final apiClient = ref.read(apiClientProvider);
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
                final currentData = ref.read(submitFormDataProvider);
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

        if (!mounted) return;

        if (updates.isNotEmpty) {
          ref
              .read(submitFormDataProvider.notifier)
              .update((s) => {...s, ...updates});
        }

        setState(() {
          if (optUpdates.isNotEmpty) {
            _dynamicOptions.addAll(optUpdates);
          }
          for (final id in targetFieldIds) {
            _loadingFields[id] = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Webhook failed: $e');
      if (mounted) {
        setState(() {
          for (final id in targetFieldIds) {
            _loadingFields[id] = false;
            _fieldErrors[id] = 'Failed to load options';
          }
        });
      }
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

  Widget _buildBody(
    BuilderForm form,
    String locale,
    Map<String, bool> visibilityMap,
    Map<String, bool> requiredMap,
  ) {
    if (_showSubmitted) {
      return _buildSuccessScreen(locale);
    }

    if (_isReviewing) {
      return _buildReviewScreen(form, locale, visibilityMap);
    }

    final formStyle = form.style;

    if (form.sections.isEmpty) {
      return _buildEmptyState();
    }

    Widget content;
    if (formStyle.layoutType == 'step') {
      content = _buildStepLayout(form, locale, visibilityMap, requiredMap);
    } else {
      content = SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                child: _buildFormHeader(form, locale),
              ),
            ),
            SizedBox(height: formStyle.sectionSpacing),
            _buildSectionsList(form, locale, visibilityMap, requiredMap),
            const SizedBox(height: 32),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
                child: Column(
                  children: [
                    _buildSubmitButton(form),
                    const SizedBox(height: 16),
                    _buildPreviewFooter(),
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

  Widget _buildReviewScreen(
    BuilderForm form,
    String locale,
    Map<String, bool> visibilityMap,
  ) {
    final formData = ref.watch(submitFormDataProvider);
    final visibleSections = form.sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: form.style.maxWidth),
              child: Column(
                children: [
                  const Icon(Icons.rate_review, size: 48, color: AppColors.primary),
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
          ...visibleSections.expand((section) {
            final visibleQuestions = section.questions
                .where((q) => visibilityMap[q.id] ?? true)
                .toList();
            if (visibleQuestions.isEmpty) return [const SizedBox.shrink()];

            final repeatCount = section.isRepeatable
                ? (ref.watch(repeatInstancesProvider)[section.id] ??
                      _defaultRepeatCount(section.repeatMin))
                : 1;

            final layout = section.layout;
            final isFullWidth = layout == SectionLayoutType.fullWidth || layout == SectionLayoutType.dashboard || layout == SectionLayoutType.centered;
            final metadata = section.metaData;
            final sectionMaxWidth = isFullWidth 
                ? ((metadata['maxWidth'] as num?)?.toDouble() ?? (layout == SectionLayoutType.centered ? 760.0 : 1200.0))
                : form.style.maxWidth;
                
            final alignStr = metadata['alignment']?.toString() ?? 'left';
            AlignmentGeometry alignment = Alignment.centerLeft;
            if (alignStr == 'center') alignment = Alignment.center;
            if (alignStr == 'right') alignment = Alignment.centerRight;

            final widgets = <Widget>[];

            for (int i = 0; i < repeatCount; i++) {
              widgets.add(
                Align(
                  alignment: isFullWidth ? alignment : Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: sectionMaxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title.translate(locale).toUpperCase() +
                              (section.isRepeatable ? ' (${i + 1})' : ''),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.textGrey,
                            letterSpacing: 1,
                          ),
                        ),
                        const Divider(height: 24),
                        ...visibleQuestions.expand((q) {
                          final repeatKey = _questionRepeatKey(
                            section,
                            q,
                            inRepeatedSection: section.isRepeatable,
                          );
                          final questionRepeatCount = q.isRepeatable
                              ? (ref.watch(
                                      repeatInstancesProvider,
                                    )[repeatKey] ??
                                    _defaultRepeatCount(q.repeatMin))
                              : 1;

                          return List.generate(questionRepeatCount, (qIndex) {
                            final fieldId = section.isRepeatable
                                ? (q.isRepeatable
                                      ? '${section.id}[$i].${q.id}[$qIndex]'
                                      : '${section.id}[$i].${q.id}')
                                : (q.isRepeatable ? '${q.id}[$qIndex]' : q.id);
                            final val = formData[fieldId];
                            String displayVal = val?.toString() ?? '—';
                            if (val is List) displayVal = val.join(', ');

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q.label.translate(locale) +
                                        (q.isRepeatable
                                            ? ' (${qIndex + 1})'
                                            : ''),
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
                          });
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            }
            return widgets;
          }),
          const SizedBox(height: 32),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: form.style.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => setState(() => _isReviewing = false),
                    child: const Text('Back to Edit'),
                  ),
                  _buildSubmitButton(form, small: true),
                ],
              ),
            ),
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
          Icon(
            FontAwesomeIcons.fileLines,
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

  Widget _buildFormHeader(BuilderForm form, String locale) {
    return Container(
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
        form.title.translate(locale),
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionsList(
    BuilderForm form,
    String locale,
    Map<String, bool> visibilityMap,
    Map<String, bool> requiredMap,
  ) {
    final spacing = form.style.sectionSpacing;
    final visibleSections = form.sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (form.layout == FormLayoutType.twoColumns) crossAxisCount = 2;
        if (form.layout == FormLayoutType.threeColumns) {
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
          children: visibleSections.expand((section) {
            final repeatCount = section.isRepeatable
                ? (ref.watch(repeatInstancesProvider)[section.id] ??
                      _defaultRepeatCount(section.repeatMin))
                : 1;

            final metadata = section.metaData;
            final sectionMaxWidth = (metadata['maxWidth'] as num?)?.toDouble() ?? form.style.maxWidth;
                
            final alignStr = metadata['alignment']?.toString() ?? 'center';
            AlignmentGeometry alignment = Alignment.centerLeft;
            if (alignStr == 'center') alignment = Alignment.center;
            if (alignStr == 'right') alignment = Alignment.centerRight;

            final widgets = <Widget>[];

            for (int i = 0; i < repeatCount; i++) {
              widgets.add(
                SizedBox(
                  width: itemWidth,
                  child: Align(
                    alignment: alignment,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: sectionMaxWidth),
                      child: _SubmitSectionWidget(
                        section: section,
                        questionSpacing: form.style.questionSpacing,
                        visibilityMap: visibilityMap,
                        requiredMap: requiredMap,
                        dynamicOptions: _dynamicOptions,
                        loadingFields: _loadingFields,
                        fieldErrors: _fieldErrors,
                        onTriggerAction: (config) => _triggerWebhook(
                          config,
                          _interpolateUrl(
                            config['url'] ?? '',
                            ref.read(submitFormDataProvider),
                          ),
                        ),
                        instanceIndex: section.isRepeatable ? i : null,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (section.isRepeatable &&
                (section.repeatMax == null ||
                    repeatCount < section.repeatMax!)) {
              widgets.add(
                SizedBox(
                  width: itemWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        ref.read(repeatInstancesProvider.notifier).update((
                          state,
                        ) {
                          final current =
                              state[section.id] ??
                              _defaultRepeatCount(section.repeatMin);
                          return {...state, section.id: current + 1};
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add another ${section.title.translate(locale)}',
                      ),
                    ),
                  ),
                ),
              );
            }

            return widgets;
          }).toList(),
        );
      },
    );
  }

  Widget _buildStepLayout(
    BuilderForm form,
    String locale,
    Map<String, bool> visibilityMap,
    Map<String, bool> requiredMap,
  ) {
    final sections = form.sections;
    final visibleSections = sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    if (_currentStep >= visibleSections.length) {
      _currentStep = visibleSections.length - 1;
    }
    if (_currentStep < 0) _currentStep = 0;

    final currentSection = visibleSections.isEmpty
        ? null
        : visibleSections[_currentStep];
    final primaryColor = PreviewUtils.parseColor(
      form.style.primaryColor,
      AppColors.primary,
    );

    if (currentSection == null) return _buildEmptyState();

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
                constraints: BoxConstraints(maxWidth: form.style.maxWidth),
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
                    Builder(
                      builder: (context) {
                        final repeatCount = currentSection.isRepeatable
                            ? (ref.watch(
                                    repeatInstancesProvider,
                                  )[currentSection.id] ??
                                  _defaultRepeatCount(currentSection.repeatMin))
                            : 1;

                        final widgets = <Widget>[];
                        for (int i = 0; i < repeatCount; i++) {
                          widgets.add(
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _SubmitSectionWidget(
                                section: currentSection,
                                questionSpacing: form.style.questionSpacing,
                                visibilityMap: visibilityMap,
                                requiredMap: requiredMap,
                                dynamicOptions: _dynamicOptions,
                                loadingFields: _loadingFields,
                                fieldErrors: _fieldErrors,
                                onTriggerAction: (config) => _triggerWebhook(
                                  config,
                                  _interpolateUrl(
                                    config['url'] ?? '',
                                    ref.read(submitFormDataProvider),
                                  ),
                                ),
                                instanceIndex: currentSection.isRepeatable
                                    ? i
                                    : null,
                              ),
                            ),
                          );
                        }

                        if (currentSection.isRepeatable &&
                            (currentSection.repeatMax == null ||
                                repeatCount < currentSection.repeatMax!)) {
                          widgets.add(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () {
                                  ref
                                      .read(repeatInstancesProvider.notifier)
                                      .update((state) {
                                        final current =
                                            state[currentSection.id] ??
                                            _defaultRepeatCount(
                                              currentSection.repeatMin,
                                            );
                                        return {
                                          ...state,
                                          currentSection.id: current + 1,
                                        };
                                      });
                                },
                                icon: const Icon(Icons.add),
                                label: Text(
                                  'Add another ${currentSection.title.translate(locale)}',
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: widgets,
                        );
                      },
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

  Widget _buildSubmitButton(BuilderForm form, {bool small = false}) {
    final primaryColor = PreviewUtils.parseColor(
      form.style.primaryColor,
      AppColors.primary,
    );
    final submissionState = ref.watch(formSubmissionControllerProvider);

    return Center(
      child: ElevatedButton(
        onPressed: submissionState.isLoading
            ? null
            : () async {
                if (!(_formKey.currentState?.validate() ?? true)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fix errors in the form'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final formData = ref.read(submitFormDataProvider);
                final repeatInstances = ref.read(repeatInstancesProvider);
                final submissionData = {
                  ...formData,

                  'timestamp': DateFormat(
                    "E, d MMM y HH:mm:ss 'GMT'",
                  ).format(DateTime.now().toUtc()),
                };
                final success = await ref
                    .read(formSubmissionControllerProvider.notifier)
                    .submit(
                      projectId: widget.projectId,
                      formId: form.id,
                      answers: submissionData,
                      visibilityMap: _logicResult!.visibility,
                      repeatInstances: repeatInstances,
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
                      if (errorState.details is Map) {
                        (errorState.details as Map).forEach((key, value) {
                          _fieldErrors[key.toString()] = value.toString();
                        });
                      } else if (errorState.details is List) {
                        for (final err in (errorState.details as List)) {
                          if (err is Map &&
                              err.containsKey('field') &&
                              err.containsKey('message')) {
                            _fieldErrors[err['field'].toString()] =
                                err['message'].toString();
                          }
                        }
                      }
                    });

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(errorState.message)));
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: small ? 32 : 48,
            vertical: small ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(form.style.globalBorderRadius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
      ),
    );
  }

  Widget _buildPreviewFooter() {
    return Center(
      child: Text(
        '',
        style: TextStyle(
          color: AppColors.textGrey.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    final currentLocale = ref.watch(localeControllerProvider);

    return PopupMenuButton<String>(
      tooltip: 'Change Language',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 20, color: AppColors.textGrey),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
      onSelected: (code) =>
          ref.read(localeControllerProvider.notifier).setLocale(code),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'en', child: Text('English (EN)')),
        const PopupMenuItem(value: 'es', child: Text('Spanish (ES)')),
        const PopupMenuItem(value: 'fr', child: Text('French (FR)')),
        const PopupMenuItem(value: 'hi', child: Text('Hindi (HI)')),
      ],
    );
  }
}

class _SubmitSectionWidget extends ConsumerWidget {
  final FormSection section;
  final double questionSpacing;
  final Map<String, bool> visibilityMap;
  final Map<String, bool> requiredMap;
  final Map<String, List<FormQuestionOption>> dynamicOptions;
  final Map<String, bool> loadingFields;
  final Map<String, String?> fieldErrors;
  final Future<void> Function(Map<String, dynamic>) onTriggerAction;
  final int? instanceIndex;

  const _SubmitSectionWidget({
    required this.section,
    required this.questionSpacing,
    required this.visibilityMap,
    required this.requiredMap,
    required this.dynamicOptions,
    required this.loadingFields,
    required this.fieldErrors,
    required this.onTriggerAction,
    this.instanceIndex,
  });

  int _defaultRepeatCount(int? repeatMin) {
    if (repeatMin != null && repeatMin > 1) {
      return repeatMin;
    }
    return 1;
  }

  String _questionRepeatKey(FormQuestion question) {
    return instanceIndex != null ? '${section.id}.${question.id}' : question.id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = section.style;
    final locale = ref.watch(localeControllerProvider).languageCode;

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
            if (section.title.translate(locale).isNotEmpty) ...[
              Text(
                section.title.translate(locale) +
                    (instanceIndex != null ? ' (${instanceIndex! + 1})' : ''),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PreviewUtils.parseColor(
                    style.titleColor,
                    AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (section.description.translate(locale).isNotEmpty) ...[
              Text(
                section.description.translate(locale),
                style: TextStyle(
                  fontSize: 14,
                  color: PreviewUtils.parseColor(
                    style.descriptionColor,
                    AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildQuestionsGrid(visibilityMap, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsGrid(Map<String, bool> visibilityMap, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (section.layout == SectionLayoutType.grid) {
          crossAxisCount = section.gridColumns;
        } else if (section.layout == SectionLayoutType.threeColumns) {
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

        final visibleQuestions = section.questions
            .where((q) => visibilityMap[q.id] ?? true)
            .toList();

        return Wrap(
          spacing: questionSpacing,
          runSpacing: questionSpacing,
          children: visibleQuestions.map((q) {
            double width = itemWidth;
            if (q.style.widthMode == 'fixed') {
              switch (q.style.fixedWidth) {
                case 'small':
                  width = 200.0;
                  break;
                case 'medium':
                  width = 400.0;
                  break;
                case 'large':
                  width = 600.0;
                  break;
                default:
                  width = 200.0;
              }
            } else {
              int span = LayoutEngine.getFieldSpan(q, crossAxisCount);
              width = (itemWidth * span) + (questionSpacing * (span - 1));
            }
            if (width > availableWidth) width = availableWidth;

            final repeatKey = _questionRepeatKey(q);
            final repeatCount = q.isRepeatable
                ? (ref.watch(repeatInstancesProvider)[repeatKey] ??
                      _defaultRepeatCount(q.repeatMin))
                : 1;

            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(repeatCount, (qIndex) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: qIndex == repeatCount - 1 ? 0 : 12,
                        ),
                        child: _SubmitFieldWidget(
                          question: q,
                          dynamicOptions: dynamicOptions[q.id],
                          isLoading: loadingFields[q.id] ?? false,
                          error: fieldErrors[q.id],
                          onTriggerAction: (config) => onTriggerAction(config),
                          instanceIndex: instanceIndex,
                          questionInstanceIndex: q.isRepeatable ? qIndex : null,
                          sectionId: section.id,
                          isRequired: requiredMap[q.id] ?? q.isRequired,
                        ),
                      );
                    }),
                    if (q.isRepeatable &&
                        (q.repeatMax == null ||
                            repeatCount < q.repeatMax!)) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () {
                            ref.read(repeatInstancesProvider.notifier).update((
                              state,
                            ) {
                              final current =
                                  state[repeatKey] ??
                                  _defaultRepeatCount(q.repeatMin);
                              return {...state, repeatKey: current + 1};
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            'Add another ${q.label.translate(locale)}',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SubmitFieldWidget extends ConsumerStatefulWidget {
  final FormQuestion question;
  final List<FormQuestionOption>? dynamicOptions;
  final bool isLoading;
  final String? error;
  final Future<void> Function(Map<String, dynamic>)? onTriggerAction;
  final int? instanceIndex;
  final int? questionInstanceIndex;
  final String? sectionId;
  final bool isRequired;

  const _SubmitFieldWidget({
    required this.question,
    this.dynamicOptions,
    this.isLoading = false,
    this.error,
    this.onTriggerAction,
    this.instanceIndex,
    this.questionInstanceIndex,
    this.sectionId,
    this.isRequired = false,
  });

  @override
  ConsumerState<_SubmitFieldWidget> createState() => _SubmitFieldWidgetState();
}

class _SubmitFieldWidgetState extends ConsumerState<_SubmitFieldWidget> {
  late TextEditingController _controller;
  bool _isActionRunning = false;

  String get _fieldId {
    if (widget.instanceIndex != null && widget.sectionId != null) {
      if (widget.questionInstanceIndex != null) {
        return '${widget.sectionId}[${widget.instanceIndex}].${widget.question.id}[${widget.questionInstanceIndex}]';
      }
      return '${widget.sectionId}[${widget.instanceIndex}].${widget.question.id}';
    }
    if (widget.questionInstanceIndex != null) {
      return '${widget.question.id}[${widget.questionInstanceIndex}]';
    }
    return widget.question.id;
  }

  @override
  void initState() {
    super.initState();
    final initialValue = ref.read(submitFormDataProvider)[_fieldId];
    _controller = TextEditingController(text: initialValue?.toString() ?? '');
  }

  @override
  void didUpdateWidget(_SubmitFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final val = ref.read(submitFormDataProvider)[_fieldId];
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
        if (widget.isRequired)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text('*', style: TextStyle(color: Colors.red)),
          ),
      ],
    );

    final helperWidget = q.helperText.translate(locale).isNotEmpty
        ? Text(
            q.helperText.translate(locale),
            style: TextStyle(
              color: helperColor,
              fontSize: style.helperFontSize,
              fontWeight: PreviewUtils.parseFontWeight(style.helperFontWeight),
            ),
          )
        : null;

    final isActionField = q.actionConfig != null;

    final fillColor = PreviewUtils.parseColor(
      style.backgroundColor,
      isActionField ? const Color(0xFFF0F7FF) : const Color(0xFFF8FAFC),
    );

    final borderColor = PreviewUtils.parseColor(
      style.borderColor,
      isActionField
          ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
          : const Color(0xFFCBD5E1),
    );

    return Container(
      margin: EdgeInsets.only(bottom: style.verticalMargin),
      padding: EdgeInsets.all(style.containerPadding ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.labelPosition != 'hidden') ...[
            if (style.labelPosition == 'left')
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: style.labelColumnWidth ?? 120,
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
      errorText: widget.error,
      prefixIcon: (style.prefixIcon != null && style.prefixIcon!.isNotEmpty)
          ? Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(style.prefixIcon!, style: textStyle),
              ),
            )
          : null,
      suffixIcon: widget.isLoading
          ? Container(
              padding: const EdgeInsets.all(12),
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : _buildSuffix(context, q, textStyle),
    );

    String? validator(String? val) => PreviewUtils.validateField(
      val,
      isRequired: widget.isRequired,
      regex: q.validationRegex,
      minLength: q.minLength,
      maxLength: q.maxLength,
      minValue: q.minValue?.toDouble(),
      maxValue: q.maxValue?.toDouble(),
      customError: q.customErrorMessage,
    );

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
                .read(submitFormDataProvider.notifier)
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
                .read(submitFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: val});
            setState(() {});
          },
        );

      case QuestionType.dropdown:
        final options = widget.dynamicOptions ?? q.options ?? [];
        final formData = ref.watch(submitFormDataProvider);
        return DropdownButtonFormField<String>(
          initialValue: formData[_fieldId]?.toString(),
          style: textStyle,
          decoration: inputDecoration,
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt.value,
              child: Text(opt.label, style: textStyle),
            );
          }).toList(),
          validator: (val) =>
              widget.isRequired && val == null ? 'Required' : null,
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(submitFormDataProvider.notifier)
                  .update((state) => {...state, _fieldId: val});
            }
          },
        );

      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        final options = q.options ?? [];
        final isRadio = q.type == QuestionType.multipleChoice;
        final formData = ref.watch(submitFormDataProvider);
        final currentValue = formData[_fieldId];

        // Check if these are image choices (enhanced UI)
        final isImageChoice = options.any(
          (opt) =>
              opt.description != null && opt.description!.startsWith('http'),
        );

        return FormField<dynamic>(
          initialValue: currentValue,
          validator: (val) =>
              widget.isRequired && (val == null || (val is List && val.isEmpty))
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
                      final imageUrl = opt.description ?? '';
                      if (!imageUrl.startsWith('http')) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          if (isRadio) {
                            ref
                                .read(submitFormDataProvider.notifier)
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
                                .read(submitFormDataProvider.notifier)
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
                              .read(submitFormDataProvider.notifier)
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
        final formData = ref.watch(submitFormDataProvider);
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
                  .read(submitFormDataProvider.notifier)
                  .update((s) => {...s, _fieldId: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.time:
        final formData = ref.watch(submitFormDataProvider);
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
                  .read(submitFormDataProvider.notifier)
                  .update((s) => {...s, _fieldId: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.rating:
        final formData = ref.watch(submitFormDataProvider);
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
                    .read(submitFormDataProvider.notifier)
                    .update((s) => {...s, _fieldId: index + 1});
              },
            );
          }),
        );

      case QuestionType.slider:
        final formData = ref.watch(submitFormDataProvider);
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
                    .read(submitFormDataProvider.notifier)
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
          height: (q.metadata?['spacerHeight'] as num?)?.toDouble() ?? 24,
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
          hint: 'Enter address',
        );
      case QuestionType.mapLocation:
        return _buildMultiLineSpecialField(
          q,
          inputDecoration,
          textStyle,
          ref,
          hint: 'Enter location coordinates or address',
        );
      case QuestionType.booleanValue:
      case QuestionType.toggle:
        return _buildToggleField(q, ref, textStyle);
      case QuestionType.multiSelect:
      case QuestionType.multiCheckbox:
        return _buildMultiSelectField(q, ref, textStyle);
      case QuestionType.multiFileUpload:
      case QuestionType.filePicker:
      case QuestionType.fileList:
      case QuestionType.file:
        return _buildFileFamilyField(q, ref, textStyle);
      case QuestionType.imageGallery:
        return _buildImageGalleryField(q, ref, textStyle);
      case QuestionType.signaturePad:
        return _buildSignaturePadField(q, ref, fillColor, borderColor);
      case QuestionType.calculate:
      case QuestionType.calculated:
        return _buildCalculatedField(q, ref, textStyle);
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
        return _buildReadableSpecialField(
          q,
          textStyle,
          fillColor,
          borderColor,
          ref,
        );
      case QuestionType.range:
        return _buildRangeField(q, ref, textStyle);
      case QuestionType.dateRange:
        return _buildDateRangeField(q, ref, textStyle);
      case QuestionType.timeRange:
        return _buildTimeRangeField(q, ref, textStyle);
      case QuestionType.stepper:
        return _buildStepperField(q, ref, textStyle);
    }
  }

  Widget _buildReadableSpecialField(
    FormQuestion q,
    TextStyle textStyle,
    Color fillColor,
    Color borderColor,
    WidgetRef ref,
  ) {
    final locale = ref.read(localeControllerProvider).languageCode;
    if (q.type == QuestionType.captcha) {
      final checked = ref.watch(submitFormDataProvider)[_fieldId] == true;
      return CheckboxListTile(
        value: checked,
        onChanged: (val) {
          ref
              .read(submitFormDataProvider.notifier)
              .update((state) => {...state, _fieldId: val == true});
          setState(() {});
        },
        title: Text('I am not a robot', style: textStyle),
        contentPadding: EdgeInsets.zero,
      );
    }

    if (q.type == QuestionType.colorPicker) {
      final value =
          ref.watch(submitFormDataProvider)[_fieldId]?.toString() ?? '#000000';
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
        onChanged: (val) {
          ref
              .read(submitFormDataProvider.notifier)
              .update((state) => {...state, _fieldId: val});
          setState(() {});
        },
      );
    }

    if (q.type == QuestionType.countrySelect ||
        q.type == QuestionType.stateSelect ||
        q.type == QuestionType.citySelect) {
      final options = (q.options ?? [])
          .map(
            (o) => o.label.translate(locale).isNotEmpty
                ? o.label.translate(locale)
                : o.value,
          )
          .where((v) => v.isNotEmpty)
          .toList();
      final current = ref.watch(submitFormDataProvider)[_fieldId]?.toString();
      if (options.isNotEmpty) {
        return DropdownButtonFormField<String>(
          initialValue: options.contains(current) ? current : null,
          decoration: InputDecoration(
            labelText: q.label.translate(locale),
            border: const OutlineInputBorder(),
          ),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            ref
                .read(submitFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: val});
            setState(() {});
          },
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
    final codeLength = (q.metadata?['codeLength'] as num?)?.toInt() ?? 6;
    final currentValue =
        ref.watch(submitFormDataProvider)[_fieldId]?.toString() ?? '';
    final controllers = _submitOtpControllers.putIfAbsent(
      q.id,
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
      _submitOtpControllers[q.id] = List.generate(codeLength, (index) {
        final controller = TextEditingController();
        if (index < currentValue.length) {
          controller.text = currentValue[index];
        }
        return controller;
      });
    }
    final otpFields = _submitOtpControllers[q.id]!;

    void syncOtp() {
      final value = otpFields.map((c) => c.text).join();
      ref
          .read(submitFormDataProvider.notifier)
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
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                validator: (val) {
                  if (widget.isRequired && (val == null || val.isEmpty)) {
                    return 'Required';
                  }
                  return null;
                },
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
    final previewMode = _submitRichPreviewMode[q.id] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _editorChip('Bold', Icons.format_bold),
            _editorChip('Italic', Icons.format_italic),
            if (isMarkdown) _editorChip('Heading', Icons.title),
            if (isMarkdown) _editorChip('List', Icons.format_list_bulleted),
            if (isMarkdown) _editorChip('Link', Icons.link),
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
                    _submitRichPreviewMode[q.id] = !previewMode;
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
                          .watch(submitFormDataProvider)[_fieldId]
                          ?.toString()
                          .isNotEmpty ==
                      true
                  ? ref.watch(submitFormDataProvider)[_fieldId].toString()
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
            validator: (val) => PreviewUtils.validateField(
              val,
              isRequired: widget.isRequired,
              regex: q.validationRegex,
              minLength: q.minLength,
              maxLength: q.maxLength,
              minValue: q.minValue?.toDouble(),
              maxValue: q.maxValue?.toDouble(),
              customError: q.customErrorMessage,
            ),
            onChanged: (val) {
              ref
                  .read(submitFormDataProvider.notifier)
                  .update((state) => {...state, _fieldId: val});
              setState(() {});
            },
          ),
      ],
    );
  }

  Widget _editorChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
      backgroundColor: AppColors.builderElement.withValues(alpha: 0.35),
      side: BorderSide(color: AppColors.borderLight),
    );
  }

  Widget _buildSingleLineSpecialField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref, {
    required String hint,
  }) {
    final locale = ref.read(localeControllerProvider).languageCode;
    return TextFormField(
      controller: _controller,
      style: textStyle,
      decoration: inputDecoration.copyWith(
        hintText: q.placeholder.translate(locale).isEmpty
            ? hint
            : q.placeholder.translate(locale),
      ),
      onChanged: (val) {
        ref
            .read(submitFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val});
        setState(() {});
      },
    );
  }

  Widget _buildMultiLineSpecialField(
    FormQuestion q,
    InputDecoration inputDecoration,
    TextStyle textStyle,
    WidgetRef ref, {
    required String hint,
  }) {
    final locale = ref.read(localeControllerProvider).languageCode;
    return TextFormField(
      controller: _controller,
      style: textStyle,
      decoration: inputDecoration.copyWith(
        hintText: q.placeholder.translate(locale).isEmpty
            ? hint
            : q.placeholder.translate(locale),
      ),
      maxLines: 3,
      minLines: 2,
      onChanged: (val) {
        ref
            .read(submitFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val});
        setState(() {});
      },
    );
  }

  Widget _buildToggleField(FormQuestion q, WidgetRef ref, TextStyle textStyle) {
    final current = ref.read(submitFormDataProvider)[_fieldId] == true;
    return SwitchListTile(
      value: current,
      onChanged: (val) {
        ref
            .read(submitFormDataProvider.notifier)
            .update((state) => {...state, _fieldId: val});
        setState(() {});
      },
      title: Text(
        q.label.translate(ref.read(localeControllerProvider).languageCode),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildMultiSelectField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    final options = q.options ?? [];
    final currentValue = ref.read(submitFormDataProvider)[_fieldId];
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
                .read(submitFormDataProvider.notifier)
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
      widget.question.actionConfig?['hasButton'] ?? false;

  Widget? _buildSuffix(BuildContext context, FormQuestion q, TextStyle style) {
    final actionConfig = q.actionConfig;
    if (actionConfig != null && (actionConfig['hasButton'] ?? false)) {
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

    if (q.style.suffixIcon != null && q.style.suffixIcon!.isNotEmpty) {
      return Center(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 8),
          child: Text(q.style.suffixIcon!, style: style),
        ),
      );
    }
    return null;
  }

  Widget _buildImageUploadField(FormQuestion q, WidgetRef ref) {
    final formData = ref.watch(submitFormDataProvider);
    // Store image bytes as Uint8List in form data
    final imageBytes = formData[_fieldId];
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
              .read(submitFormDataProvider.notifier)
              .update((s) => {...s, _fieldId: bytes});
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    // ── Camera picker (browser getUserMedia) ──────────────────────
    Future<void> pickFromCamera() async {
      final bytes = await CameraCaptureDialog.show(context);
      if (bytes != null) {
        ref
            .read(submitFormDataProvider.notifier)
            .update((s) => {...s, _fieldId: bytes});
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
                              .read(submitFormDataProvider.notifier)
                              .update((s) => {...s, _fieldId: null}),
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
    final formData = ref.watch(submitFormDataProvider);
    final fileEntry = formData[_fieldId];
    final fileName = fileEntry is Map
        ? fileEntry['name']?.toString() ?? ''
        : '';
    final fileSize = fileEntry is Map ? fileEntry['size'] as int? : null;

    // Determine allowed extensions from field validation config
    final allowedTypes = q.allowedFileTypes ?? [];
    final List<String>? extensions = allowedTypes.isNotEmpty
        ? _extensionsForTypes(allowedTypes)
        : null;

    void pickFile() {
      // Build the MIME/extension accept string, e.g. '.pdf,.jpg'
      final accept = extensions != null
          ? extensions.map((e) => '.$e').join(',')
          : '';

      // Create a hidden <input type="file"> using package:web
      final input = web.HTMLInputElement()
        ..type = 'file'
        ..accept = accept;

      // Listen for the change event, then read the file bytes
      input.addEventListener(
        'change',
        (web.Event _) {
          final files = input.files;
          if (files == null || files.length == 0) return;
          final file = files.item(0)!;

          final reader = web.FileReader();
          reader.addEventListener(
            'load',
            (web.Event _) {
              // result is a JS ArrayBuffer; convert to Uint8List
              final jsBuffer = reader.result;
              Uint8List? bytes;
              try {
                bytes = (jsBuffer as JSArrayBuffer).toDart.asUint8List();
              } catch (_) {
                bytes = null;
              }
              if (mounted) {
                ref
                    .read(submitFormDataProvider.notifier)
                    .update(
                      (s) => {
                        ...s,
                        q.id: {
                          'name': file.name,
                          'size': file.size,
                          'bytes': bytes,
                        },
                      },
                    );
              }
            }.toJS,
          );
          reader.readAsArrayBuffer(file);
        }.toJS,
      );

      input.click();
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (fileSize != null)
                          Text(
                            formatBytes(fileSize),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    tooltip: 'Remove file',
                    onPressed: () {
                      ref
                          .read(submitFormDataProvider.notifier)
                          .update((s) => {...s, _fieldId: null});
                    },
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
  ) {
    final formData = ref.watch(submitFormDataProvider);
    final value = formData[_fieldId];
    final isMulti =
        q.type == QuestionType.multiFileUpload ||
        q.type == QuestionType.fileList;
    final isGallery = q.type == QuestionType.imageGallery;
    final allowedTypes = q.allowedFileTypes ?? [];
    final List<String>? extensions = allowedTypes.isNotEmpty
        ? _extensionsForTypes(allowedTypes)
        : null;

    Future<void> pickFiles() async {
      final accept = isGallery
          ? 'image/*'
          : (extensions != null ? extensions.map((e) => '.$e').join(',') : '');
      final input = web.HTMLInputElement()
        ..type = 'file'
        ..multiple = isMulti
        ..accept = accept;

      input.addEventListener(
        'change',
        (web.Event _) {
          final files = input.files;
          if (files == null || files.length == 0) return;
          final picked = <Map<String, dynamic>>[];
          int remaining = files.length;

          void commit() {
            if (!mounted) return;
            ref.read(submitFormDataProvider.notifier).update((state) {
              final next = Map<String, dynamic>.from(state);
              next[_fieldId] = isMulti
                  ? picked
                  : (picked.isNotEmpty ? picked.first : null);
              return next;
            });
          }

          for (var i = 0; i < files.length; i++) {
            final file = files.item(i);
            if (file == null) continue;
            final reader = web.FileReader();
            reader.addEventListener(
              'load',
              (web.Event _) {
                Uint8List? bytes;
                try {
                  bytes = (reader.result as JSArrayBuffer).toDart.asUint8List();
                } catch (_) {
                  bytes = null;
                }
                picked.add({
                  'name': file.name,
                  'size': file.size,
                  'bytes': bytes,
                });
                remaining -= 1;
                if (remaining == 0) commit();
              }.toJS,
            );
            reader.readAsArrayBuffer(file);
          }
        }.toJS,
      );
      input.click();
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
                    isMulti ? 'Tap to upload files' : 'Tap to upload file',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isGallery
                        ? 'Image gallery upload'
                        : 'Allowed file types will be enforced by the browser',
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
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              ref.read(submitFormDataProvider.notifier).update((
                                state,
                              ) {
                                final next = Map<String, dynamic>.from(state);
                                if (isMulti && value is List) {
                                  final updated = List<Map>.from(value);
                                  updated.removeWhere(
                                    (e) => e['name'] == f['name'],
                                  );
                                  next[_fieldId] = updated;
                                } else {
                                  next[_fieldId] = null;
                                }
                                return next;
                              });
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

  Widget _buildImageGalleryField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    return _buildFileFamilyField(q, ref, textStyle);
  }

  Widget _buildSignaturePadField(
    FormQuestion q,
    WidgetRef ref,
    Color fillColor,
    Color borderColor,
  ) {
    return _buildSignatureField(q, ref, fillColor, borderColor);
  }

  Widget _buildRangeField(FormQuestion q, WidgetRef ref, TextStyle textStyle) {
    final formData = ref.watch(submitFormDataProvider);
    final current =
        (formData[_fieldId] as num?)?.toDouble() ??
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
          onChanged: (v) {
            ref
                .read(submitFormDataProvider.notifier)
                .update((state) => {...state, _fieldId: v});
            setState(() {});
          },
        ),
        Text(
          '${current.toStringAsFixed(0)} / ${max.toStringAsFixed(0)}',
          style: textStyle,
        ),
      ],
    );
  }

  Widget _buildDateRangeField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    final current =
        ref.watch(submitFormDataProvider)[_fieldId] as Map<String, dynamic>?;
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
          ref
              .read(submitFormDataProvider.notifier)
              .update(
                (state) => {
                  ...state,
                  _fieldId: {
                    'start': DateFormat('yyyy-MM-dd').format(picked.start),
                    'end': DateFormat('yyyy-MM-dd').format(picked.end),
                  },
                },
              );
          setState(() {});
        }
      },
    );
  }

  Widget _buildTimeRangeField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    final current =
        ref.watch(submitFormDataProvider)[_fieldId] as Map<String, dynamic>?;
    final startText = current?['start']?.toString() ?? 'Start time';
    final endText = current?['end']?.toString() ?? 'End time';
    Future<void> pick(bool isStart) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        ref
            .read(submitFormDataProvider.notifier)
            .update(
              (state) => {
                ...state,
                _fieldId: {
                  ...?current,
                  if (isStart)
                    'start':
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}'
                  else
                    'end':
                        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                },
              },
            );
        setState(() {});
      }
    }

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
            onTap: () => pick(true),
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
            onTap: () => pick(false),
          ),
        ),
      ],
    );
  }

  Widget _buildStepperField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    final current =
        (ref.watch(submitFormDataProvider)[_fieldId] as int?) ??
        (q.minValue?.toInt() ?? 0);
    final min = q.minValue?.toInt() ?? 0;
    final max = q.maxValue?.toInt() ?? 10;
    return Row(
      children: [
        IconButton(
          onPressed: current > min
              ? () {
                  ref
                      .read(submitFormDataProvider.notifier)
                      .update((state) => {...state, _fieldId: current - 1});
                  setState(() {});
                }
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(
          '$current',
          style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          onPressed: current < max
              ? () {
                  ref
                      .read(submitFormDataProvider.notifier)
                      .update((state) => {...state, _fieldId: current + 1});
                  setState(() {});
                }
              : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _buildCalculatedField(
    FormQuestion q,
    WidgetRef ref,
    TextStyle textStyle,
  ) {
    final formula = q.metadata?['formula']?.toString();
    final current = ref.watch(submitFormDataProvider)[_fieldId]?.toString();
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
                  style: textStyle.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            current?.isNotEmpty == true ? current! : 'Result will appear here',
            style: textStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Read-only derived value',
            style: textStyle.copyWith(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  List<String> _extensionsForTypes(List<String> types) {
    final map = <String, List<String>>{
      'image': ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'],
      'document': ['doc', 'docx', 'odt', 'txt', 'rtf'],
      'pdf': ['pdf'],
      'spreadsheet': ['xls', 'xlsx', 'ods', 'csv'],
      'video': ['mp4', 'mov', 'avi', 'mkv'],
      'audio': ['mp3', 'wav', 'aac', 'm4a'],
    };
    final result = <String>{};
    for (final t in types) {
      result.addAll(map[t.toLowerCase()] ?? [t.toLowerCase()]);
    }
    return result.toList();
  }

  Widget _buildSignatureField(
    FormQuestion q,
    WidgetRef ref,
    Color fillColor,
    Color borderColor,
  ) {
    final formData = ref.watch(submitFormDataProvider);
    final signatureData = formData[_fieldId]?.toString();
    final isSigned = signatureData != null && signatureData.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isSigned)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.memory(
                    base64Decode(signatureData),
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.brandBlue),
                    onPressed: () {
                      ref
                          .read(submitFormDataProvider.notifier)
                          .update((s) => {...s, _fieldId: ''});
                    },
                  ),
                ),
              ],
            ),
          )
        else
          SignaturePadWidget(
            backgroundColor: Colors.grey.shade50,
            onSigned: (data) {
              if (data.isNotEmpty) {
                ref
                    .read(submitFormDataProvider.notifier)
                    .update((s) => {...s, _fieldId: data});
              }
            },
          ),
      ],
    );
  }

  Widget _buildMatrixField(
    FormQuestion q,
    TextStyle textStyle,
    WidgetRef ref,
    Color fillColor,
    Color borderColor,
    bool isActionField,
  ) {
    final formData = ref.watch(submitFormDataProvider);
    final matrixData = (formData[_fieldId] as Map<String, dynamic>?) ?? {};

    final rows =
        (q.metadata?['rows'] as List?)?.map((e) => e.toString()).toList() ??
        ['Row 1', 'Row 2', 'Row 3'];
    final columns =
        (q.metadata?['columns'] as List?)?.map((e) => e.toString()).toList() ??
        ['Poor', 'Average', 'Good', 'Excellent'];

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            isActionField
                ? const Color(0xFFDBEAFE) // Light blue header for action fields
                : Colors.grey.shade100,
          ),
          columnSpacing: 24,
          horizontalMargin: 16,
          columns: [
            const DataColumn(
              label: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...columns.map(
              (col) => DataColumn(
                label: Text(
                  col,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
          rows: rows.map((row) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    row,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ...columns.map((col) {
                  return DataCell(
                    Center(
                      child: RadioGroup<String>(
                        groupValue: matrixData[row]?.toString(),
                        onChanged: (val) {
                          if (val != null) {
                            final newData = Map<String, dynamic>.from(
                              matrixData,
                            );
                            newData[row] = val;
                            ref
                                .read(submitFormDataProvider.notifier)
                                .update((s) => {...s, _fieldId: newData});
                          }
                        },
                        child: Radio<String>(
                          value: col,
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
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

  Widget _buildPicker({
    required String text,
    required IconData icon,
    required InputDecoration decoration,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: decoration.copyWith(
          suffixIcon: Icon(icon, color: AppColors.textGrey),
        ),
        child: Text(text),
      ),
    );
  }
}
