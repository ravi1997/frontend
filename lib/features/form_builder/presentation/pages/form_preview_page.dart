import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/entities/form_layout_type.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../domain/services/workflow_executor_provider.dart';
import '../../../responses/presentation/controllers/form_submission_controller.dart';

class FormPreviewPage extends ConsumerStatefulWidget {
  final BuilderForm form;

  const FormPreviewPage({super.key, required this.form});

  @override
  ConsumerState<FormPreviewPage> createState() => _FormPreviewPageState();
}

class _FormPreviewPageState extends ConsumerState<FormPreviewPage> {
  int _currentStep = 0;

  Color _parseColor(String hex, Color fallback) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formStyle = widget.form.style;
    final canvasColor = _parseColor(
      formStyle.backgroundColor,
      AppColors.builderBackground,
    );
    final primaryColor = _parseColor(formStyle.primaryColor, AppColors.primary);

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
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final formStyle = widget.form.style;

    if (widget.form.sections.isEmpty) {
      return _buildEmptyState();
    }

    if (formStyle.layoutType == 'step') {
      return _buildStepLayout();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormHeader(),
              SizedBox(height: formStyle.sectionSpacing),
              _buildSectionsList(),
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
            "This form is empty.",
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
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
        widget.form.title,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionsList() {
    final spacing = widget.form.style.sectionSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (widget.form.layout == FormLayoutType.twoColumns) crossAxisCount = 2;
        if (widget.form.layout == FormLayoutType.threeColumns)
          crossAxisCount = 3;

        if (availableWidth < 600)
          crossAxisCount = 1;
        else if (availableWidth < 900 && crossAxisCount > 2)
          crossAxisCount = 2;

        final itemWidth =
            (availableWidth - (24 * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: 24,
          runSpacing: spacing,
          children: widget.form.sections.map((section) {
            return SizedBox(
              width: itemWidth,
              child: _PreviewSectionWidget(
                section: section,
                questionSpacing: widget.form.style.questionSpacing,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStepLayout() {
    final sections = widget.form.sections;
    final currentSection = sections[_currentStep];
    final primaryColor = _parseColor(
      widget.form.style.primaryColor,
      AppColors.primary,
    );

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / sections.length,
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
                      "Step ${_currentStep + 1} of ${sections.length}",
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
                            child: const Text("Previous"),
                          )
                        else
                          const SizedBox(),
                        if (_currentStep < sections.length - 1)
                          ElevatedButton(
                            onPressed: () => setState(() => _currentStep++),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text("Next"),
                          )
                        else
                          _buildSubmitButton(small: true),
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
    final primaryColor = _parseColor(
      widget.form.style.primaryColor,
      AppColors.primary,
    );
    final submissionState = ref.watch(formSubmissionControllerProvider);

    return Center(
      child: ElevatedButton(
        onPressed: submissionState.isLoading
            ? null
            : () async {
                final dummyData = {
                  'preview': 'true',
                  'timestamp': DateTime.now().toIso8601String(),
                };
                final success = await ref
                    .read(formSubmissionControllerProvider.notifier)
                    .submit(widget.form.id, dummyData);

                if (success && context.mounted) {
                  await ref
                      .read(workflowExecutorProvider)
                      .execute(widget.form, dummyData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Submission Recorded (Offline Sync Enabled)',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
}

class _PreviewSectionWidget extends StatelessWidget {
  final FormSection section;
  final double questionSpacing;

  const _PreviewSectionWidget({
    required this.section,
    required this.questionSpacing,
  });

  Color _parseColor(String hex, Color fallback) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = section.style;
    final sectionBg = _parseColor(style.backgroundColor, Colors.white);
    final headerBg = _parseColor(
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
                      section.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (section.description != null &&
                        section.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          section.description!,
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
              child: _buildQuestionsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 1;
        if (section.layout == SectionLayoutType.grid) {
          crossAxisCount = section.gridColumns;
        }

        if (availableWidth < 400)
          crossAxisCount = 1;
        else if (availableWidth < 700 && crossAxisCount > 2)
          crossAxisCount = 2;

        final itemWidth =
            (availableWidth - (questionSpacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: questionSpacing,
          runSpacing: questionSpacing,
          children: section.questions.map((q) {
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

            return SizedBox(
              width: width,
              child: _PreviewFieldWidget(question: q),
            );
          }).toList(),
        );
      },
    );
  }
}

class _PreviewFieldWidget extends StatelessWidget {
  final FormQuestion question;

  const _PreviewFieldWidget({required this.question});

  Color _parseColor(String hex, Color fallback) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  FontWeight _parseFontWeight(String weight) {
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'medium':
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = question.style;
    final labelColor = _parseColor(style.labelColor, AppColors.textDark);
    final helperColor = _parseColor(style.helperColor, AppColors.textGrey);

    if (style.labelPosition == 'hidden') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInput(question),
          if (question.helperText?.isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Text(
              question.helperText!,
              style: TextStyle(
                color: helperColor,
                fontSize: style.helperFontSize,
                fontWeight: _parseFontWeight(style.helperFontWeight),
              ),
            ),
          ],
        ],
      );
    }

    if (style.labelPosition == 'left') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                question.label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: style.labelFontSize,
                  fontWeight: _parseFontWeight(style.labelFontWeight),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInput(question),
                if (question.helperText?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    question.helperText!,
                    style: TextStyle(
                      color: helperColor,
                      fontSize: style.helperFontSize,
                      fontWeight: _parseFontWeight(style.helperFontWeight),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    // Default: top aligned
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                question.label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: style.labelFontSize,
                  fontWeight: _parseFontWeight(style.labelFontWeight),
                ),
              ),
            ),
            if (question.isRequired)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
        if (question.helperText?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          Text(
            question.helperText!,
            style: TextStyle(
              color: helperColor,
              fontSize: style.helperFontSize,
              fontWeight: _parseFontWeight(style.helperFontWeight),
            ),
          ),
        ],
        const SizedBox(height: 8),
        _buildInput(question),
      ],
    );
  }

  Widget _buildInput(FormQuestion q) {
    final style = q.style;
    final inputStyle = style.inputStyle;
    Color fillColor = _parseColor(
      style.backgroundColor,
      AppColors.fieldBackground,
    );
    BoxBorder border = Border.all(
      color: _parseColor(style.borderColor, AppColors.borderLight),
      width: style.borderWidth,
    );
    double radius = style.borderRadius;

    switch (inputStyle) {
      case 'filled':
        fillColor = Colors.grey.shade100;
        border = Border(
          bottom: BorderSide(color: AppColors.textGrey, width: 2),
        );
        break;
      case 'glass':
        fillColor = Colors.white.withValues(alpha: 0.3);
        border = Border.all(color: Colors.white.withValues(alpha: 0.5));
        break;
      case 'minimalist':
        fillColor = Colors.transparent;
        border = const Border(bottom: BorderSide(color: AppColors.borderLight));
        break;
      case 'underlined':
        fillColor = Colors.transparent;
        border = const Border(bottom: BorderSide(color: AppColors.borderLight));
        radius = 0;
        break;
    }

    final decoration = BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(radius),
      border: border,
    );

    final inputColor = _parseColor(style.inputFontColor, AppColors.textDark);
    final textStyle = TextStyle(
      color: inputColor,
      fontSize: style.inputFontSize,
      fontWeight: _parseFontWeight(style.inputFontWeight),
    );

    switch (q.type) {
      case QuestionType.shortText:
      case QuestionType.number:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: decoration,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (style.prefixIcon != null && style.prefixIcon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(style.prefixIcon!, style: textStyle),
                ),
              Expanded(
                child: Text(
                  q.placeholder ?? '',
                  style: textStyle.copyWith(
                    color: inputColor.withValues(alpha: 0.4),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (style.suffixIcon != null && style.suffixIcon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(style.suffixIcon!, style: textStyle),
                ),
            ],
          ),
        );
      case QuestionType.paragraph:
        return Container(
          height: 120,
          padding: const EdgeInsets.all(14),
          decoration: decoration,
          alignment: Alignment.topLeft,
          child: Text(
            q.placeholder ?? 'Your answer...',
            style: textStyle.copyWith(color: inputColor.withValues(alpha: 0.4)),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: decoration,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  q.placeholder ?? 'Select...',
                  style: textStyle.copyWith(
                    color: inputColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
            ],
          ),
        );
      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        final isRadio = q.type == QuestionType.multipleChoice;
        return Column(
          children: (q.options ?? ['Option 1', 'Option 2']).map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    isRadio
                        ? Icons.radio_button_unchecked
                        : Icons.check_box_outline_blank,
                    size: 20,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(opt, style: textStyle),
                ],
              ),
            );
          }).toList(),
        );
      default:
        return Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: decoration,
          child: Center(
            child: Text(
              "Preview of ${q.type.label}",
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
          ),
        );
    }
  }
}
