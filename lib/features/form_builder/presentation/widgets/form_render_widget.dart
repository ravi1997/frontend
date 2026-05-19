import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_question_option.dart';
import '../../domain/entities/form_layout_type.dart';
import '../../domain/entities/section_layout_type.dart';
import '../../domain/entities/question_type.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    final formStyle = form.style;
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
                          child: _buildSection(
                            context,
                            section,
                            locale,
                          ),
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

  Widget _buildSection(BuildContext context, dynamic section, String locale) {
    final sectionStyle = section.style;
    final metadata = (section.metaData is Map)
        ? Map<String, dynamic>.from(section.metaData)
        : <String, dynamic>{};

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

    final sectionContent = Column(
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
              border: Border(
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
                if (section.description.translate(locale).isNotEmpty) ...[
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
        Padding(
          padding: EdgeInsets.all(sectionStyle.padding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final questionSpacing = 16.0;

              int crossAxisCount = _sectionCrossAxisCount(
                section.layout,
                section.gridColumns,
              );

              if (availableWidth < 400 && crossAxisCount > 1) {
                crossAxisCount = 1;
              } else if (availableWidth < 700 && crossAxisCount > 2) {
                crossAxisCount = 2;
              }

              final itemWidth =
                  (availableWidth - (questionSpacing * (crossAxisCount - 1))) /
                  crossAxisCount;

              return Wrap(
                spacing: questionSpacing,
                runSpacing: questionSpacing,
                children: (section.questions as List).map<Widget>((q) {
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
                    width =
                        (itemWidth * span) + (questionSpacing * (span - 1));
                  }

                  if (width > availableWidth) width = availableWidth;

                  return SizedBox(
                    width: width,
                    child: _RenderFieldWidget(question: q, locale: locale),
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (section.sections.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.sections.map((childSection) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildSection(context, childSection, locale),
                );
              }).toList(),
            ),
          ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: BorderRadius.circular(sectionStyle.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.9)),
      ),
      child: sectionContent,
    );
  }
}

class _RenderFieldWidget extends StatelessWidget {
  final FormQuestion question;
  final String locale;

  const _RenderFieldWidget({required this.question, required this.locale});

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
    final style = question.style;
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
    if (question.helperText.translate(locale).isNotEmpty) {
      helperWidget = Text(
        question.helperText.translate(locale),
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
    final inputStyle = q.style.inputStyle;
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
        int.parse(q.style.inputFontColor.replaceAll('#', '0xFF')),
      );
    } catch (_) {
      inputColor = AppColors.textDark;
    }

    final textStyle = TextStyle(
      color: inputColor,
      fontSize: q.style.inputFontSize,
      fontWeight: _parseFontWeight(q.style.inputFontWeight),
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
          height: q.style.height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (q.style.prefixIcon?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(q.style.prefixIcon!, style: textStyle),
                ),
              Expanded(
                child: Text(
                  q.placeholder.translate(locale).isEmpty
                      ? _getPlaceholderForType(q.type)
                      : q.placeholder.translate(locale),
                  style: textStyle.copyWith(
                    color: textStyle.color?.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (q.style.suffixIcon?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(q.style.suffixIcon!, style: textStyle),
                ),
            ],
          ),
        );
      case QuestionType.paragraph:
        return Container(
          height: q.style.height ?? 120,
          padding: const EdgeInsets.all(12),
          decoration: containerDecor,
          alignment: Alignment.topLeft,
          child: Text(
            q.placeholder.translate(locale).isEmpty
                ? 'Long answer text...'
                : q.placeholder.translate(locale),
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.5),
            ),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: q.style.height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          child: Row(
            children: [
              Text(
                q.placeholder.translate(locale).isEmpty
                    ? 'Select an option'
                    : q.placeholder.translate(locale),
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
        return Column(
          children:
              (q.options ??
                      const [
                        FormQuestionOption(
                          id: '1',
                          label: 'Option 1',
                          value: '1',
                          order: 0,
                        ),
                        FormQuestionOption(
                          id: '2',
                          label: 'Option 2',
                          value: '2',
                          order: 1,
                        ),
                      ])
                  .map((opt) {
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
                          Text(opt.label, style: textStyle),
                        ],
                      ),
                    );
                  })
                  .toList(),
        );
      case QuestionType.multipleChoice:
        return Column(
          children:
              (q.options ??
                      const [
                        FormQuestionOption(
                          id: '1',
                          label: 'Option 1',
                          value: '1',
                          order: 0,
                        ),
                        FormQuestionOption(
                          id: '2',
                          label: 'Option 2',
                          value: '2',
                          order: 1,
                        ),
                      ])
                  .map((opt) {
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
                          Text(opt.label, style: textStyle),
                        ],
                      ),
                    );
                  })
                  .toList(),
        );
      case QuestionType.fileUpload:
        return Container(
          height: q.style.height ?? 100,
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
          height: q.style.height ?? 150,
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
          height: q.style.height ?? 200,
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
        return SizedBox(height: q.style.height ?? 32);
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
    return Container(
      height: q.style.height ?? 120,
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
              const Icon(Icons.auto_fix_high, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                q.type.label,
                style: textStyle.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            q.placeholder.translate(locale).isEmpty
                ? 'Specialized input preview'
                : q.placeholder.translate(locale),
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This field type is supported in the catalog and save contract, and can be specialized further in the next UX pass.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

}
