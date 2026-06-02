import '../../../../core/utils/id_reader.dart';

class FormQuestionOption {
  final String id;
  final String? description;
  final bool isDefault;
  final bool isDisabled;
  final String label;
  final String value;
  final int order;
  final String? visibilityCondition;

  FormQuestionOption({
    required this.id,
    this.description,
    this.isDefault = false,
    this.isDisabled = false,
    required this.label,
    required this.value,
    this.order = 0,
    this.visibilityCondition,
  });

  factory FormQuestionOption.fromJson(Map<String, dynamic> json) {
    return FormQuestionOption(
      id: (IdReader.readIdCallback(json, 'id') ?? json['id']) as String? ?? '',
      description: json['description'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isDisabled: json['is_disabled'] as bool? ?? false,
      label: json['option_label'] as String? ?? '',
      value: json['option_value'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      visibilityCondition: json['visibility_condition'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'is_default': isDefault,
      'is_disabled': isDisabled,
      'option_label': label,
      'option_value': value,
      'order': order,
      'visibility_condition': visibilityCondition,
    };
  }

  FormQuestionOption copyWith({
    String? id,
    String? description,
    bool? isDefault,
    bool? isDisabled,
    String? label,
    String? value,
    int? order,
    String? visibilityCondition,
  }) {
    return FormQuestionOption(
      id: id ?? this.id,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      isDisabled: isDisabled ?? this.isDisabled,
      label: label ?? this.label,
      value: value ?? this.value,
      order: order ?? this.order,
      visibilityCondition: visibilityCondition ?? this.visibilityCondition,
    );
  }
}
