import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/question_type.dart';

class BuilderFieldWidget extends StatelessWidget {
  final FormQuestion question;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const BuilderFieldWidget({
    super.key,
    required this.question,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final style = question.style;
    Color bgColor;
    Color borderColor;
    Color labelColor;
    Color helperColor;

    try {
      bgColor = Color(int.parse(style.backgroundColor.replaceAll('#', '0xFF')));
      borderColor = Color(int.parse(style.borderColor.replaceAll('#', '0xFF')));
      labelColor = Color(int.parse(style.labelColor.replaceAll('#', '0xFF')));
      helperColor = Color(int.parse(style.helperColor.replaceAll('#', '0xFF')));
    } catch (_) {
      bgColor = Colors.white;
      borderColor = AppColors.borderLight;
      labelColor = AppColors.textDark;
      helperColor = AppColors.textGrey;
    }

    return GestureDetector(
      onTap: onTap,
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
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.gripVertical,
                  size: 14,
                  color: AppColors.textGrey.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.label.isEmpty
                        ? 'Untitled ${question.type.label}'
                        : question.label,
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
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 18,
                    color: AppColors.textGrey,
                  ),
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
            const SizedBox(height: 16),
            _buildFieldPreview(question),
          ],
        ),
      ),
    );
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

  Widget _buildFieldPreview(FormQuestion q) {
    // This is a READ-ONLY preview for the builder.
    // It mocks the appearance of the field.

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
      case QuestionType.number:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return Container(
          height: 42,
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
                  q.placeholder ?? _getPlaceholderForType(q.type),
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
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: containerDecor,
          alignment: Alignment.topLeft,
          child: Text(
            q.placeholder ?? 'Long answer text...',
            style: textStyle.copyWith(
              color: textStyle.color?.withValues(alpha: 0.5),
            ),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: containerDecor,
          child: Row(
            children: [
              Text(
                'Select an option',
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
          children: (q.options ?? ['Option 1', 'Option 2']).map((opt) {
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
                  const SizedBox(width: 8),
                  Text(opt, style: textStyle),
                ],
              ),
            );
          }).toList(),
        );
      case QuestionType.multipleChoice:
        return Column(
          children: (q.options ?? ['Option 1', 'Option 2']).map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 20,
                    color: textStyle.color ?? AppColors.textGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(opt, style: textStyle),
                ],
              ),
            );
          }).toList(),
        );
      case QuestionType.fileUpload:
        return Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderLight,
              style: BorderStyle.none, // Can't do dashed easily with Border
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
                  const SizedBox(height: 8),
                  Text(
                    'Click to upload file',
                    style: textStyle.copyWith(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ), // Keep generic for file upload
                  ),
                ],
              ),
            ),
          ),
        );
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

  _DashedBorderPainter({this.color = Colors.grey});

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
