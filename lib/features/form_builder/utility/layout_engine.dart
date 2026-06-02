import 'package:frontend/core/form_models.dart';
import 'package:frontend/features/form_builder/models/question_type.dart';

class LayoutEngine {
  static int getFieldSpan(FormQuestion field, int sectionColumns) {
    final metadata = field.metadata;
    final layout = metadata['layout'] as Map<String, dynamic>? ?? {};

    final explicitSpan = layout['span']?.toString();

    if (explicitSpan != null &&
        explicitSpan != 'auto' &&
        explicitSpan.isNotEmpty) {
      if (explicitSpan == 'full') return sectionColumns;
      final spanNum = int.tryParse(explicitSpan);
      if (spanNum != null) {
        return spanNum < sectionColumns ? spanNum : sectionColumns;
      }
    }

    final preset = layout['widthPreset']?.toString();

    if (preset == 'small') return 1;
    if (preset == 'medium') return 2 < sectionColumns ? 2 : sectionColumns;
    if (preset == 'large') return 3 < sectionColumns ? 3 : sectionColumns;
    if (preset == 'full') return sectionColumns;

    return getAutoSpanByFieldType(field.type, sectionColumns, field);
  }

  static int getAutoSpanByFieldType(
    QuestionType type,
    int columns,
    FormQuestion field,
  ) {
    final fullWidthTypes = [
      QuestionType.paragraph,
      QuestionType.fileUpload,
      QuestionType.multiFileUpload,
      QuestionType.filePicker,
      QuestionType.fileList,
      QuestionType.signature,
      QuestionType.richText,
      QuestionType.markdownEditor,
      QuestionType.matrixChoice,
      QuestionType.divider,
      QuestionType.spacer,
    ];

    final mediumTypes = [
      QuestionType.address,
      QuestionType.addressLookup,
      QuestionType.email,
      QuestionType.multiSelect,
      QuestionType.checkboxes,
      QuestionType.multipleChoice,
    ];

    if (fullWidthTypes.contains(type)) {
      return columns;
    }

    if (mediumTypes.contains(type)) {
      return 2 < columns ? 2 : columns;
    }

    final labelStr = field.label.toString();
    if (labelStr.length > 40) {
      return 2 < columns ? 2 : columns;
    }

    return 1;
  }
}
