import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/domain/entities/form_layout_type.dart';
import 'package:frontend/features/form_builder/domain/entities/form_style.dart';

part 'form_models.freezed.dart';
part 'form_models.g.dart';

/// =========================================================================
/// 1. MASTER QUESTION MODEL
/// =========================================================================
@freezed
abstract class Question with _$Question {
  const Question._();

  const factory Question({
    required String id,
    @JsonKey(name: 'variable_name') String? variableName,
    required String label,
    @JsonKey(name: 'field_type') required String fieldType,
    @JsonKey(name: 'help_text') String? helpText,
    @JsonKey(name: 'default_value') dynamic defaultValue,
    @Default(false) @JsonKey(name: 'is_read_only') bool isReadOnly,
    @Default(false) @JsonKey(name: 'is_hidden') bool isHidden,
    @Default(false) @JsonKey(name: 'is_repeatable') bool isRepeatable,
    @JsonKey(name: 'repeat_min') int? repeatMin,
    @JsonKey(name: 'repeat_max') int? repeatMax,
    @Default(false) @JsonKey(name: 'keep_last_value') bool keepLastValue,
    
    // UI, Validation & Logic configurations
    @Default(<String, dynamic>{}) Map<String, dynamic> validation,
    @Default(<String, dynamic>{}) Map<String, dynamic> logic,
    @Default(<String, dynamic>{}) Map<String, dynamic> ui,
    
    // Choices / Nested structures
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> options,
    @Default(<String>[]) List<String> tags,
    @Default(<String, dynamic>{}) @JsonKey(name: 'meta_data') Map<String, dynamic> metadata,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

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
@freezed
abstract class Section with _$Section {
  const Section._();

  const factory Section({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'help_text') String? helpText,
    @Default(0) int order,
    @Default(<Question>[]) List<Question> questions,
    @Default(<Section>[]) List<Section> sections, // Nested sub-sections
    @Default('standard') String layout,
    @Default(2) @JsonKey(name: 'grid_columns') int gridColumns,
    @Default(false) @JsonKey(name: 'is_hidden') bool isHidden,
    @Default(false) @JsonKey(name: 'is_repeatable') bool isRepeatable,
    @JsonKey(name: 'repeat_min') int? repeatMin,
    @JsonKey(name: 'repeat_max') int? repeatMax,
    @Default(<String, dynamic>{}) Map<String, dynamic> logic,
    @Default(<String, dynamic>{}) Map<String, dynamic> ui,
    @Default(<String>[]) List<String> tags,
    @Default(<String, dynamic>{}) @JsonKey(name: 'meta_data') Map<String, dynamic> metadata,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);
}

/// =========================================================================
/// 3. MASTER FORM VERSION MODEL
/// =========================================================================
@freezed
abstract class FormVersion with _$FormVersion {
  const FormVersion._();

  const factory FormVersion({
    required String id,
    required String version,
    @Default(<Section>[]) List<Section> sections,
    @Default('draft') String status,
    @Default(<String, dynamic>{}) Map<String, dynamic> translations,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _FormVersion;

  factory FormVersion.fromJson(Map<String, dynamic> json) => _$FormVersionFromJson(json);
}

/// =========================================================================
/// 4. MASTER FORM MODEL
/// =========================================================================
@freezed
abstract class Form with _$Form {
  const Form._();

  const factory Form({
    required String id,
    required String title,
    required String slug,
    @JsonKey(name: 'organization_id') required String organizationId,
    @JsonKey(name: 'created_by') required String createdBy,
    @Default('draft') String status,
    @JsonKey(name: 'ui_type') @Default('flex') String uiType,
    @JsonKey(name: 'active_version') String? activeVersion,
    @Default(<FormVersion>[]) List<FormVersion> versions,
    
    // Configurations
    String? description,
    @JsonKey(name: 'help_text') String? helpText,
    @JsonKey(name: 'expires_at') String? expiresAt,
    @JsonKey(name: 'publish_at') String? publishAt,
    @Default(false) @JsonKey(name: 'is_template') bool isTemplate,
    @Default(false) @JsonKey(name: 'is_public') bool isPublic,
    @Default(['en']) @JsonKey(name: 'supported_languages') List<String> supportedLanguages,
    @Default('en') @JsonKey(name: 'default_language') String defaultLanguage,
    @Default(<String>[]) List<String> tags,
    
    // Integrations & Policies
    @Default(<String, dynamic>{}) Map<String, dynamic> workflows,
    @Default(<String, dynamic>{}) @JsonKey(name: 'access_policy') Map<String, dynamic> accessPolicy,
    @Default(<String, dynamic>{}) Map<String, dynamic> style,
  }) = _Form;

  factory Form.fromJson(Map<String, dynamic> json) => _$FormFromJson(json);

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
               fieldType == 'multi-file_upload' && e == QuestionType.multiFileUpload ||
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
