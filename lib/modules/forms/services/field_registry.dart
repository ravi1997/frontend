import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:uuid/uuid.dart';

class FieldRegistry {
  static const List<QuestionType> _textCompatibleTypes = [
    QuestionType.shortText,
    QuestionType.paragraph,
    QuestionType.email,
    QuestionType.mobile,
    QuestionType.tel,
    QuestionType.url,
    QuestionType.password,
    QuestionType.number,
    QuestionType.price,
    QuestionType.age,
  ];

  static const List<QuestionType> _choiceCompatibleTypes = [
    QuestionType.dropdown,
    QuestionType.multipleChoice,
    QuestionType.checkboxes,
    QuestionType.multiSelect,
    QuestionType.multiCheckbox,
  ];

  static FormQuestion getDefaultQuestion(QuestionType type) {
    final id = const Uuid().v4();

    Map<String, dynamic>? metadata;
    final String fieldType = _fieldTypeForQuestionType(type);

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
      fieldType: fieldType,
      metadata: metadata ?? const <String, dynamic>{},
      options:
          (type == QuestionType.dropdown ||
              type == QuestionType.checkboxes ||
              type == QuestionType.multipleChoice ||
              type == QuestionType.multiSelect ||
              type == QuestionType.multiCheckbox)
          ? [
              {
                'id': const Uuid().v4(),
                'option_label': 'Option 1',
                'option_value': 'Option 1',
                'order': 0,
              },
              {
                'id': const Uuid().v4(),
                'option_label': 'Option 2',
                'option_value': 'Option 2',
                'order': 1,
              },
            ]
          : const <Map<String, dynamic>>[],
    );
  }

  static FaIconData getIconForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return FontAwesomeIcons.textWidth;
      case QuestionType.paragraph:
        return FontAwesomeIcons.alignLeft;
      case QuestionType.number:
        return FontAwesomeIcons.hashtag;
      case QuestionType.password:
        return FontAwesomeIcons.lock;
      case QuestionType.date:
        return FontAwesomeIcons.calendar;
      case QuestionType.time:
        return FontAwesomeIcons.clock;
      case QuestionType.tel:
      case QuestionType.mobile:
      case QuestionType.phoneNumber:
        return FontAwesomeIcons.phone;
      case QuestionType.calculate:
      case QuestionType.calculated:
        return FontAwesomeIcons.calculator;
      case QuestionType.dropdown:
        return FontAwesomeIcons.caretDown;
      case QuestionType.checkboxes:
        return FontAwesomeIcons.squareCheck;
      case QuestionType.multipleChoice:
        return FontAwesomeIcons.circleDot;
      case QuestionType.multiSelect:
        return FontAwesomeIcons.listCheck;
      case QuestionType.fileUpload:
      case QuestionType.multiFileUpload:
      case QuestionType.filePicker:
      case QuestionType.fileList:
        return FontAwesomeIcons.fileArrowUp;
      case QuestionType.email:
        return FontAwesomeIcons.envelope;
      case QuestionType.url:
        return FontAwesomeIcons.link;
      case QuestionType.rating:
        return FontAwesomeIcons.star;
      case QuestionType.signature:
      case QuestionType.signaturePad:
        return FontAwesomeIcons.signature;
      case QuestionType.slider:
        return FontAwesomeIcons.sliders;
      case QuestionType.image:
      case QuestionType.imageGallery:
        return FontAwesomeIcons.image;
      case QuestionType.mapLocation:
      case QuestionType.address:
      case QuestionType.addressLookup:
        return FontAwesomeIcons.locationDot;
      case QuestionType.otp:
        return FontAwesomeIcons.shieldHalved;
      case QuestionType.richText:
      case QuestionType.markdownEditor:
        return FontAwesomeIcons.fileLines;
      case QuestionType.booleanValue:
      case QuestionType.toggle:
        return FontAwesomeIcons.toggleOn;
      case QuestionType.customField:
        return FontAwesomeIcons.puzzlePiece;
      case QuestionType.colorPicker:
        return FontAwesomeIcons.palette;
      case QuestionType.range:
      case QuestionType.stepper:
        return FontAwesomeIcons.sliders;
      case QuestionType.dateRange:
        return FontAwesomeIcons.calendarDays;
      case QuestionType.timeRange:
        return FontAwesomeIcons.clockRotateLeft;
      case QuestionType.countrySelect:
      case QuestionType.stateSelect:
      case QuestionType.citySelect:
        return FontAwesomeIcons.map;
      case QuestionType.socialMediaHandle:
        return FontAwesomeIcons.at;
      case QuestionType.websiteUrl:
        return FontAwesomeIcons.globe;
      case QuestionType.captcha:
        return FontAwesomeIcons.robot;
      case QuestionType.unitSelect:
        return FontAwesomeIcons.ruler;
      case QuestionType.price:
        return FontAwesomeIcons.dollarSign;
      case QuestionType.age:
        return FontAwesomeIcons.user;
      case QuestionType.multiCheckbox:
        return FontAwesomeIcons.squareCheck;
      case QuestionType.emailList:
        return FontAwesomeIcons.envelopeOpenText;
      case QuestionType.qrCodeScan:
        return FontAwesomeIcons.qrcode;
      case QuestionType.search:
        return FontAwesomeIcons.magnifyingGlass;
      case QuestionType.file:
        return FontAwesomeIcons.file;
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
      case QuestionType.password:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.tel:
      case QuestionType.url:
      case QuestionType.phoneNumber:
        return Colors.blue; // Or AppColors.fieldText if accessible
      case QuestionType.dropdown:
      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
      case QuestionType.multiSelect:
        return Colors.green; // Or AppColors.fieldChoice
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.dateRange:
      case QuestionType.timeRange:
        return Colors.purple; // Or AppColors.fieldDate
      case QuestionType.fileUpload:
      case QuestionType.multiFileUpload:
      case QuestionType.filePicker:
      case QuestionType.fileList:
      case QuestionType.image:
      case QuestionType.signature:
      case QuestionType.signaturePad:
      case QuestionType.imageGallery:
        return Colors.teal; // Or AppColors.fieldMedia
      case QuestionType.rating:
      case QuestionType.slider:
      case QuestionType.matrixChoice:
      case QuestionType.calculate:
      case QuestionType.calculated:
        return Colors.orange;
      case QuestionType.mapLocation:
      case QuestionType.address:
      case QuestionType.addressLookup:
      case QuestionType.otp:
      case QuestionType.customField:
      case QuestionType.colorPicker:
      case QuestionType.stepper:
      case QuestionType.countrySelect:
      case QuestionType.stateSelect:
      case QuestionType.citySelect:
      case QuestionType.socialMediaHandle:
      case QuestionType.websiteUrl:
      case QuestionType.captcha:
      case QuestionType.unitSelect:
      case QuestionType.price:
      case QuestionType.age:
      case QuestionType.toggle:
      case QuestionType.emailList:
      case QuestionType.qrCodeScan:
      case QuestionType.search:
      case QuestionType.file:
      case QuestionType.richText:
      case QuestionType.markdownEditor:
      case QuestionType.booleanValue:
        return Colors.grey;
      case QuestionType.divider:
      case QuestionType.spacer:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  static List<QuestionType> getCompatibleTypes(QuestionType type) {
    if (_textCompatibleTypes.contains(type)) {
      return _textCompatibleTypes;
    }
    if (_choiceCompatibleTypes.contains(type)) {
      return _choiceCompatibleTypes;
    }
    return [type];
  }

  static bool canConvert(QuestionType from, QuestionType to) {
    return getCompatibleTypes(from).contains(to);
  }

  static bool isChoiceType(QuestionType type) {
    return _choiceCompatibleTypes.contains(type);
  }

  static bool isTextType(QuestionType type) {
    return _textCompatibleTypes.contains(type);
  }

  static FormQuestion convertQuestionType(
    FormQuestion question,
    QuestionType newType,
  ) {
    if (question.type == newType) return question;
    if (!canConvert(question.type, newType)) return question;

    final defaults = getDefaultQuestion(newType);
    final shouldKeepOptions =
        isChoiceType(question.type) && isChoiceType(newType);

    return question.copyWith(
      fieldType: _fieldTypeForQuestionType(newType),
      options: shouldKeepOptions ? question.options : defaults.options,
      metadata: {...defaults.metadata, ...question.metadata},
      defaultValue: _isDefaultValueCompatible(newType, question.defaultValue)
          ? question.defaultValue
          : null,
    );
  }

  static String _fieldTypeForQuestionType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return 'input';
      case QuestionType.paragraph:
        return 'textarea';
      case QuestionType.dropdown:
        return 'select';
      case QuestionType.checkboxes:
        return 'checkboxes';
      case QuestionType.multipleChoice:
        return 'radio';
      case QuestionType.fileUpload:
        return 'file_upload';
      case QuestionType.multiFileUpload:
        return 'multi-file_upload';
      case QuestionType.filePicker:
        return 'file_picker';
      case QuestionType.fileList:
        return 'file_list';
      case QuestionType.signaturePad:
        return 'signature_pad';
      case QuestionType.imageGallery:
        return 'image_gallery';
      case QuestionType.divider:
        return 'note';
      case QuestionType.spacer:
        return 'hidden';
      case QuestionType.matrixChoice:
        return 'matrix_choice';
      case QuestionType.mapLocation:
        return 'map_location';
      case QuestionType.addressLookup:
        return 'address_lookup';
      case QuestionType.richText:
        return 'rich_text';
      case QuestionType.markdownEditor:
        return 'markdown_editor';
      case QuestionType.booleanValue:
        return 'boolean';
      case QuestionType.multiSelect:
        return 'multi_select';
      case QuestionType.customField:
        return 'custom_field';
      case QuestionType.colorPicker:
        return 'color_picker';
      case QuestionType.dateRange:
        return 'date_range';
      case QuestionType.timeRange:
        return 'time_range';
      case QuestionType.countrySelect:
        return 'country_select';
      case QuestionType.stateSelect:
        return 'state_select';
      case QuestionType.citySelect:
        return 'city_select';
      case QuestionType.socialMediaHandle:
        return 'social_media_handle';
      case QuestionType.websiteUrl:
        return 'website_url';
      case QuestionType.phoneNumber:
        return 'phone_number';
      case QuestionType.unitSelect:
        return 'unit_select';
      case QuestionType.multiCheckbox:
        return 'multi_checkbox';
      case QuestionType.emailList:
        return 'email_list';
      case QuestionType.qrCodeScan:
        return 'qr_code_scan';
      case QuestionType.calculate:
      case QuestionType.calculated:
      case QuestionType.number:
      case QuestionType.password:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.tel:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
      case QuestionType.rating:
      case QuestionType.signature:
      case QuestionType.slider:
      case QuestionType.image:
      case QuestionType.otp:
      case QuestionType.range:
      case QuestionType.stepper:
      case QuestionType.captcha:
      case QuestionType.price:
      case QuestionType.age:
      case QuestionType.toggle:
      case QuestionType.search:
      case QuestionType.file:
        return type.name;
      default:
        return type.name;
    }
  }

  static bool _isDefaultValueCompatible(QuestionType type, Object? value) {
    if (value == null) return true;
    if (isChoiceType(type)) {
      return value is String || value is List;
    }
    if (type == QuestionType.number ||
        type == QuestionType.price ||
        type == QuestionType.age) {
      return value is num || num.tryParse(value.toString()) != null;
    }
    return value is String || value is num;
  }
}
