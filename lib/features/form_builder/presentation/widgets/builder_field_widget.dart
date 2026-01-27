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
          color: AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
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
                  color: Colors.white24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.label.isEmpty
                        ? 'Untitled ${question.type.label}'
                        : question.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    onPressed: onDelete,
                    tooltip: 'Delete Field',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFieldPreview(question),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldPreview(FormQuestion q) {
    // This is a READ-ONLY preview.
    // We use standard Flutter widgets to simulate the look.

    switch (q.type) {
      case QuestionType.shortText:
      case QuestionType.number:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            q.placeholder ?? '${q.type.label} input placeholder...',
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        );
      case QuestionType.paragraph:
        return Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24),
          ),
          alignment: Alignment.topLeft,
          child: Text(
            q.placeholder ?? 'Long answer text...',
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        );
      case QuestionType.dropdown:
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            children: [
              Text(
                'Select an option',
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down, color: Colors.white38),
            ],
          ),
        );
      case QuestionType.checkboxes:
        return Column(
          children: (q.options ?? ['Option 1']).map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_box_outline_blank,
                    size: 18,
                    color: Colors.white38,
                  ),
                  const SizedBox(width: 8),
                  Text(opt, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }).toList(),
        );
      case QuestionType.multipleChoice:
        return Column(
          children: (q.options ?? ['Option 1']).map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.radio_button_unchecked,
                    size: 18,
                    color: Colors.white38,
                  ),
                  const SizedBox(width: 8),
                  Text(opt, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }).toList(),
        );
      case QuestionType.fileUpload:
        return Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white24,
              style: BorderStyle.solid,
            ), // Should be dashed ideally
            borderRadius: BorderRadius.circular(4),
            color: Colors.white10,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
                SizedBox(height: 4),
                Text(
                  'Click to upload file',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        );
    }
  }
}
