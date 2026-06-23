import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/modules/forms/models/question_type.dart';

class FormQuestion {
  final String id;
  final String label;
  final String fieldType;
  final QuestionType type;
  final String? helpText;
  final String? placeholder;
  final bool isRequired;
  final bool isHidden;
  final bool isReadOnly;
  final bool isRepeatable;
  final bool keepLastValue;
  final int? repeatMin;
  final int? repeatMax;
  final num? minValue;
  final num? maxValue;
  final Map<String, dynamic> validation;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> ui;
  final Map<String, dynamic> style;
  final List<dynamic> options;
  final String? variableName;
  final dynamic value;
  final String? sectionId;
  final int order;

  FormQuestion({
    required this.id,
    required this.label,
    QuestionType? type,
    String? fieldType,
    this.helpText,
    this.placeholder,
    this.isRequired = false,
    this.isHidden = false,
    this.isReadOnly = false,
    this.isRepeatable = false,
    this.keepLastValue = false,
    this.repeatMin,
    this.repeatMax,
    this.minValue,
    this.maxValue,
    this.validation = const {},
    this.metadata = const {},
    this.ui = const {},
    this.style = const {},
    this.options = const [],
    this.variableName,
    this.value,
    this.sectionId,
    this.order = 0,
  }) : type = type ?? _questionTypeFromFieldType(fieldType),
       fieldType = (type ?? _questionTypeFromFieldType(fieldType)).name;

  String get helperText => helpText ?? '';
  String? get validationRegex => validation['regex']?.toString();
  int? get minLength => (validation['min_length'] as num?)?.toInt();
  int? get maxLength => (validation['max_length'] as num?)?.toInt();
  String? get customErrorMessage =>
      validation['custom_error_message']?.toString();
  dynamic get dateMin => validation['date_min'];
  dynamic get dateMax => validation['date_max'];
  dynamic get inputMask => validation['input_mask'];
  List<String> get allowedFileTypes =>
      (metadata['allowedFileTypes'] as List? ?? const [])
          .map((e) => e.toString())
          .toList();
  dynamic get defaultValue =>
      metadata['defaultValue'] ?? metadata['default_value'];
  Map<String, dynamic>? get conditionalLogic =>
      metadata['conditional_logic'] is Map
      ? Map<String, dynamic>.from(metadata['conditional_logic'] as Map)
      : null;
  Map<String, dynamic>? get logic => metadata['logic'] is Map
      ? Map<String, dynamic>.from(metadata['logic'] as Map)
      : null;
  Map<String, dynamic>? get actionConfig => metadata['actionConfig'] is Map
      ? Map<String, dynamic>.from(metadata['actionConfig'] as Map)
      : null;
  QuestionStyle get styleObject => QuestionStyle.fromJson(style);

  static QuestionType _questionTypeFromFieldType(String? fieldType) {
    final name = fieldType?.trim().toLowerCase() ?? 'shorttext';
    final compact = name.replaceAll(RegExp(r'[\s_-]+'), '');
    final aliases = <String, QuestionType>{
      'shorttext': QuestionType.shortText,
      'paragraph': QuestionType.paragraph,
      'multiplechoice': QuestionType.multipleChoice,
      'checkboxes': QuestionType.checkboxes,
      'dropdown': QuestionType.dropdown,
      'select': QuestionType.dropdown,
      'radio': QuestionType.multipleChoice,
      'note': QuestionType.divider,
      'hidden': QuestionType.spacer,
      'boolean': QuestionType.booleanValue,
      'fileupload': QuestionType.fileUpload,
      'multifileupload': QuestionType.multiFileUpload,
      'signaturepad': QuestionType.signaturePad,
      'phonenumber': QuestionType.phoneNumber,
      'mobile': QuestionType.mobile,
      'email': QuestionType.email,
      'date': QuestionType.date,
      'time': QuestionType.time,
      'rating': QuestionType.rating,
      'number': QuestionType.number,
      'url': QuestionType.url,
      'search': QuestionType.search,
      'file': QuestionType.file,
    };
    if (aliases.containsKey(compact)) {
      return aliases[compact]!;
    }
    return QuestionType.values.firstWhere(
      (value) =>
          value.name.toLowerCase() == name ||
          value.toString().toLowerCase().contains(name),
      orElse: () => QuestionType.shortText,
    );
  }

  factory FormQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return FormQuestion(
      id: json['id']?.toString() ?? '',
      label:
          json['label']?.toString() ?? json['question_text']?.toString() ?? '',
      fieldType:
          json['fieldType']?.toString() ??
          json['field_type']?.toString() ??
          json['type']?.toString(),
      helpText: json['help_text']?.toString() ?? json['helpText']?.toString(),
      placeholder: json['placeholder']?.toString(),
      isRequired:
          json['is_required'] as bool? ?? json['required'] as bool? ?? false,
      isHidden: json['is_hidden'] as bool? ?? false,
      isReadOnly: json['is_read_only'] as bool? ?? false,
      isRepeatable: json['is_repeatable'] as bool? ?? false,
      keepLastValue: json['keep_last_value'] as bool? ?? false,
      repeatMin: (json['repeat_min'] as num?)?.toInt(),
      repeatMax: (json['repeat_max'] as num?)?.toInt(),
      minValue: json['minValue'] as num? ?? json['min_value'] as num?,
      maxValue: json['maxValue'] as num? ?? json['max_value'] as num?,
      validation: Map<String, dynamic>.from(
        json['validation'] ?? json['validation_schema'] ?? const {},
      ),
      metadata: Map<String, dynamic>.from(
        json['meta_data'] ?? json['metadata'] ?? const {},
      ),
      ui: Map<String, dynamic>.from(json['ui'] ?? const {}),
      style: Map<String, dynamic>.from(json['style'] ?? const {}),
      options: rawOptions is List ? rawOptions.toList() : const [],
      variableName:
          json['variable_name']?.toString() ?? json['variableName']?.toString(),
      value: json['value'],
      sectionId:
          json['section_id']?.toString() ?? json['sectionId']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fieldType': fieldType,
      'type': type.name,
      'help_text': helpText,
      'placeholder': placeholder,
      'is_required': isRequired,
      'is_hidden': isHidden,
      'is_read_only': isReadOnly,
      'is_repeatable': isRepeatable,
      'keep_last_value': keepLastValue,
      'repeat_min': repeatMin,
      'repeat_max': repeatMax,
      'min_value': minValue,
      'max_value': maxValue,
      'validation': validation,
      'meta_data': metadata,
      'ui': ui,
      'style': style,
      'options': options,
      'variable_name': variableName,
      'value': value,
      'section_id': sectionId,
      'order': order,
    };
  }

  FormQuestion copyWith({
    String? id,
    String? label,
    String? fieldType,
    QuestionType? type,
    String? helpText,
    String? placeholder,
    bool? isRequired,
    bool? isHidden,
    bool? isReadOnly,
    bool? isRepeatable,
    bool? keepLastValue,
    int? repeatMin,
    int? repeatMax,
    num? minValue,
    num? maxValue,
    Map<String, dynamic>? validation,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? ui,
    Map<String, dynamic>? style,
    List<dynamic>? options,
    String? variableName,
    dynamic value,
    String? sectionId,
    int? order,
    Map<String, dynamic>? logic,
    Map<String, dynamic>? conditionalLogic,
    dynamic defaultValue,
  }) {
    return FormQuestion(
      id: id ?? this.id,
      label: label ?? this.label,
      fieldType: fieldType ?? this.fieldType,
      type: type ?? this.type,
      helpText: helpText ?? this.helpText,
      placeholder: placeholder ?? this.placeholder,
      isRequired: isRequired ?? this.isRequired,
      isHidden: isHidden ?? this.isHidden,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      keepLastValue: keepLastValue ?? this.keepLastValue,
      repeatMin: repeatMin ?? this.repeatMin,
      repeatMax: repeatMax ?? this.repeatMax,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      validation: validation ?? this.validation,
      metadata: metadata ?? this.metadata,
      ui: ui ?? this.ui,
      style: style ?? this.style,
      options: options ?? this.options,
      variableName: variableName ?? this.variableName,
      value: value ?? defaultValue ?? this.value,
      sectionId: sectionId ?? this.sectionId,
      order: order ?? this.order,
    );
  }
}

class FormSection {
  final String id;
  final String title;
  final String? description;
  final String? helpText;
  final int order;
  final List<FormQuestion> questions;
  final String layout;
  final int gridColumns;
  final bool isHidden;
  final bool isRepeatable;
  final int? repeatMin;
  final int? repeatMax;
  final Map<String, dynamic>? conditionalLogic;
  final Map<String, dynamic>? logic;
  final List<FormSection> sections;
  final List<Map<String, dynamic>> responseTemplates;
  final List<String> tags;
  final Map<String, dynamic> style;
  final Map<String, dynamic> ui;
  final Map<String, dynamic> metadata;

  const FormSection({
    required this.id,
    required this.title,
    this.description,
    this.helpText,
    this.order = 0,
    this.questions = const [],
    this.layout = 'standard',
    this.gridColumns = 2,
    this.isHidden = false,
    this.isRepeatable = false,
    this.repeatMin,
    this.repeatMax,
    this.conditionalLogic,
    this.logic,
    this.sections = const [],
    this.responseTemplates = const [],
    this.tags = const [],
    this.style = const {},
    this.ui = const {},
    this.metadata = const {},
  });

  Map<String, dynamic> get metaData => metadata;

  factory FormSection.fromJson(Map<String, dynamic> json) {
    final ui = Map<String, dynamic>.from(json['ui'] ?? const {});
    return FormSection(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Section',
      description: json['description']?.toString(),
      helpText: json['help_text']?.toString(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      questions: (json['questions'] as List? ?? const [])
          .map(
            (q) => q is FormQuestion
                ? q
                : FormQuestion.fromJson(Map<String, dynamic>.from(q as Map)),
          )
          .toList(),
      layout:
          json['layout']?.toString() ??
          ui['layout_type']?.toString() ??
          'standard',
      gridColumns: (json['grid_columns'] as num?)?.toInt() ?? 2,
      isHidden: json['is_hidden'] as bool? ?? false,
      isRepeatable: json['is_repeatable'] as bool? ?? false,
      repeatMin: (json['repeat_min'] as num?)?.toInt(),
      repeatMax: (json['repeat_max'] as num?)?.toInt(),
      conditionalLogic: json['conditional_logic'] is Map
          ? Map<String, dynamic>.from(json['conditional_logic'])
          : null,
      logic: json['logic'] is Map
          ? Map<String, dynamic>.from(json['logic'])
          : null,
      sections: (json['sections'] as List? ?? const [])
          .map(
            (s) => s is FormSection
                ? s
                : FormSection.fromJson(Map<String, dynamic>.from(s as Map)),
          )
          .toList(),
      responseTemplates: (json['response_templates'] as List? ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      tags: (json['tags'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      style: Map<String, dynamic>.from(json['style'] ?? const {}),
      ui: ui,
      metadata: Map<String, dynamic>.from(
        json['meta_data'] ?? json['metadata'] ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'help_text': helpText,
    'order': order,
    'questions': questions.map((e) => e.toJson()).toList(),
    'layout': layout,
    'grid_columns': gridColumns,
    'is_hidden': isHidden,
    'is_repeatable': isRepeatable,
    'repeat_min': repeatMin,
    'repeat_max': repeatMax,
    'conditional_logic': conditionalLogic,
    'logic': logic,
    'sections': sections.map((e) => e.toJson()).toList(),
    'response_templates': responseTemplates,
    'tags': tags,
    'style': style,
    'ui': ui,
    'meta_data': metadata,
  };

  FormSection copyWith({
    String? id,
    String? title,
    String? description,
    String? helpText,
    int? order,
    List<FormQuestion>? questions,
    String? layout,
    int? gridColumns,
    bool? isHidden,
    bool? isRepeatable,
    int? repeatMin,
    int? repeatMax,
    Map<String, dynamic>? conditionalLogic,
    Map<String, dynamic>? logic,
    List<FormSection>? sections,
    List<Map<String, dynamic>>? responseTemplates,
    List<String>? tags,
    Map<String, dynamic>? style,
    Map<String, dynamic>? ui,
    Map<String, dynamic>? metadata,
  }) {
    return FormSection(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      helpText: helpText ?? this.helpText,
      order: order ?? this.order,
      questions: questions ?? this.questions,
      layout: layout ?? this.layout,
      gridColumns: gridColumns ?? this.gridColumns,
      isHidden: isHidden ?? this.isHidden,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeatMin: repeatMin ?? this.repeatMin,
      repeatMax: repeatMax ?? this.repeatMax,
      conditionalLogic: conditionalLogic ?? this.conditionalLogic,
      logic: logic ?? this.logic,
      sections: sections ?? this.sections,
      responseTemplates: responseTemplates ?? this.responseTemplates,
      tags: tags ?? this.tags,
      style: style ?? this.style,
      ui: ui ?? this.ui,
      metadata: metadata ?? this.metadata,
    );
  }
}

class FormVersion {
  final String? id;
  final String version;
  final List<FormSection> sections;
  final DateTime? createdAt;
  final String? changeLog;

  const FormVersion({
    this.id,
    required this.version,
    this.sections = const [],
    this.createdAt,
    this.changeLog,
  });

  factory FormVersion.fromJson(Map<String, dynamic> json) {
    return FormVersion(
      id: json['id']?.toString(),
      version: json['version']?.toString() ?? '1.0',
      sections: (json['sections'] as List? ?? const [])
          .map(
            (s) => s is FormSection
                ? s
                : FormSection.fromJson(Map<String, dynamic>.from(s as Map)),
          )
          .toList(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      changeLog:
          json['changeLog']?.toString() ?? json['change_log']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'sections': sections.map((e) => e.toJson()).toList(),
    'created_at': createdAt?.toIso8601String(),
    'changeLog': changeLog,
  };

  FormVersion copyWith({
    String? id,
    String? version,
    List<FormSection>? sections,
    DateTime? createdAt,
    String? changeLog,
  }) {
    return FormVersion(
      id: id ?? this.id,
      version: version ?? this.version,
      sections: sections ?? this.sections,
      createdAt: createdAt ?? this.createdAt,
      changeLog: changeLog ?? this.changeLog,
    );
  }
}

class Form {
  final String id;
  final String title;
  final String status;
  final String slug;
  final String? description;
  final String? organizationId;
  final String? createdBy;
  final String version;
  final String? activeVersion;
  final bool isPublished;
  final bool isLatest;
  final bool isPublic;
  final String uiType;
  final String layout;
  final Map<String, dynamic> style;
  final Map<String, dynamic> workflows;
  final Map<String, dynamic> accessPolicy;
  final Map<String, dynamic> submissionSettings;
  final List<Map<String, dynamic>> quickResponses;
  final Map<String, dynamic> dataExportSettings;
  final Map<String, dynamic> advancedSettings;
  final Map<String, dynamic> metadata;
  final List<FormSection> sections;
  final List<FormVersion> versions;
  final DateTime? updatedAt;

  const Form({
    required this.id,
    required this.title,
    this.status = 'draft',
    this.slug = '',
    this.description,
    this.organizationId,
    this.createdBy,
    this.version = '1.0',
    this.activeVersion,
    this.isPublished = false,
    this.isLatest = true,
    this.isPublic = false,
    this.uiType = 'flex',
    this.layout = 'flex',
    this.style = const {},
    this.workflows = const {},
    this.accessPolicy = const {},
    this.submissionSettings = const {},
    this.quickResponses = const [],
    this.dataExportSettings = const {},
    this.advancedSettings = const {},
    this.metadata = const {},
    this.sections = const [],
    this.versions = const [],
    this.updatedAt,
  });

  String get layoutType => uiType;

  factory Form.fromJson(Map<String, dynamic> json) {
    final sections = (json['sections'] as List? ?? const [])
        .map(
          (section) => section is FormSection
              ? section
              : FormSection.fromJson(Map<String, dynamic>.from(section as Map)),
        )
        .toList();
    final versions = (json['versions'] as List? ?? const [])
        .map(
          (item) => item is FormVersion
              ? item
              : FormVersion.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    List<Map<String, dynamic>> parseQuickResponses(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return Form(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Form',
      status: json['status']?.toString() ?? 'draft',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      organizationId: json['organization_id']?.toString(),
      createdBy: json['created_by']?.toString(),
      version:
          json['version']?.toString() ??
          json['active_version']?.toString() ??
          '1.0',
      activeVersion: json['active_version']?.toString(),
      isPublished: json['is_published'] as bool? ?? false,
      isLatest: json['is_latest'] as bool? ?? true,
      isPublic: json['is_public'] as bool? ?? false,
      uiType: json['ui_type']?.toString() ?? 'flex',
      layout: json['ui_type']?.toString() ?? 'flex',
      style: Map<String, dynamic>.from(json['style'] ?? const {}),
      workflows: Map<String, dynamic>.from(json['workflows'] ?? const {}),
      accessPolicy: Map<String, dynamic>.from(
        json['access_policy'] ?? const {},
      ),
      submissionSettings: Map<String, dynamic>.from(
        json['submission_settings'] ?? const {},
      ),
      quickResponses: parseQuickResponses(json['quick_responses'] ?? const []),
      dataExportSettings: Map<String, dynamic>.from(
        json['data_export_settings'] ?? const {},
      ),
      advancedSettings: Map<String, dynamic>.from(
        json['advanced_settings'] ?? const {},
      ),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? const {}),
      sections: sections,
      versions: versions,
      updatedAt: DateTime.tryParse(
        json['updatedAt']?.toString() ?? json['updated_at']?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'status': status,
    'slug': slug,
    'description': description,
    'organization_id': organizationId,
    'created_by': createdBy,
    'version': version,
    'active_version': activeVersion,
    'is_published': isPublished,
    'is_latest': isLatest,
    'is_public': isPublic,
    'ui_type': uiType,
    'layout': layout,
    'style': style,
    'workflows': workflows,
    'access_policy': accessPolicy,
    'submission_settings': submissionSettings,
    'quick_responses': quickResponses,
    'data_export_settings': dataExportSettings,
    'advanced_settings': advancedSettings,
    'metadata': metadata,
    'sections': sections.map((e) => e.toJson()).toList(),
    'versions': versions.map((e) => e.toJson()).toList(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  Form copyWith({
    String? id,
    String? title,
    String? status,
    String? slug,
    String? description,
    String? organizationId,
    String? createdBy,
    String? version,
    String? activeVersion,
    bool? isPublished,
    bool? isLatest,
    bool? isPublic,
    String? uiType,
    String? layoutType,
    String? layout,
    Map<String, dynamic>? style,
    Map<String, dynamic>? workflows,
    Map<String, dynamic>? accessPolicy,
    Map<String, dynamic>? submissionSettings,
    List<Map<String, dynamic>>? quickResponses,
    Map<String, dynamic>? dataExportSettings,
    Map<String, dynamic>? advancedSettings,
    Map<String, dynamic>? metadata,
    List<FormSection>? sections,
    List<FormVersion>? versions,
    DateTime? updatedAt,
  }) {
    return Form(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      organizationId: organizationId ?? this.organizationId,
      createdBy: createdBy ?? this.createdBy,
      version: version ?? this.version,
      activeVersion: activeVersion ?? this.activeVersion,
      isPublished: isPublished ?? this.isPublished,
      isLatest: isLatest ?? this.isLatest,
      isPublic: isPublic ?? this.isPublic,
      uiType: uiType ?? layoutType ?? this.uiType,
      layout: layout ?? layoutType ?? this.layout,
      style: style ?? this.style,
      workflows: workflows ?? this.workflows,
      accessPolicy: accessPolicy ?? this.accessPolicy,
      submissionSettings: submissionSettings ?? this.submissionSettings,
      quickResponses: quickResponses ?? this.quickResponses,
      dataExportSettings: dataExportSettings ?? this.dataExportSettings,
      advancedSettings: advancedSettings ?? this.advancedSettings,
      metadata: metadata ?? this.metadata,
      sections: sections ?? this.sections,
      versions: versions ?? this.versions,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

typedef BuilderForm = Form;
typedef Question = FormQuestion;

extension FormStyleMapX on Map<String, dynamic> {
  String get backgroundColor =>
      this['backgroundColor']?.toString() ?? '#FFFFFF';
  String get primaryColor => this['primaryColor']?.toString() ?? '#1976D2';
  String get layoutType => this['layoutType']?.toString() ?? 'singleColumn';
  double get maxWidth => (this['maxWidth'] as num?)?.toDouble() ?? 1200.0;
  double get sectionSpacing =>
      (this['sectionSpacing'] as num?)?.toDouble() ?? 16.0;
  double get questionSpacing =>
      (this['questionSpacing'] as num?)?.toDouble() ?? 12.0;
  double get globalBorderRadius =>
      (this['globalBorderRadius'] as num?)?.toDouble() ?? 8.0;
  String get titleColor => this['titleColor']?.toString() ?? '#212121';
  String get descriptionColor =>
      this['descriptionColor']?.toString() ?? '#757575';
  double get borderRadius => (this['borderRadius'] as num?)?.toDouble() ?? 4.0;
  String get borderColor => this['borderColor']?.toString() ?? '#E0E0E0';
  double get borderWidth => (this['borderWidth'] as num?)?.toDouble() ?? 1.0;
  double get padding => (this['padding'] as num?)?.toDouble() ?? 8.0;
  double get height => (this['height'] as num?)?.toDouble() ?? 40.0;
  String get widthMode => this['widthMode']?.toString() ?? 'auto';
  double get fixedWidth => (this['fixedWidth'] as num?)?.toDouble() ?? 200.0;
  String get labelColor => this['labelColor']?.toString() ?? '#212121';
  String get helperColor => this['helperColor']?.toString() ?? '#757575';
  double get labelFontSize =>
      (this['labelFontSize'] as num?)?.toDouble() ?? 14.0;
  String get labelFontWeight => this['labelFontWeight']?.toString() ?? 'normal';
  double get helperFontSize =>
      (this['helperFontSize'] as num?)?.toDouble() ?? 12.0;
  String get helperFontWeight =>
      this['helperFontWeight']?.toString() ?? 'normal';
  String get inputFontColor => this['inputFontColor']?.toString() ?? '#212121';
  double get inputFontSize =>
      (this['inputFontSize'] as num?)?.toDouble() ?? 14.0;
  String get inputFontWeight => this['inputFontWeight']?.toString() ?? 'normal';
  String get inputStyle => this['inputStyle']?.toString() ?? 'filled';
  String get focusColor => this['focusColor']?.toString() ?? '#1976D2';
  String get errorColor => this['errorColor']?.toString() ?? '#D32F2F';
  double get verticalMargin =>
      (this['verticalMargin'] as num?)?.toDouble() ?? 8.0;
  double get containerPadding =>
      (this['containerPadding'] as num?)?.toDouble() ?? 16.0;
  String get labelPosition => this['labelPosition']?.toString() ?? 'top';
  double get labelColumnWidth =>
      (this['labelColumnWidth'] as num?)?.toDouble() ?? 150.0;
  String get prefixIcon => this['prefixIcon']?.toString() ?? '';
  String get suffixIcon => this['suffixIcon']?.toString() ?? '';
  Map<String, dynamic> copyWith({
    String? backgroundColor,
    String? primaryColor,
    String? layoutType,
    double? maxWidth,
    double? sectionSpacing,
    double? questionSpacing,
    double? globalBorderRadius,
    String? titleColor,
    String? descriptionColor,
    double? borderRadius,
    String? borderColor,
    double? borderWidth,
    double? padding,
    double? height,
    String? widthMode,
    double? fixedWidth,
    String? labelColor,
    String? helperColor,
    double? labelFontSize,
    String? labelFontWeight,
    double? helperFontSize,
    String? helperFontWeight,
    String? inputFontColor,
    double? inputFontSize,
    String? inputFontWeight,
    String? inputStyle,
    String? focusColor,
    String? errorColor,
    double? verticalMargin,
    double? containerPadding,
    String? labelPosition,
    double? labelColumnWidth,
    String? prefixIcon,
    String? suffixIcon,
  }) {
    return {
      ...this,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (primaryColor != null) 'primaryColor': primaryColor,
      if (layoutType != null) 'layoutType': layoutType,
      if (maxWidth != null) 'maxWidth': maxWidth,
      if (sectionSpacing != null) 'sectionSpacing': sectionSpacing,
      if (questionSpacing != null) 'questionSpacing': questionSpacing,
      if (globalBorderRadius != null) 'globalBorderRadius': globalBorderRadius,
      if (titleColor != null) 'titleColor': titleColor,
      if (descriptionColor != null) 'descriptionColor': descriptionColor,
      if (borderRadius != null) 'borderRadius': borderRadius,
      if (borderColor != null) 'borderColor': borderColor,
      if (borderWidth != null) 'borderWidth': borderWidth,
      if (padding != null) 'padding': padding,
      if (height != null) 'height': height,
      if (widthMode != null) 'widthMode': widthMode,
      if (fixedWidth != null) 'fixedWidth': fixedWidth,
      if (labelColor != null) 'labelColor': labelColor,
      if (helperColor != null) 'helperColor': helperColor,
      if (labelFontSize != null) 'labelFontSize': labelFontSize,
      if (labelFontWeight != null) 'labelFontWeight': labelFontWeight,
      if (helperFontSize != null) 'helperFontSize': helperFontSize,
      if (helperFontWeight != null) 'helperFontWeight': helperFontWeight,
      if (inputFontColor != null) 'inputFontColor': inputFontColor,
      if (inputFontSize != null) 'inputFontSize': inputFontSize,
      if (inputFontWeight != null) 'inputFontWeight': inputFontWeight,
      if (inputStyle != null) 'inputStyle': inputStyle,
      if (focusColor != null) 'focusColor': focusColor,
      if (errorColor != null) 'errorColor': errorColor,
      if (verticalMargin != null) 'verticalMargin': verticalMargin,
      if (containerPadding != null) 'containerPadding': containerPadding,
      if (labelPosition != null) 'labelPosition': labelPosition,
      if (labelColumnWidth != null) 'labelColumnWidth': labelColumnWidth,
      if (prefixIcon != null) 'prefixIcon': prefixIcon,
      if (suffixIcon != null) 'suffixIcon': suffixIcon,
    };
  }
}
