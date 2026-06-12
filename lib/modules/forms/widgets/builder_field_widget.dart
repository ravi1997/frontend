import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import 'package:frontend/shared/models/form_models.dart';

import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/modules/forms/models/question_type.dart';

class BuilderFieldWidget extends StatelessWidget {
  final FormQuestion question;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final String locale;

  const BuilderFieldWidget({
    super.key,
    required this.question,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onDuplicate,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final style = _questionStyle(question);
    final bgColor = _parseHexColor(
      style.backgroundColor,
      Theme.of(context).colorScheme.surface,
    );
    final borderColor = _parseHexColor(
      style.borderColor,
      AppColors.borderLight,
    );

    final labelPosition = style.labelPosition;
    final isLeftAligned = labelPosition == 'left';
    final isHidden = labelPosition == 'hidden';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: style.verticalMargin),
        decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(style.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.brandBlue : borderColor,
            width: isSelected ? 2 : style.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: DesignTokens.spaceS / 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(style.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Drag handle + Actions + Optional Label)
            _buildHeader(context, isLeftAligned, isHidden),

            if (isLeftAligned) ...[
            const SizedBox(height: DesignTokens.spaceM),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: style.labelColumnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelText(context),
                        if (_localizedText(_helperText(question), locale).isNotEmpty)
                          ...[
                          const SizedBox(height: DesignTokens.spaceXS),
                          _buildHelperText(context),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceM),
                  Expanded(child: _buildFieldPreview(question, locale)),
                ],
              ),
            ] else ...[
              // Top or Hidden
              if (!isHidden &&
                  _localizedText(_helperText(question), locale).isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spaceXS),
                _buildHelperText(context),
              ],
              const SizedBox(height: DesignTokens.spaceM),
              _buildFieldPreview(question, locale),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isLeftAligned, bool isHidden) {
    return Row(
      children: [
        isSelected
            ? const Icon(
                Icons.check_circle,
                size: 14,
                color: AppColors.primary,
              )
            : FaIcon(
                FontAwesomeIcons.gripVertical,
                size: 14,
                color: AppColors.textGrey.withValues(alpha: 0.5),
              ),
        const SizedBox(width: DesignTokens.spaceS),
        if (!isLeftAligned)
          Expanded(
            child: isHidden
                ? Text(
                    '${_localizedText(question.label, locale)} (Hidden)',
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : _buildLabelText(context),
          )
        else
          const Spacer(),
        IconButton(
          icon: const Icon(Icons.copy, size: 18, color: AppColors.textGrey),
          onPressed: onDuplicate,
          tooltip: 'Duplicate Field',
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            size: 20,
            color: isSelected ? Colors.redAccent : AppColors.textGrey,
          ),
          onPressed: onDelete,
          tooltip: 'Delete Field',
        ),
      ],
    );
  }

  Widget _buildLabelText(BuildContext context) {
    final style = _questionStyle(question);
    final labelColor = _parseHexColor(style.labelColor, AppColors.textDark);

    return RichText(
      text: TextSpan(
        text: _localizedText(question.label, locale).isEmpty
            ? 'Untitled ${question.type.label}'
            : _localizedText(question.label, locale),
        style: TextStyle(
          color: labelColor,
          fontSize: style.labelFontSize,
          fontWeight: _parseFontWeight(style.labelFontWeight),
          fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
        ),
        children: [
          if (question.isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: DesignTokens.fontBase,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHelperText(BuildContext context) {
    final style = _questionStyle(question);
    final helperColor = _parseHexColor(style.helperColor, AppColors.textGrey);

    return Text(
      _localizedText(_helperText(question), locale),
      style: TextStyle(
        color: helperColor,
        fontSize: style.helperFontSize,
        fontWeight: _parseFontWeight(style.helperFontWeight),
      ),
    );
  }

  QuestionStyle _questionStyle(FormQuestion q) {
    final raw = q.ui['style'];
    if (raw is Map) {
      return QuestionStyle.fromJson(Map<String, dynamic>.from(raw));
    }
    return const QuestionStyle();
  }

  Color _parseHexColor(String value, Color fallback) {
    try {
      return Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  dynamic _helperText(FormQuestion q) {
    // Current canonical field name is `helpText`, but some flows store it in metadata.
    return q.helpText ?? q.metadata['helper_text'] ?? '';
  }

  dynamic _placeholder(FormQuestion q) {
    return q.metadata['placeholder'] ?? '';
  }

  String _localizedText(dynamic value, String locale) {
    if (value is String) return value;
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      if (map.containsKey(locale)) return map[locale].toString();
      if (map.containsKey('en')) return map['en'].toString();
      if (map.isNotEmpty) return map.values.first.toString();
    }
    return '';
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

  Widget _buildFieldPreview(FormQuestion q, String locale) {
    // This is a READ-ONLY preview for the builder.
    // It mocks the appearance of the field.

    final style = _questionStyle(q);
    final inputStyle = style.inputStyle;
    Color fillColor = AppColors.fieldBackground;
    BoxBorder? border = Border.all(color: AppColors.borderLight);
    List<BoxShadow>? shadows;
    double radius = DesignTokens.radiusS;

    switch (inputStyle) {
      case 'filled':
        fillColor = AppColors.builderElement;
        border = const Border(
          bottom: BorderSide(color: AppColors.textGrey, width: 1.5),
        );
        break;
      case 'glass':
        fillColor = AppColors.fieldBackground.withValues(alpha: 0.3);
        border = Border.all(color: AppColors.borderLight.withValues(alpha: 0.5));
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
        // Default styles
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

    // Parse input style
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
          height: style.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (style.prefixIcon.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(style.prefixIcon, style: textStyle),
                ),
              Expanded(
                child: Text(
                  _localizedText(_placeholder(q), locale).isEmpty
                      ? _getPlaceholderForType(q.type)
                      : _localizedText(_placeholder(q), locale),
                  style: textStyle.copyWith(
                    color: textStyle.color?.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (style.suffixIcon.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(style.suffixIcon, style: textStyle),
                ),
            ],
          ),
        );
              case QuestionType.paragraph:
                return Container(
          height: style.height,
          padding: const EdgeInsets.all(12),
          decoration: containerDecor,
          alignment: Alignment.topLeft,
          child: Text(
            _localizedText(_placeholder(q), locale).isEmpty
                ? 'Long answer text...'
                : _localizedText(_placeholder(q), locale),
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.5),
            ),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: style.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          child: Row(
            children: [
              Text(
                _localizedText(_placeholder(q), locale).isEmpty
                    ? 'Select an option'
                    : _localizedText(_placeholder(q), locale),
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
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: textStyle.color ?? AppColors.textGrey,
                              ),
                            ),
                          ),
        const SizedBox(width: DesignTokens.spaceS),
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
                            size: 20,
                            color: textStyle.color ?? AppColors.textGrey,
                          ),
                          const SizedBox(width: DesignTokens.spaceS),
                          Text(label, style: textStyle),
                        ],
                      ),
                    );
                  }).toList(),
        );
              case QuestionType.fileUpload:
                return Container(
          height: style.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderLight,
              style: BorderStyle.none,
              width: 1,
            ),
            color: AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(color: AppColors.textGrey),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.textGrey,
                    size: 24,
                  ),
                      const SizedBox(height: DesignTokens.spaceS),
                  Text(
                    'Click to upload file',
                    style: textStyle.copyWith(
                      fontSize: DesignTokens.fontS,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
              case QuestionType.signature:
                return Container(
          height: style.height,
          decoration: containerDecor.copyWith(
            color: AppColors.fieldBackground,
          ),
          child: Center(
            child: Icon(
              Icons.draw,
              color:
                  textStyle.color?.withValues(alpha: 0.3) ?? AppColors.textGrey,
              size: 32,
            ),
          ),
        );
              case QuestionType.image:
                return Container(
          height: style.height,
          decoration: containerDecor.copyWith(
            color: AppColors.fieldBackground,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color:
                      textStyle.color?.withValues(alpha: 0.3) ??
                      AppColors.textGrey,
                  size: 32,
                ),
                const SizedBox(height: DesignTokens.spaceS),
                Text(
                  'Upload Image',
                  style: textStyle.copyWith(
                    fontSize: DesignTokens.fontS,
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
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.star_border,
                color: textStyle.color ?? Colors.orange,
                size: 28,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0', style: textStyle.copyWith(fontSize: DesignTokens.fontS)),
                  Text('100', style: textStyle.copyWith(fontSize: DesignTokens.fontS)),
                ],
              ),
            ),
          ],
        );
      case QuestionType
          .divider: // Added manually as switch needs to cover all or default
        return Divider(
          height: 32,
          thickness: 1,
          color: textStyle.color ?? AppColors.borderLight,
        );
              case QuestionType.spacer:
        return SizedBox(height: style.height);
      case QuestionType.matrixChoice:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: containerDecor,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 80),
                  ...List.generate(
                    3,
                    (i) => Expanded(
                      child: Center(
                        child: Text(
                          'Col ${i + 1}',
                          style: textStyle.copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              ...List.generate(
                2,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Row ${i + 1}',
                          style: textStyle.copyWith(fontSize: 10),
                        ),
                      ),
                      ...List.generate(
                        3,
                        (j) => const Expanded(
                          child: Center(
                            child: Icon(
                              Icons.radio_button_unchecked,
                              size: 14,
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
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth = 1;
  final double dashWidth = 5;
  final double dashSpace = 3;

  _DashedBorderPainter({this.color = const Color(0xFFD6D0C5)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(6),
        ),
      );

    final dashPath = Path();
    double distance = 0.0;

    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
