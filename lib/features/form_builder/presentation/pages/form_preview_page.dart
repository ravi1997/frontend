import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/signature_pad_widget.dart';
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

final previewFormDataProvider = StateProvider.autoDispose<Map<String, dynamic>>(
  (ref) => {},
);

class FormPreviewPage extends ConsumerStatefulWidget {
  final BuilderForm form;

  const FormPreviewPage({super.key, required this.form});

  @override
  ConsumerState<FormPreviewPage> createState() => _FormPreviewPageState();
}

class _FormPreviewPageState extends ConsumerState<FormPreviewPage> {
  int _currentStep = 0;
  bool _showSubmitted = false;
  bool _isReviewing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final formData = ref.watch(previewFormDataProvider);
    final visibilityMap = FormLogicEngine.evaluateVisibility(
      widget.form,
      formData,
    );

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
            _buildLanguageSwitcher(),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(previewFormDataProvider);
                setState(() {
                  _currentStep = 0;
                  _showSubmitted = false;
                  _isReviewing = false;
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

  Widget _buildBody(String locale, Map<String, bool> visibilityMap) {
    if (_showSubmitted) {
      return _buildSuccessScreen(locale);
    }

    if (_isReviewing) {
      return _buildReviewScreen(locale, visibilityMap);
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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormHeader(locale),
                SizedBox(height: formStyle.sectionSpacing),
                _buildSectionsList(locale, visibilityMap),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 16),
                _buildPreviewFooter(),
                const SizedBox(height: 60),
              ],
            ),
          ),
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

  Widget _buildReviewScreen(String locale, Map<String, bool> visibilityMap) {
    final formData = ref.watch(previewFormDataProvider);
    final visibleSections = widget.form.sections
        .where((s) => visibilityMap[s.id] ?? true)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.form.style.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 32),
              ...visibleSections.map((section) {
                final visibleQuestions = section.questions
                    .where((q) => visibilityMap[q.id] ?? true)
                    .toList();
                if (visibleQuestions.isEmpty) return const SizedBox.shrink();

                return Column(
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
                      if (val is List) displayVal = val.join(', ');

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
                              style: const TextStyle(color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                );
              }),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => setState(() => _isReviewing = false),
                    child: const Text('Back to Edit'),
                  ),
                  _buildSubmitButton(small: true),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildFormHeader(String locale) {
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
        widget.form.title.translate(locale),
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
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
        if (widget.form.layout == FormLayoutType.twoColumns) crossAxisCount = 2;
        if (widget.form.layout == FormLayoutType.threeColumns) {
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
            return SizedBox(
              width: itemWidth,
              child: _PreviewSectionWidget(
                section: section,
                questionSpacing: widget.form.style.questionSpacing,
                visibilityMap: visibilityMap,
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
    if (_currentStep < 0) _currentStep = 0;

    final currentSection = visibleSections.isEmpty
        ? null
        : visibleSections[_currentStep];
    final primaryColor = PreviewUtils.parseColor(
      widget.form.style.primaryColor,
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

                final formData = ref.read(previewFormDataProvider);
                final submissionData = {
                  ...formData,
                  'preview': 'true',
                  'timestamp': DateFormat(
                    "E, d MMM y HH:mm:ss 'GMT'",
                  ).format(DateTime.now().toUtc()),
                };
                final success = await ref
                    .read(formSubmissionControllerProvider.notifier)
                    .submit(
                      widget.form.id,
                      Map<String, dynamic>.from(submissionData),
                    );

                if (success) {
                  setState(() {
                    _showSubmitted = true;
                    _isReviewing = false;
                  });
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
            borderRadius: BorderRadius.circular(
              widget.form.style.globalBorderRadius,
            ),
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
        'Preview Mode: Workflows (Email/Slack) will be simulated in logs.',
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

class _PreviewSectionWidget extends ConsumerWidget {
  final FormSection section;
  final double questionSpacing;
  final Map<String, bool> visibilityMap;

  const _PreviewSectionWidget({
    required this.section,
    required this.questionSpacing,
    required this.visibilityMap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final style = section.style;
    final sectionBg = PreviewUtils.parseColor(
      style.backgroundColor,
      Colors.white,
    );
    final headerBg = PreviewUtils.parseColor(
      style.headerBackgroundColor,
      AppColors.builderElement.withValues(alpha: 0.5),
    );

    return Material(
      elevation: style.elevation,
      borderRadius: BorderRadius.circular(style.borderRadius),
      color: sectionBg,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.borderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (style.showHeader)
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: const Border(
                    bottom: BorderSide(color: AppColors.borderLight),
                  ),
                  color: headerBg,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(style.borderRadius),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title.translate(locale),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (section.description.translate(locale).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          section.description.translate(locale),
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.all(style.padding),
              child: _buildQuestionsGrid(visibilityMap),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsGrid(Map<String, bool> visibilityMap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (section.layout == SectionLayoutType.grid) {
          crossAxisCount = section.gridColumns;
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
                  width = 400.0;
              }
            } else {
              int span = q.style.columnSpan;
              if (span > crossAxisCount) span = crossAxisCount;
              if (span < 1) span = 1;
              width = (itemWidth * span) + (questionSpacing * (span - 1));
            }
            if (width > availableWidth) width = availableWidth;

            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: width,
                child: _PreviewFieldWidget(question: q),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _PreviewFieldWidget extends ConsumerStatefulWidget {
  final FormQuestion question;
  const _PreviewFieldWidget({required this.question});

  @override
  ConsumerState<_PreviewFieldWidget> createState() =>
      _PreviewFieldWidgetState();
}

class _PreviewFieldWidgetState extends ConsumerState<_PreviewFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialValue = ref.read(previewFormDataProvider)[widget.question.id];
    _controller = TextEditingController(text: initialValue?.toString() ?? '');
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
                : q.label.translate(locale),
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
                  Expanded(child: _buildInput(context, ref, locale)),
                ],
              )
            else ...[
              labelWidget,
              if (helperWidget != null) ...[
                const SizedBox(height: 4),
                helperWidget,
              ],
              const SizedBox(height: 8),
              _buildInput(context, ref, locale),
            ],
          ] else ...[
            _buildInput(context, ref, locale),
            if (helperWidget != null) ...[
              const SizedBox(height: 4),
              helperWidget,
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, WidgetRef ref, String locale) {
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

    final fillColor = PreviewUtils.parseColor(
      style.backgroundColor,
      AppColors.fieldBackground,
    );
    final borderColor = PreviewUtils.parseColor(
      style.borderColor,
      AppColors.borderLight,
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
      prefixIcon: (style.prefixIcon != null && style.prefixIcon!.isNotEmpty)
          ? Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(style.prefixIcon!, style: textStyle),
              ),
            )
          : null,
      suffixIcon: (style.suffixIcon != null && style.suffixIcon!.isNotEmpty)
          ? Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 8),
                child: Text(style.suffixIcon!, style: textStyle),
              ),
            )
          : null,
    );

    final validator = (String? val) => PreviewUtils.validateField(
      val,
      isRequired: q.isRequired,
      regex: q.validationRegex,
      minLength: q.minLength,
      maxLength: q.maxLength,
      minValue: q.minValue?.toDouble(),
      maxValue: q.maxValue?.toDouble(),
      customError: q.customErrorMessage,
    );

    switch (q.type) {
      case QuestionType.shortText:
      case QuestionType.number:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return TextFormField(
          controller: _controller,
          style: textStyle,
          decoration: inputDecoration.copyWith(
            suffixText: q.maxLength != null
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
                .update((state) => {...state, q.id: val});
            setState(() {});
          },
        );

      case QuestionType.paragraph:
        return TextFormField(
          controller: _controller,
          style: textStyle,
          decoration: inputDecoration.copyWith(
            suffixText: q.maxLength != null
                ? '${_controller.text.length}/${q.maxLength}'
                : null,
          ),
          maxLines: 5,
          minLines: 3,
          validator: validator,
          textInputAction: TextInputAction.newline,
          onChanged: (val) {
            ref
                .read(previewFormDataProvider.notifier)
                .update((state) => {...state, q.id: val});
            setState(() {});
          },
        );

      case QuestionType.dropdown:
        final options = q.options ?? [];
        final formData = ref.watch(previewFormDataProvider);
        return DropdownButtonFormField<String>(
          value: formData[q.id]?.toString(),
          style: textStyle,
          decoration: inputDecoration,
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt.value,
              child: Text(opt.label, style: textStyle),
            );
          }).toList(),
          validator: (val) => q.isRequired && val == null ? 'Required' : null,
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(previewFormDataProvider.notifier)
                  .update((state) => {...state, q.id: val});
            }
          },
        );

      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        final options = q.options ?? [];
        final isRadio = q.type == QuestionType.multipleChoice;
        final formData = ref.watch(previewFormDataProvider);
        final currentValue = formData[q.id];

        // Check if these are image choices (enhanced UI)
        final isImageChoice = options.any(
          (opt) =>
              opt.description != null && opt.description!.startsWith('http'),
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
                      final imageUrl = opt.description ?? '';
                      if (!imageUrl.startsWith('http'))
                        return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () {
                          if (isRadio) {
                            ref
                                .read(previewFormDataProvider.notifier)
                                .update((s) => {...s, q.id: opt.value});
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
                                .update((s) => {...s, q.id: currentList});
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
                              .update((s) => {...s, q.id: newValue});
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
        final dateStr = formData[q.id]?.toString() ?? '';
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
                  .update((s) => {...s, q.id: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.time:
        final formData = ref.watch(previewFormDataProvider);
        final timeStr = formData[q.id]?.toString() ?? '';
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
                  .update((s) => {...s, q.id: val});
              _controller.text = val;
            }
          },
        );

      case QuestionType.rating:
        final formData = ref.watch(previewFormDataProvider);
        final rating = double.tryParse(formData[q.id]?.toString() ?? '0') ?? 0;
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
                    .update((s) => {...s, q.id: index + 1});
              },
            );
          }),
        );

      case QuestionType.slider:
        final formData = ref.watch(previewFormDataProvider);
        final val =
            double.tryParse(
              formData[q.id]?.toString() ?? (q.minValue?.toString() ?? '0'),
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
                    .update((s) => {...s, q.id: newVal});
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
        return _buildSignatureField(q, ref);

      case QuestionType.matrixChoice:
        return _buildMatrixField(q, textStyle, ref);

      case QuestionType.divider:
        return const Divider(height: 32, thickness: 1);

      case QuestionType.spacer:
        return SizedBox(
          height: (q.metadata?['spacerHeight'] as num?)?.toDouble() ?? 24,
        );

      case QuestionType.image:
        return _buildImageUploadField(q, ref);
    }
  }

  Widget _buildImageUploadField(FormQuestion q, WidgetRef ref) {
    final formData = ref.watch(previewFormDataProvider);
    final imageUrl = formData[q.id]?.toString() ?? '';

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageUrl.isEmpty
          ? InkWell(
              onTap: () {
                // High fidelity mock of image selection
                ref
                    .read(previewFormDataProvider.notifier)
                    .update(
                      (s) => {
                        ...s,
                        q.id:
                            'https://images.unsplash.com/photo-1481349518771-2005b9565124?q=80&w=2000&auto=format&fit=crop',
                      },
                    );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Click to Upload Image',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  Text(
                    '(Simulation)',
                    style: TextStyle(
                      color: AppColors.textGrey.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => ref
                          .read(previewFormDataProvider.notifier)
                          .update((s) => {...s, q.id: ''}),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFileUploadStub(
    FormQuestion q,
    InputDecoration decoration,
    WidgetRef ref,
  ) {
    final formData = ref.watch(previewFormDataProvider);
    final fileName = formData[q.id]?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            fileName.isEmpty
                ? Icons.cloud_upload_outlined
                : Icons.insert_drive_file,
            color: fileName.isEmpty
                ? AppColors.textGrey
                : Theme.of(context).primaryColor,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            fileName.isEmpty ? 'Simulate File Upload' : fileName,
            style: TextStyle(
              color: fileName.isEmpty ? AppColors.textGrey : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          if (fileName.isEmpty)
            TextButton(
              onPressed: () {
                ref
                    .read(previewFormDataProvider.notifier)
                    .update((s) => {...s, q.id: 'mock_document_v1.pdf'});
              },
              child: const Text('Simulate Selection'),
            )
          else
            TextButton(
              onPressed: () {
                ref
                    .read(previewFormDataProvider.notifier)
                    .update((s) => {...s, q.id: ''});
              },
              child: const Text(
                'Remove File',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSignatureField(FormQuestion q, WidgetRef ref) {
    final formData = ref.watch(previewFormDataProvider);
    final signatureData = formData[q.id]?.toString();
    final isSigned = signatureData != null && signatureData.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isSigned)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.borderLight),
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
                          .read(previewFormDataProvider.notifier)
                          .update((s) => {...s, q.id: ''});
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
                    .read(previewFormDataProvider.notifier)
                    .update((s) => {...s, q.id: data});
              }
            },
          ),
      ],
    );
  }

  Widget _buildMatrixField(FormQuestion q, TextStyle textStyle, WidgetRef ref) {
    final formData = ref.watch(previewFormDataProvider);
    final matrixData = (formData[q.id] as Map<String, dynamic>?) ?? {};

    final rows =
        (q.metadata?['rows'] as List?)?.map((e) => e.toString()).toList() ??
        ['Row 1', 'Row 2', 'Row 3'];
    final columns =
        (q.metadata?['columns'] as List?)?.map((e) => e.toString()).toList() ??
        ['Poor', 'Average', 'Good', 'Excellent'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
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
                      child: Radio<String>(
                        value: col,
                        groupValue: matrixData[row]?.toString(),
                        onChanged: (val) {
                          if (val != null) {
                            final newData = Map<String, dynamic>.from(
                              matrixData,
                            );
                            newData[row] = val;
                            ref
                                .read(previewFormDataProvider.notifier)
                                .update((s) => {...s, q.id: newData});
                          }
                        },
                        activeColor: Theme.of(context).primaryColor,
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
