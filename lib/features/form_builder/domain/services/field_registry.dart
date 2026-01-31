import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../entities/question_type.dart';
import '../entities/form_question.dart';
import 'package:uuid/uuid.dart';

class FieldRegistry {
  static FormQuestion getDefaultQuestion(QuestionType type) {
    final id = const Uuid().v4();

    Map<String, dynamic>? metadata;

    switch (type) {
      case QuestionType.rating:
        metadata = {'maxStars': 5, 'icon': 'star'};
        break;
      case QuestionType.slider:
        metadata = {'min': 0, 'max': 100, 'step': 1};
        break;
      case QuestionType.matrixChoice:
        metadata = {
          'rows': ['Row 1', 'Row 2'],
          'columns': ['Col 1', 'Col 2', 'Col 3'],
        };
        break;
      default:
        break;
    }

    return FormQuestion(
      id: id,
      label: 'Untitled ${type.label}',
      type: type,
      metadata: metadata,
      options:
          (type == QuestionType.dropdown ||
              type == QuestionType.checkboxes ||
              type == QuestionType.multipleChoice)
          ? ['Option 1', 'Option 2']
          : null,
    );
  }

  static IconData getIconForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return FontAwesomeIcons.textWidth;
      case QuestionType.paragraph:
        return FontAwesomeIcons.alignLeft;
      case QuestionType.number:
        return FontAwesomeIcons.hashtag;
      case QuestionType.date:
        return FontAwesomeIcons.calendar;
      case QuestionType.time:
        return FontAwesomeIcons.clock;
      case QuestionType.dropdown:
        return FontAwesomeIcons.caretDown;
      case QuestionType.checkboxes:
        return FontAwesomeIcons.squareCheck;
      case QuestionType.multipleChoice:
        return FontAwesomeIcons.circleDot;
      case QuestionType.fileUpload:
        return FontAwesomeIcons.fileArrowUp;
      case QuestionType.email:
        return FontAwesomeIcons.envelope;
      case QuestionType.mobile:
        return FontAwesomeIcons.phone;
      case QuestionType.url:
        return FontAwesomeIcons.link;
      case QuestionType.rating:
        return FontAwesomeIcons.star;
      case QuestionType.signature:
        return FontAwesomeIcons.signature;
      case QuestionType.slider:
        return FontAwesomeIcons.sliders;
      case QuestionType.image:
        return FontAwesomeIcons.image;
      case QuestionType.divider:
        return FontAwesomeIcons.gripLines;
      case QuestionType.spacer:
        return FontAwesomeIcons.arrowsUpDown;
      case QuestionType.matrixChoice:
        return FontAwesomeIcons.tableCells;
    }
  }

  static Color getColorForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
      case QuestionType.paragraph:
      case QuestionType.number:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return Colors.blue; // Or AppColors.fieldText if accessible
      case QuestionType.dropdown:
      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        return Colors.green; // Or AppColors.fieldChoice
      case QuestionType.date:
      case QuestionType.time:
        return Colors.purple; // Or AppColors.fieldDate
      case QuestionType.fileUpload:
      case QuestionType.image:
      case QuestionType.signature:
        return Colors.teal; // Or AppColors.fieldMedia
      case QuestionType.rating:
      case QuestionType.slider:
      case QuestionType.matrixChoice:
        return Colors.orange;
      case QuestionType.divider:
      case QuestionType.spacer:
        return Colors.grey;
    }
  }
}
