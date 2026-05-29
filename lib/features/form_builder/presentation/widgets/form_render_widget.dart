import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import 'package:frontend/models/form_models.dart';
import '../../domain/entities/form_style.dart';
import '../../domain/entities/form_layout_type.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../domain/entities/question_type.dart';
import '../utils/layout_engine.dart';
import 'section_layout_widgets.dart';

TextStyle _sectionTypographyStyle({
  required String baseColor,
  required Color fallbackColor,
  required String sizeKey,
  required String weightKey,
  required double fallbackSize,
  required Map<String, dynamic> metadata,
}) {
  final color = _parseColor(baseColor, fallbackColor);
  final size = (metadata[sizeKey] as num?)?.toDouble() ?? fallbackSize;
  final weight = switch (metadata[weightKey]?.toString()) {
    'medium' => FontWeight.w500,
    'bold' => FontWeight.bold,
    _ => FontWeight.normal,
  };
  return TextStyle(color: color, fontSize: size, fontWeight: weight);
}

Color _parseColor(String value, Color fallback) {
  try {
    return Color(int.parse(value.replaceAll('#', '0xFF')));
  } catch (_) {
    return fallback;
  }
}

class FormRenderWidget extends ConsumerWidget {
  final BuilderForm form;

  const FormRenderWidget({super.key, required this.form});

  FormStyle _formStyle(BuilderForm form) {
    return FormStyle.fromJson(form.style);
  }

  QuestionStyle _questionStyle(FormQuestion question) {
    final raw = question.ui['style'];
    if (raw is Map) {
      return QuestionStyle.fromJson(Map<String, dynamic>.from(raw));
    }
    return const QuestionStyle();
  }

  dynamic _helperText(FormQuestion question) {
    return question.helpText ?? question.metadata['helper_text'] ?? '';
  }

  dynamic _placeholder(FormQuestion question) {
    return question.metadata['placeholder'] ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final formStyle = _formStyle(form);
    Color canvasColor;
    try {
      canvasColor = Color(
        int.parse(formStyle.backgroundColor.replaceAll('#', '0xFF')),
      );
    } catch (_) {
      canvasColor = AppColors.builderCanvas;
    }

    return Container(
      color: canvasColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: formStyle.maxWidth),
            child: Column(
              children: [
                // Form Header
                _buildFormHeader(form.title, locale),
                const SizedBox(height: 24),

                // Sections
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final spacing = 24.0;

                    int crossAxisCount = 1;
                    if (form.layout == FormLayoutType.twoColumns) {
                      crossAxisCount = 2;
                    } else if (form.layout == FormLayoutType.threeColumns) {
                      crossAxisCount = 3;
                    }

                    if (availableWidth < 600 && crossAxisCount > 1) {
                      crossAxisCount = 1;
                    } else if (availableWidth < 900 && crossAxisCount > 2) {
                      crossAxisCount = 2;
                    }

                    final itemWidth =
                        (availableWidth - (spacing * (crossAxisCount - 1))) /
                        crossAxisCount;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: form.sections.map((section) {
                        return SizedBox(
                          width: itemWidth,
                          child: _buildSection(context, section, locale),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Submit Button
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _sectionCrossAxisCount(SectionLayoutType layout, int gridColumns) {
    switch (layout) {
      case SectionLayoutType.grid:
        return gridColumns;
      case SectionLayoutType.threeColumns:
        return 3;
      case SectionLayoutType.fullWidth:
      case SectionLayoutType.list:
      case SectionLayoutType.sidebar:
      case SectionLayoutType.custom:
      case SectionLayoutType.overlay:
      case SectionLayoutType.dashboard:
      case SectionLayoutType.centered:
      case SectionLayoutType.wizard:
      case SectionLayoutType.masonry:
      case SectionLayoutType.fixed:
      case SectionLayoutType.standard:
      case SectionLayoutType.accordion:
      case SectionLayoutType.tabbed:
      case SectionLayoutType.card:
        return 1;
    }
  }

  Widget _buildFormHeader(Object? title, String locale) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.translate(locale),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Builds the question grid (shared by all layouts)
  // ---------------------------------------------------------------------------
  Widget _buildQuestionsGrid(
    BuildContext context,
    FormSection section,
    String locale,
    SectionStyle sectionStyle,
  ) {
    final metadata = section.metadata;
    final defaultPad = (sectionStyle.padding as num?)?.toDouble() ?? 16.0;
    final vPad =
        (metadata['verticalPadding'] as num?)?.toDouble() ?? defaultPad;
    final hPad =
        (metadata['horizontalPadding'] as num?)?.toDouble() ?? defaultPad;
    final questionSpacing = (metadata['fieldGap'] as num?)?.toDouble() ?? 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          final layout = SectionLayoutType.values.firstWhere(
            (e) => e.name == section.layout,
            orElse: () => SectionLayoutType.standard,
          );
          int crossAxisCount = _sectionCrossAxisCount(
            layout,
            section.gridColumns,
          );
          if (availableWidth < 400 && crossAxisCount > 1) crossAxisCount = 1;
          if (availableWidth < 700 && crossAxisCount > 2) crossAxisCount = 2;

          final itemWidth =
              (availableWidth - (questionSpacing * (crossAxisCount - 1))) /
              crossAxisCount;

          return Wrap(
            spacing: questionSpacing,
            runSpacing: questionSpacing,
            children: section.questions.map((q) {
              final qStyle = _questionStyle(q);
              double width = itemWidth;
              if (qStyle.widthMode == 'fixed') {
                switch (qStyle.fixedWidth) {
                  case 'small':
                    width = 200.0;
                  case 'medium':
                    width = 400.0;
                  case 'large':
                    width = 600.0;
                  default:
                    width = 400.0;
                }
              } else {
                int span = LayoutEngine.getFieldSpan(q, crossAxisCount);
                width = (itemWidth * span) + (questionSpacing * (span - 1));
              }
              if (width > availableWidth) width = availableWidth;
              return SizedBox(
                width: width,
                child: _RenderFieldWidget(
                  question: q,
                  locale: locale,
                  style: qStyle,
                  helperText: _helperText(q),
                  placeholder: _placeholder(q),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Standard section shell (header + questions + children)
  // ---------------------------------------------------------------------------
  Widget _buildStandardSection(
    BuildContext context,
    FormSection section,
    String locale,
    Color sectionBg,
    Color headerBg,
    Map<String, dynamic> metadata,
  ) {
    final sectionStyle = SectionStyle.fromJson(
      Map<String, dynamic>.from(section.ui['style'] as Map? ?? const {}),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionStyle.showHeader)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(sectionStyle.borderRadius),
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title.translate(locale),
                  style: _sectionTypographyStyle(
                    baseColor:
                        metadata['titleColor']?.toString() ??
                        sectionStyle.titleColor,
                    fallbackColor: AppColors.textDark,
                    sizeKey: 'titleSize',
                    weightKey: 'titleWeight',
                    fallbackSize: 18,
                    metadata: metadata,
                  ),
                ),
                if ((section.description?.translate(locale) ?? '')
                    .isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    section.description.translate(locale),
                    style: _sectionTypographyStyle(
                      baseColor:
                          metadata['descColor']?.toString() ??
                          sectionStyle.descriptionColor,
                      fallbackColor: AppColors.textGrey,
                      sizeKey: 'descSize',
                      weightKey: 'descWeight',
                      fallbackSize: 14,
                      metadata: metadata,
                    ),
                  ),
                ],
              ],
            ),
          ),
        _buildQuestionsGrid(context, section, locale, sectionStyle),
        if (section.sections.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.sections.map((child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildSection(context, child, locale),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Layout dispatcher
  // ---------------------------------------------------------------------------
  Widget _buildSection(BuildContext context, FormSection section, String locale) {
    final sectionStyle = SectionStyle.fromJson(
      Map<String, dynamic>.from(section.ui['style'] as Map? ?? const {}),
    );
    final metadata = section.metadata;

    Color sectionBg;
    Color headerBg;
    try {
      sectionBg = Color(
        int.parse(sectionStyle.backgroundColor.replaceAll('#', '0xFF')),
      );
      headerBg = Color(
        int.parse(sectionStyle.headerBackgroundColor.replaceAll('#', '0xFF')),
      );
    } catch (_) {
      sectionBg = Colors.white;
      headerBg = AppColors.builderElement.withValues(alpha: 0.5);
    }

    // ---- Layout-specific widgets (with conditions) ----
    final layout = SectionLayoutType.values.firstWhere(
      (e) => e.name == section.layout,
      orElse: () => SectionLayoutType.standard,
    );
    final hasSubSections = section.sections.isNotEmpty;
    final hasEnoughSubSections = section.sections.length >= 2;

    // ACCORDION: works with just questions — no sub-section requirement.
    if (layout == SectionLayoutType.accordion) {
      return AccordionSection(
        section: section,
        locale: locale,
        sectionBg: sectionBg,
        metadata: metadata,
        questionsGrid: _buildQuestionsGrid(
          context,
          section,
          locale,
          sectionStyle,
        ),
        childSections:
            section.sections.map((c) => _buildSection(context, c, locale)).toList(),
      );
    }

    // TABBED: requires at least 1 sub-section to use as tabs.
    // Falls back to standard if no sub-sections.
    if (layout == SectionLayoutType.tabbed && hasSubSections) {
      return TabbedSection(
        section: section,
        tabs: section.sections,
        locale: locale,
        sectionBg: sectionBg,
        headerBg: headerBg,
        metadata: metadata,
        sectionStyle: sectionStyle,
        buildQuestionsGrid: (s) =>
            _buildQuestionsGrid(
              context,
              s,
              locale,
              SectionStyle.fromJson(
                Map<String, dynamic>.from(s.ui['style'] as Map? ?? const {}),
              ),
            ),
      );
    }

    // SIDEBAR: requires at least 1 sub-section as nav items.
    // Falls back to standard if no sub-sections.
    if (layout == SectionLayoutType.sidebar && hasSubSections) {
      return SidebarSection(
        section: section,
        locale: locale,
        sectionBg: sectionBg,
        headerBg: headerBg,
        metadata: metadata,
        sectionStyle: sectionStyle,
        buildQuestionsGrid: (s) =>
            _buildQuestionsGrid(
              context,
              s,
              locale,
              SectionStyle.fromJson(
                Map<String, dynamic>.from(s.ui['style'] as Map? ?? const {}),
              ),
            ),
        buildChildSection: (s) => _buildSection(context, s, locale),
      );
    }

    // WIZARD: requires at least 1 sub-section as steps.
    // Falls back to standard if no sub-sections.
    if (layout == SectionLayoutType.wizard && hasSubSections) {
      return WizardSection(
        section: section,
        steps: section.sections as List,
        locale: locale,
        sectionBg: sectionBg,
        metadata: metadata,
        sectionStyle: sectionStyle,
        buildQuestionsGrid: (s) =>
            _buildQuestionsGrid(context, s, locale, s.style),
      );
    }

    // MASONRY: requires 2+ sub-sections for meaningful staggered columns.
    // Falls back to standard if not enough sub-sections.
    if (layout == SectionLayoutType.masonry && hasEnoughSubSections) {
      return MasonrySection(
        section: section,
        locale: locale,
        sectionBg: sectionBg,
        headerBg: headerBg,
        metadata: metadata,
        sectionStyle: sectionStyle,
        buildChildSection: (s) => _buildSection(context, s, locale),
      );
    }

    // ---- Default: standard, grid, list, fullWidth, centered, card, etc. ----
    Widget content = _buildStandardSection(
      context,
      section,
      locale,
      sectionBg,
      headerBg,
      metadata,
    );

    final alignStr = metadata['alignment']?.toString() ?? 'left';
    AlignmentGeometry contentAlignment = Alignment.centerLeft;
    if (alignStr == 'center') contentAlignment = Alignment.center;
    if (alignStr == 'right') contentAlignment = Alignment.centerRight;

    final defaultMaxWidth = layout == SectionLayoutType.centered
        ? 760.0
        : 1200.0;
    final maxWidth =
        (metadata['maxWidth'] as num?)?.toDouble() ?? defaultMaxWidth;

    if (layout == SectionLayoutType.centered ||
        layout == SectionLayoutType.fullWidth) {
      content = Align(
        alignment: contentAlignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: content,
        ),
      );
    } else if (layout == SectionLayoutType.dashboard) {
      content = Align(alignment: contentAlignment, child: content);
    }

    final extraShadow = (layout == SectionLayoutType.card || metadata['isCardLayout'] == true)
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ]
        : <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ];

    Border? extraBorder;
    if (layout == SectionLayoutType.sidebar) {
      extraBorder = Border(
        left: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.55),
          width: 4,
        ),
      );
    } else if (layout == SectionLayoutType.overlay) {
      extraBorder = Border.all(
        color: AppColors.primary.withValues(alpha: 0.28),
        width: 2,
      );
    }

    BoxDecoration decoration = BoxDecoration(
      color: layout == SectionLayoutType.dashboard ? null : sectionBg,
      gradient: layout == SectionLayoutType.dashboard
          ? LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.10), sectionBg],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
      boxShadow: extraShadow,
      border:
          extraBorder ??
          Border.all(color: AppColors.borderLight.withValues(alpha: 0.9)),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: decoration,
      child: content,
    );
  }
}

class _RenderFieldWidget extends StatelessWidget {
  final FormQuestion question;
  final String locale;
  final QuestionStyle style;
  final dynamic helperText;
  final dynamic placeholder;

  const _RenderFieldWidget({
    required this.question,
    required this.locale,
    required this.style,
    required this.helperText,
    required this.placeholder,
  });

  QuestionStyle _styleFor(FormQuestion question) {
    final raw = question.ui['style'];
    if (raw is Map) {
      return QuestionStyle.fromJson(Map<String, dynamic>.from(raw));
    }
    return const QuestionStyle();
  }

  dynamic _placeholderFor(FormQuestion question) {
    return question.metadata['placeholder'] ?? '';
  }

  FontWeight _parseFontWeight(String weight) {
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'medium':
        return FontWeight.w500;
      case 'normal':
      default:
        return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color labelColor;
    Color helperColor;

    try {
      labelColor = Color(int.parse(style.labelColor.replaceAll('#', '0xFF')));
      helperColor = Color(int.parse(style.helperColor.replaceAll('#', '0xFF')));
    } catch (_) {
      labelColor = AppColors.textDark;
      helperColor = AppColors.textGrey;
    }

    final labelPosition = style.labelPosition;
    final isLeftAligned = labelPosition == 'left';
    final isHidden = labelPosition == 'hidden';

    Widget labelWidget = Row(
      children: [
        Expanded(
          child: Text(
            question.label.translate(locale).isEmpty
                ? 'Untitled ${question.type.label}'
                : question.label.translate(locale),
            style: TextStyle(
              color: labelColor,
              fontSize: style.labelFontSize,
              fontWeight: _parseFontWeight(style.labelFontWeight),
            ),
          ),
        ),
        if (question.isRequired)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              '*',
              style: TextStyle(color: Colors.red[400], fontSize: 16),
            ),
          ),
      ],
    );

    Widget? helperWidget;
    if (helperText.translate(locale).isNotEmpty) {
      helperWidget = Text(
        helperText.translate(locale),
        style: TextStyle(
          color: helperColor,
          fontSize: style.helperFontSize,
          fontWeight: _parseFontWeight(style.helperFontWeight),
        ),
      );
    }

    if (isHidden) {
      return Container(
        margin: EdgeInsets.only(bottom: style.verticalMargin),
        padding: EdgeInsets.all(style.containerPadding ?? 0),
        child: _buildFieldInput(question, locale),
      );
    }

    if (isLeftAligned) {
      return Container(
        margin: EdgeInsets.only(bottom: style.verticalMargin),
        padding: EdgeInsets.all(style.containerPadding ?? 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  style.labelColumnWidth ??
                  120, // Fixed width for left aligned label
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
            Expanded(child: _buildFieldInput(question, locale)),
          ],
        ),
      );
    }

    // Default Top Aligned
    return Container(
      margin: EdgeInsets.only(bottom: style.verticalMargin),
      padding: EdgeInsets.all(style.containerPadding ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget,
          if (helperWidget != null) ...[
            const SizedBox(height: 4),
            helperWidget,
          ],
          const SizedBox(height: 8),
          _buildFieldInput(question, locale),
        ],
      ),
    );
  }

  Widget _buildFieldInput(FormQuestion q, String locale) {
    final inputStyle = style.inputStyle;
    Color fillColor = AppColors.fieldBackground;
    BoxBorder? border = Border.all(color: AppColors.borderLight);
    List<BoxShadow>? shadows;
    double radius = 6.0;

    switch (inputStyle) {
      case 'filled':
        fillColor = Colors.grey.shade200;
        border = const Border(
          bottom: BorderSide(color: AppColors.textGrey, width: 1.5),
        );
        break;
      case 'glass':
        fillColor = Colors.white.withValues(alpha: 0.3);
        border = Border.all(color: Colors.white.withValues(alpha: 0.5));
        break;
      case 'minimalist':
        fillColor = Colors.transparent;
        border = const Border(bottom: BorderSide(color: AppColors.borderLight));
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
        break;
      case 'rounded':
        radius = 20.0;
        break;
      case 'underlined':
        fillColor = Colors.transparent;
        border = const Border(bottom: BorderSide(color: AppColors.borderLight));
        radius = 0;
        break;
      case 'outlined':
      default:
        break;
    }

    final containerDecor = BoxDecoration(
      color: fillColor,
      borderRadius:
          inputStyle == 'filled' ||
              inputStyle == 'minimalist' ||
              inputStyle == 'underlined'
          ? BorderRadius.vertical(top: Radius.circular(radius))
          : BorderRadius.circular(radius),
      border: border,
      boxShadow: shadows,
    );

    Color inputColor;
    try {
      inputColor = Color(
        int.parse(style.inputFontColor.replaceAll('#', '0xFF')),
      );
    } catch (_) {
      inputColor = AppColors.textDark;
    }

    final textStyle = TextStyle(
      color: inputColor,
      fontSize: style.inputFontSize,
      fontWeight: _parseFontWeight(style.inputFontWeight),
    );

    switch (q.type) {
      case QuestionType.shortText:
      case QuestionType.password:
      case QuestionType.number:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.tel:
      case QuestionType.url:
        return Container(
          height: style.height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (style.prefixIcon?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(style.prefixIcon!, style: textStyle),
                ),
              Expanded(
                child: Text(
                  placeholder.translate(locale).isEmpty
                      ? _getPlaceholderForType(q.type)
                      : placeholder.translate(locale),
                  style: textStyle.copyWith(
                    color: textStyle.color?.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (style.suffixIcon?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(style.suffixIcon!, style: textStyle),
                ),
            ],
          ),
        );
      case QuestionType.paragraph:
        return Container(
          height: style.height ?? 120,
          padding: const EdgeInsets.all(12),
          decoration: containerDecor,
          alignment: Alignment.topLeft,
          child: Text(
            placeholder.translate(locale).isEmpty
                ? 'Long answer text...'
                : placeholder.translate(locale),
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.5),
            ),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: style.height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          child: Row(
            children: [
              Text(
                placeholder.translate(locale).isEmpty
                    ? 'Select an option'
                    : placeholder.translate(locale),
                style: textStyle.copyWith(
                  color: textStyle.color?.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color:
                    textStyle.color?.withValues(alpha: 0.5) ??
                    AppColors.textGrey,
              ),
            ],
          ),
        );
      case QuestionType.checkboxes:
        final options = q.options.isEmpty
            ? const <Map<String, dynamic>>[
                {
                  'id': '1',
                  'option_label': 'Option 1',
                  'option_value': '1',
                  'order': 0,
                },
                {
                  'id': '2',
                  'option_label': 'Option 2',
                  'option_value': '2',
                  'order': 1,
                },
              ]
            : q.options;
        return Column(
          children: options.map((opt) {
            final label =
                (opt['option_label'] ?? opt['label'] ?? '').toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: textStyle.color ?? AppColors.textGrey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(label, style: textStyle),
                        ],
                      ),
                    );
                  }).toList(),
        );
      case QuestionType.multipleChoice:
        final options = q.options.isEmpty
            ? const <Map<String, dynamic>>[
                {
                  'id': '1',
                  'option_label': 'Option 1',
                  'option_value': '1',
                  'order': 0,
                },
                {
                  'id': '2',
                  'option_label': 'Option 2',
                  'option_value': '2',
                  'order': 1,
                },
              ]
            : q.options;
        return Column(
          children: options.map((opt) {
            final label =
                (opt['option_label'] ?? opt['label'] ?? '').toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.radio_button_unchecked,
                            size: 22,
                            color: textStyle.color ?? AppColors.textGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(label, style: textStyle),
                        ],
                      ),
                    );
                  }).toList(),
        );
      case QuestionType.fileUpload:
        return Container(
          height: style.height ?? 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderLight, width: 1),
            color: AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: AppColors.textGrey,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Click to upload file',
                  style: textStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        );
      case QuestionType.rating:
        return Row(
          children: List.generate(
            5,
            (i) => Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.star_border,
                color: textStyle.color ?? Colors.orange,
                size: 36,
              ),
            ),
          ),
        );
      case QuestionType.signature:
        return Container(
          height: style.height ?? 150,
          decoration: containerDecor.copyWith(color: Colors.grey.shade50),
          child: Center(
            child: Icon(
              Icons.draw,
              color:
                  textStyle.color?.withValues(alpha: 0.3) ?? AppColors.textGrey,
              size: 48,
            ),
          ),
        );
      case QuestionType.slider:
        return Column(
          children: [
            Slider(
              value: 0.5,
              onChanged: (_) {},
              activeColor: textStyle.color ?? AppColors.brandBlue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: textStyle.copyWith(fontSize: 14)),
                  Text('100', style: textStyle.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ],
        );
      case QuestionType.image:
        return Container(
          height: style.height ?? 200,
          decoration: containerDecor.copyWith(color: Colors.grey.shade50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color:
                      textStyle.color?.withValues(alpha: 0.3) ??
                      AppColors.textGrey,
                  size: 64,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload Image',
                  style: textStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        );
      case QuestionType.otp:
      case QuestionType.richText:
      case QuestionType.markdownEditor:
      case QuestionType.address:
      case QuestionType.addressLookup:
      case QuestionType.mapLocation:
      case QuestionType.multiFileUpload:
      case QuestionType.filePicker:
      case QuestionType.fileList:
      case QuestionType.imageGallery:
      case QuestionType.signaturePad:
      case QuestionType.calculate:
      case QuestionType.calculated:
      case QuestionType.booleanValue:
      case QuestionType.multiSelect:
      case QuestionType.colorPicker:
      case QuestionType.range:
      case QuestionType.dateRange:
      case QuestionType.timeRange:
      case QuestionType.stepper:
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
      case QuestionType.toggle:
      case QuestionType.multiCheckbox:
      case QuestionType.emailList:
      case QuestionType.qrCodeScan:
      case QuestionType.search:
      case QuestionType.file:
        return _buildSpecialFieldCard(q, textStyle, locale);
      case QuestionType.divider:
        return Divider(
          height: 32,
          thickness: 1,
          color: textStyle.color ?? AppColors.borderLight,
        );
      case QuestionType.spacer:
        return SizedBox(height: style.height ?? 32);
      case QuestionType.matrixChoice:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: containerDecor,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 120),
                  ...List.generate(
                    3,
                    (i) => Expanded(
                      child: Center(
                        child: Text(
                          'Column ${i + 1}',
                          style: textStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Row ${i + 1}',
                          style: textStyle.copyWith(fontSize: 14),
                        ),
                      ),
                      ...List.generate(
                        3,
                        (j) => const Expanded(
                          child: Center(
                            child: Icon(
                              Icons.radio_button_unchecked,
                              size: 20,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getPlaceholderForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return 'Short answer text';
      case QuestionType.number:
        return 'Number';
      case QuestionType.date:
        return 'YYYY-MM-DD';
      case QuestionType.time:
        return 'HH:MM';
      case QuestionType.email:
        return 'name@example.com';
      case QuestionType.mobile:
        return '+1 234 567 890';
      case QuestionType.url:
        return 'https://example.com';
      default:
        return '';
    }
  }

  Widget _buildSpecialFieldCard(
    FormQuestion q,
    TextStyle textStyle,
    String locale,
  ) {
    final style = _styleFor(q);
    final placeholder = _placeholderFor(q);
    return Container(
      height: style.height ?? 120,
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_fix_high,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                q.type.label,
                style: textStyle.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            placeholder.translate(locale).isEmpty
                ? 'Specialized input preview'
                : placeholder.translate(locale),
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This field type is supported in the catalog and save contract, and can be specialized further in the next UX pass.',
            style: TextStyle(fontSize: 11, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
