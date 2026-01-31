import 'package:freezed_annotation/freezed_annotation.dart';

enum QuestionType {
  @JsonValue('short_text')
  shortText,
  @JsonValue('paragraph')
  paragraph,
  @JsonValue('number')
  number,
  @JsonValue('date')
  date,
  @JsonValue('time')
  time,
  @JsonValue('dropdown')
  dropdown,
  @JsonValue('checkboxes')
  checkboxes,
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('file_upload')
  fileUpload,
  @JsonValue('email')
  email,
  @JsonValue('mobile')
  mobile,
  @JsonValue('url')
  url,
  @JsonValue('rating')
  rating,
  @JsonValue('signature')
  signature,
  @JsonValue('slider')
  slider,
  @JsonValue('image')
  image,
  @JsonValue('divider')
  divider,
  @JsonValue('spacer')
  spacer,
  @JsonValue('matrix_choice')
  matrixChoice,
}

extension QuestionTypeExtension on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.shortText:
        return 'Short Text';
      case QuestionType.paragraph:
        return 'Long Text';
      case QuestionType.number:
        return 'Number';
      case QuestionType.date:
        return 'Date';
      case QuestionType.time:
        return 'Time';
      case QuestionType.dropdown:
        return 'Dropdown';
      case QuestionType.checkboxes:
        return 'Checkboxes';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.fileUpload:
        return 'File Upload';
      case QuestionType.email:
        return 'Email';
      case QuestionType.mobile:
        return 'Mobile';
      case QuestionType.url:
        return 'URL';
      case QuestionType.rating:
        return 'Rating';
      case QuestionType.signature:
        return 'Signature';
      case QuestionType.slider:
        return 'Slider';
      case QuestionType.image:
        return 'Image';
      case QuestionType.divider:
        return 'Divider';
      case QuestionType.spacer:
        return 'Spacer';
      case QuestionType.matrixChoice:
        return 'Matrix Choice';
    }
  }
}
