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

  const BuilderFieldWidget({
    super.key,
    required this.question,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.brandBlue : AppColors.borderLight,
            width: isSelected ? 2 : 1,
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
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            _buildFieldPreview(question),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldPreview(FormQuestion q) {
    // This is a READ-ONLY preview for the builder.
    // It mocks the appearance of the field.

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
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderLight),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            q.placeholder ?? _getPlaceholderForType(q.type),
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
        );
      case QuestionType.paragraph:
        return Container(
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderLight),
          ),
          alignment: Alignment.topLeft,
          child: Text(
            q.placeholder ?? 'Long answer text...',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Text(
                'Select an option',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down, color: AppColors.textGrey),
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
                      border: Border.all(color: AppColors.textGrey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    opt,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
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
                  const Icon(
                    Icons.radio_button_unchecked,
                    size: 20,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    opt,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
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
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.textGrey,
                    size: 24,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Click to upload file',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
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
