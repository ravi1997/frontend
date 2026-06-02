import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/domain/entities/form_layout_type.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';

/// =========================================================================
/// 1. MASTER QUESTION MODEL
/// =========================================================================
class Question {
  final String id;
  final String? variableName;
  final String label;
  final String fieldType;
  final String? helpText;
  final dynamic defaultValue;
  final bool isReadOnly;
  final bool isHidden;
  final bool isRepeatable;
  final int? repeatMin;
  final int? repeatMax;
  final bool keepLastValue;
  
  // UI, Validation & Logic configurations
  final Map<String, dynamic> validation;
  final Map<String, dynamic> logic;
  final Map<String, dynamic> ui;
  
  // Choices / Nested structures
  final List<Map<String, dynamic>> options;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  const Question({
    required this.id,
    this.variableName,
    required this.label,
    required this.fieldType,
    this.helpText,
    this.defaultValue,
    this.isReadOnly = false,
    this.isHidden = false,
    this.isRepeatable = false,
    this.repeatMin,
    this.repeatMax,
    this.keepLastValue = false,
    this.validation = const <String, dynamic>{},
    this.logic = const <String, dynamic>{},
    this.ui = const <String, dynamic>{},
    this.options = const <Map<String, dynamic>>[],
    this.tags = const <String>[],
    this.metadata = const <String, dynamic>{},
  });

  Question copyWith({
    String? id,
    String? variableName,
    String? label,
    String? fieldType,
    String? helpText,
    dynamic defaultValue,
    bool? isReadOnly,
    bool? isHidden,
    bool? isRepeatable,
    int? repeatMin,
    int? repeatMax,
    bool? keepLastValue,
    Map<String, dynamic>? validation,
    Map<String, dynamic>? logic,
    Map<String, dynamic>? ui,
    List<Map<String, dynamic>>? options,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return Question(
      id: id ?? this.id,
      variableName: variableName ?? this.variableName,
      label: label ?? this.label,
      fieldType: fieldType ?? this.fieldType,
      helpText: helpText ?? this.helpText,
      defaultValue: defaultValue ?? this.defaultValue,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      isHidden: isHidden ?? this.isHidden,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeatMin: repeatMin ?? this.repeatMin,
      repeatMax: repeatMax ?? this.repeatMax,
      keepLastValue: keepLastValue ?? this.keepLastValue,
      validation: validation ?? this.validation,
      logic: logic ?? this.logic,
      ui: ui ?? this.ui,
      options: options ?? this.options,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      variableName: json['variable_name'] as String?,
      label: json['label'] as String,
      fieldType: json['field_type'] as String,
      helpText: json['help_text'] as String?,
      defaultValue: json['default_value'],
      isReadOnly: json['is_read_only'] ?? false,
      isHidden: json['is_hidden'] ?? false,
      isRepeatable: json['is_repeatable'] ?? false,
      repeatMin: json['repeat_min'] as int?,
      repeatMax: json['repeat_max'] as int?,
      keepLastValue: json['keep_last_value'] ?? false,
      validation: Map<String, dynamic>.from(json['validation'] ?? {}),
      logic: Map<String, dynamic>.from(json['logic'] ?? {}),
      ui: Map<String, dynamic>.from(json['ui'] ?? {}),
      options: List<Map<String, dynamic>>.from(json['options'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['meta_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variable_name': variableName,
      'label': label,
      'field_type': fieldType,
      'help_text': helpText,
      'default_value': defaultValue,
      'is_read_only': isReadOnly,
      'is_hidden': isHidden,
      'is_repeatable': isRepeatable,
      'repeat_min': repeatMin,
      'repeat_max': repeatMax,
      'keep_last_value': keepLastValue,
      'validation': validation,
      'logic': logic,
      'ui': ui,
      'options': options,
      'tags': tags,
      'meta_data': metadata,
    };
  }

  /// --- TRANSIENT JSON SCHEMAS ---
  
  /// Transient schema for a filled submission answer
  Map<String, dynamic> toAnswerJson(dynamic userValue) {
    return {
      'question_id': id,
      'variable_name': variableName ?? id,
      'value': userValue,
      'submitted_at': DateTime.now().toUtc().toIso8601String(),
    };
  }
}

/// =========================================================================
/// 2. MASTER SECTION MODEL
/// =========================================================================
class Section {
  final String id;
  final String title;
  final String? description;
  final String? helpText;
  final int order;
  final List<Question> questions;
  final List<Section> sections; // Nested sub-sections
  final String layout;
  final int gridColumns;
  final bool isHidden;
  final bool isRepeatable;
  final int? repeatMin;
  final int? repeatMax;
  final Map<String, dynamic> logic;
  final Map<String, dynamic> ui;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  const Section({
    required this.id,
    required this.title,
    this.description,
    this.helpText,
    this.order = 0,
    this.questions = const <Question>[],
    this.sections = const <Section>[],
    this.layout = 'standard',
    this.gridColumns = 2,
    this.isHidden = false,
    this.isRepeatable = false,
    this.repeatMin,
    this.repeatMax,
    this.logic = const <String, dynamic>{},
    this.ui = const <String, dynamic>{},
    this.tags = const <String>[],
    this.metadata = const <String, dynamic>{},
  });

  Section copyWith({
    String? id,
    String? title,
    String? description,
    String? helpText,
    int? order,
    List<Question>? questions,
    List<Section>? sections,
    String? layout,
    int? gridColumns,
    bool? isHidden,
    bool? isRepeatable,
    int? repeatMin,
    int? repeatMax,
    Map<String, dynamic>? logic,
    Map<String, dynamic>? ui,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return Section(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      helpText: helpText ?? this.helpText,
      order: order ?? this.order,
      questions: questions ?? this.questions,
      sections: sections ?? this.sections,
      layout: layout ?? this.layout,
      gridColumns: gridColumns ?? this.gridColumns,
      isHidden: isHidden ?? this.isHidden,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      repeatMin: repeatMin ?? this.repeatMin,
      repeatMax: repeatMax ?? this.repeatMax,
      logic: logic ?? this.logic,
      ui: ui ?? this.ui,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      helpText: json['help_text'] as String?,
      order: json['order'] as int? ?? 0,
      questions: (json['questions'] as List?)
          ?.map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <Question>[],
      sections: (json['sections'] as List?)
          ?.map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <Section>[],
      layout: json['layout'] as String? ?? 'standard',
      gridColumns: json['grid_columns'] as int? ?? 2,
      isHidden: json['is_hidden'] ?? false,
      isRepeatable: json['is_repeatable'] ?? false,
      repeatMin: json['repeat_min'] as int?,
      repeatMax: json['repeat_max'] as int?,
      logic: Map<String, dynamic>.from(json['logic'] ?? {}),
      ui: Map<String, dynamic>.from(json['ui'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['meta_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'help_text': helpText,
      'order': order,
      'questions': questions.map((e) => e.toJson()).toList(),
      'sections': sections.map((e) => e.toJson()).toList(),
      'layout': layout,
      'grid_columns': gridColumns,
      'is_hidden': isHidden,
      'is_repeatable': isRepeatable,
      'repeat_min': repeatMin,
      'repeat_max': repeatMax,
      'logic': logic,
      'ui': ui,
      'tags': tags,
      'meta_data': metadata,
    };
  }
}

/// =========================================================================
/// 3. MASTER FORM VERSION MODEL
/// =========================================================================
class FormVersion {
  final String id;
  final String version;
  final List<Section> sections;
  final String status;
  final Map<String, dynamic> translations;
  final String? createdAt;

  const FormVersion({
    required this.id,
    required this.version,
    this.sections = const <Section>[],
    this.status = 'draft',
    this.translations = const <String, dynamic>{},
    this.createdAt,
  });

  FormVersion copyWith({
    String? id,
    String? version,
    List<Section>? sections,
    String? status,
    Map<String, dynamic>? translations,
    String? createdAt,
  }) {
    return FormVersion(
      id: id ?? this.id,
      version: version ?? this.version,
      sections: sections ?? this.sections,
      status: status ?? this.status,
      translations: translations ?? this.translations,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FormVersion.fromJson(Map<String, dynamic> json) {
    return FormVersion(
      id: json['id'] as String,
      version: json['version'] as String,
      sections: (json['sections'] as List?)
          ?.map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <Section>[],
      status: json['status'] as String? ?? 'draft',
      translations: Map<String, dynamic>.from(json['translations'] ?? {}),
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'sections': sections.map((e) => e.toJson()).toList(),
      'status': status,
      'translations': translations,
      'created_at': createdAt,
    };
  }
}

/// =========================================================================
/// 4. MASTER FORM MODEL
/// =========================================================================
class Form {
  final String id;
  final String title;
  final String slug;
  final String organizationId;
  final String createdBy;
  final String status;
  final String uiType;
  final String? activeVersion;
  final List<FormVersion> versions;
  
  // Configurations
  final String? description;
  final String? helpText;
  final String? expiresAt;
  final String? publishAt;
  final bool isTemplate;
  final bool isPublic;
  final List<String> supportedLanguages;
  final String defaultLanguage;
  final List<String> tags;
  
  // Integrations & Policies
  final Map<String, dynamic> workflows;
  final Map<String, dynamic> accessPolicy;
  final Map<String, dynamic> style;

  const Form({
    required this.id,
    required this.title,
    required this.slug,
    required this.organizationId,
    required this.createdBy,
    this.status = 'draft',
    this.uiType = 'flex',
    this.activeVersion,
    this.versions = const <FormVersion>[],
    this.description,
    this.helpText,
    this.expiresAt,
    this.publishAt,
    this.isTemplate = false,
    this.isPublic = false,
    this.supportedLanguages = const ['en'],
    this.defaultLanguage = 'en',
    this.tags = const <String>[],
    this.workflows = const <String, dynamic>{},
    this.accessPolicy = const <String, dynamic>{},
    this.style = const <String, dynamic>{},
  });

  Form copyWith({
    String? id,
    String? title,
    String? slug,
    String? organizationId,
    String? createdBy,
    String? status,
    String? uiType,
    String? activeVersion,
    List<FormVersion>? versions,
    String? description,
    String? helpText,
    String? expiresAt,
    String? publishAt,
    bool? isTemplate,
    bool? isPublic,
    List<String>? supportedLanguages,
    String? defaultLanguage,
    List<String>? tags,
    Map<String, dynamic>? workflows,
    Map<String, dynamic>? accessPolicy,
    Map<String, dynamic>? style,
  }) {
    return Form(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      organizationId: organizationId ?? this.organizationId,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      uiType: uiType ?? this.uiType,
      activeVersion: activeVersion ?? this.activeVersion,
      versions: versions ?? this.versions,
      description: description ?? this.description,
      helpText: helpText ?? this.helpText,
      expiresAt: expiresAt ?? this.expiresAt,
      publishAt: publishAt ?? this.publishAt,
      isTemplate: isTemplate ?? this.isTemplate,
      isPublic: isPublic ?? this.isPublic,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      tags: tags ?? this.tags,
      workflows: workflows ?? this.workflows,
      accessPolicy: accessPolicy ?? this.accessPolicy,
      style: style ?? this.style,
    );
  }

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      organizationId: json['organization_id'] as String,
      createdBy: json['created_by'] as String,
      status: json['status'] as String? ?? 'draft',
      uiType: json['ui_type'] as String? ?? 'flex',
      activeVersion: json['active_version'] as String?,
      versions: (json['versions'] as List?)
          ?.map((e) => FormVersion.fromJson(Map<String, dynamic>.from(e)))
          .toList() ?? <FormVersion>[],
      description: json['description'] as String?,
      helpText: json['help_text'] as String?,
      expiresAt: json['expires_at'] as String?,
      publishAt: json['publish_at'] as String?,
      isTemplate: json['is_template'] ?? false,
      isPublic: json['is_public'] ?? false,
      supportedLanguages: List<String>.from(json['supported_languages'] ?? ['en']),
      defaultLanguage: json['default_language'] as String? ?? 'en',
      tags: List<String>.from(json['tags'] ?? []),
      workflows: Map<String, dynamic>.from(json['workflows'] ?? {}),
      accessPolicy: Map<String, dynamic>.from(json['access_policy'] ?? {}),
      style: Map<String, dynamic>.from(json['style'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'organization_id': organizationId,
      'created_by': createdBy,
      'status': status,
      'ui_type': uiType,
      'active_version': activeVersion,
      'versions': versions.map((e) => e.toJson()).toList(),
      'description': description,
      'help_text': helpText,
      'expires_at': expiresAt,
      'publish_at': publishAt,
      'is_template': isTemplate,
      'is_public': isPublic,
      'supported_languages': supportedLanguages,
      'default_language': defaultLanguage,
      'tags': tags,
      'workflows': workflows,
      'access_policy': accessPolicy,
      'style': style,
    };
  }

  /// --- TRANSIENT JSON SCHEMAS ---

  /// Transient API payload schema to create a new form
  Map<String, dynamic> toCreateApiJson() {
    return {
      'title': title,
      'slug': slug,
      'organization_id': organizationId,
      'created_by': createdBy,
      'status': 'draft',
      'ui_type': uiType,
      'supported_languages': supportedLanguages,
      'default_language': defaultLanguage,
    };
  }

  /// Transient API payload schema for an incremental update (patch)
  Map<String, dynamic> toUpdateApiJson({List<String>? fieldsToUpdate}) {
    final Map<String, dynamic> fullMap = toJson();
    if (fieldsToUpdate == null || fieldsToUpdate.isEmpty) {
      return fullMap;
    }
    // Filter to only include specified keys for delta patch transactions
    return Map.fromEntries(
      fullMap.entries.where((entry) => fieldsToUpdate.contains(entry.key)),
    );
  }

  /// Transient submission schema containing user responses mapped to keys
  Map<String, dynamic> toSubmissionApiJson({
    required String responderId,
    required Map<String, dynamic> answers,
  }) {
    return {
      'form_id': id,
      'responder_id': responderId,
      'version': activeVersion ?? '1.0.0',
      'submitted_at': DateTime.now().toUtc().toIso8601String(),
      'responses': answers,
    };
  }
}

typedef BuilderForm = Form;
typedef FormQuestion = Question;
typedef FormSection = Section;

extension QuestionLogicCompatibility on Question {
  dynamic get conditionalLogic => logic['conditional_logic'] ?? logic['conditionalLogic'];
  bool get isRequired => validation['is_required'] == true;

  // Back-compat shims: older UI code expects these fields.
  dynamic get helperText => helpText ?? metadata['helper_text'] ?? '';
  dynamic get placeholder => metadata['placeholder'] ?? '';
  String? get inputMask => metadata['inputMask']?.toString();

  // Common numeric constraints live in metadata for slider/range-like fields.
  num? get minValue {
    final val = metadata['min'] ?? validation['min'];
    if (val is num) return val;
    if (val is String) return num.tryParse(val);
    return null;
  }

  num? get maxValue {
    final val = metadata['max'] ?? validation['max'];
    if (val is num) return val;
    if (val is String) return num.tryParse(val);
    return null;
  }

  // Date constraints are stored in validation/metadata depending on flow.
  DateTime? get dateMin {
    final raw = validation['min_date'] ?? metadata['min_date'];
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  DateTime? get dateMax {
    final raw = validation['max_date'] ?? metadata['max_date'];
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  Map<String, dynamic> get actionConfig {
    final raw = logic['action_config'] ?? logic['actionConfig'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const <String, dynamic>{};
  }

  String? get validationRegex =>
      (validation['regex'] ?? validation['pattern'] ?? metadata['regex'])
          ?.toString();

  int? get minLength {
    final val = validation['min_length'] ?? validation['minLength'];
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  int? get maxLength {
    final val = validation['max_length'] ?? validation['maxLength'];
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  String? get customErrorMessage =>
      (validation['error_message'] ?? validation['customErrorMessage'])
          ?.toString();

  List<String> get allowedFileTypes {
    final raw = metadata['allowedFileTypes'] ?? metadata['allowed_file_types'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const <String>[];
  }

  // Style is stored under `ui.style` as a JSON map.
  QuestionStyle get style {
    final raw = ui['style'];
    if (raw is Map) {
      try {
        return QuestionStyle.fromJson(Map<String, dynamic>.from(raw));
      } catch (_) {
        return const QuestionStyle();
      }
    }
    return const QuestionStyle();
  }

  QuestionType get type {
    try {
      return QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == fieldType || 
               fieldType == 'input' && e == QuestionType.shortText ||
               fieldType == 'textarea' && e == QuestionType.paragraph ||
               fieldType == 'select' && e == QuestionType.dropdown ||
               fieldType == 'radio' && e == QuestionType.multipleChoice ||
               fieldType == 'file_upload' && e == QuestionType.fileUpload ||
               fieldType == 'multi-file-upload' && e == QuestionType.multiFileUpload ||
               fieldType == 'file_picker' && e == QuestionType.filePicker ||
               fieldType == 'file_list' && e == QuestionType.fileList ||
               fieldType == 'signature_pad' && e == QuestionType.signaturePad ||
               fieldType == 'image_gallery' && e == QuestionType.imageGallery ||
               fieldType == 'note' && e == QuestionType.divider ||
               fieldType == 'hidden' && e == QuestionType.spacer ||
               fieldType == 'matrix_choice' && e == QuestionType.matrixChoice ||
               fieldType == 'map_location' && e == QuestionType.mapLocation ||
               fieldType == 'address_lookup' && e == QuestionType.addressLookup ||
               fieldType == 'rich_text' && e == QuestionType.richText ||
               fieldType == 'markdown_editor' && e == QuestionType.markdownEditor ||
               fieldType == 'boolean' && e == QuestionType.booleanValue ||
               fieldType == 'multi_select' && e == QuestionType.multiSelect ||
               fieldType == 'custom_field' && e == QuestionType.customField ||
               fieldType == 'color_picker' && e == QuestionType.colorPicker ||
               fieldType == 'date_range' && e == QuestionType.dateRange ||
               fieldType == 'time_range' && e == QuestionType.timeRange ||
               fieldType == 'country_select' && e == QuestionType.countrySelect ||
               fieldType == 'state_select' && e == QuestionType.stateSelect ||
               fieldType == 'city_select' && e == QuestionType.citySelect ||
               fieldType == 'social_media_handle' && e == QuestionType.socialMediaHandle ||
               fieldType == 'website_url' && e == QuestionType.websiteUrl ||
               fieldType == 'phone_number' && e == QuestionType.phoneNumber ||
               fieldType == 'unit_select' && e == QuestionType.unitSelect ||
               fieldType == 'multi_checkbox' && e == QuestionType.multiCheckbox ||
               fieldType == 'email_list' && e == QuestionType.emailList ||
               fieldType == 'qr_code_scan' && e == QuestionType.qrCodeScan,
        orElse: () => QuestionType.shortText,
      );
    } catch (_) {
      return QuestionType.shortText;
    }
  }
}

extension SectionLogicCompatibility on Section {
  dynamic get conditionalLogic => logic['conditional_logic'] ?? logic['conditionalLogic'];

  // Back-compat alias used by older widgets.
  Map<String, dynamic> get metaData => metadata;

  SectionStyle get style {
    final raw = ui['style'];
    if (raw is Map) {
      try {
        return SectionStyle.fromJson(Map<String, dynamic>.from(raw));
      } catch (_) {
        return const SectionStyle();
      }
    }
    return const SectionStyle();
  }
}

extension FormSectionsCompatibility on Form {
  String get version => activeVersion ?? '1.0.0';

  Map<String, dynamic> get metadata => const <String, dynamic>{};

  // Convenience: parse `style` map into typed style for new code.
  FormStyle get formStyle {
    try {
      return FormStyle.fromJson(style);
    } catch (_) {
      return const FormStyle();
    }
  }

  FormLayoutType get layout {
    switch (uiType) {
      case 'grid-cols-2':
      case 'twoColumns':
      case 'FormLayoutType.twoColumns':
        return FormLayoutType.twoColumns;
      case 'grid-cols-3':
      case 'threeColumns':
      case 'FormLayoutType.threeColumns':
        return FormLayoutType.threeColumns;
      case 'flex':
      case 'singleColumn':
      case 'FormLayoutType.singleColumn':
      default:
        return FormLayoutType.singleColumn;
    }
  }

  DateTime? get updatedAt {
    if (versions.isEmpty) return null;
    final active = activeVersion;
    final activeVer = versions.firstWhere(
      (v) => v.version == active,
      orElse: () => versions.first,
    );
    final dateStr = activeVer.createdAt;
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  List<Section> get sections {
    if (versions.isEmpty) return const [];
    final active = activeVersion;
    if (active == null) return versions.first.sections;
    final activeVer = versions.firstWhere((v) => v.version == active, orElse: () => versions.first);
    return activeVer.sections;
  }
}

// Back-compat: allow `form.style.sectionSpacing` style access even though
// `Form.style` is stored as a JSON map.
extension FormStyleMapGetters on Map<String, dynamic> {
  FormStyle get _typed {
    try {
      return FormStyle.fromJson(this);
    } catch (_) {
      return const FormStyle();
    }
  }
  String get backgroundColor => _typed.backgroundColor;
  String get fontFamily => _typed.fontFamily;
  String get primaryColor => _typed.primaryColor;
  double get globalBorderRadius => _typed.globalBorderRadius;
  double get sectionSpacing => _typed.sectionSpacing;
  double get questionSpacing => _typed.questionSpacing;
  double get maxWidth => _typed.maxWidth;
  String get layoutType => _typed.layoutType;
}

// Back-compat: option maps used in `Question.options`.
extension OptionMapGetters on Map<String, dynamic> {
  String get value => (this['option_value'] ?? this['value'] ?? '').toString();
  String get label => (this['option_label'] ?? this['label'] ?? value).toString();
  String get description =>
      (this['description'] ?? this['option_description'] ?? '').toString();
}

// Some legacy UI code treats option entries as `Object` (due to dynamic typing).
// Provide tolerant getters so `opt.value`/`opt.label` keep working.
extension DynamicOptionGetters on Object {
  String get value =>
      this is Map ? Map<String, dynamic>.from(this as Map).value : toString();
  String get label =>
      this is Map ? Map<String, dynamic>.from(this as Map).label : toString();
  String get description =>
      this is Map ? Map<String, dynamic>.from(this as Map).description : '';
}