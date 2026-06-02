import 'package:json_annotation/json_annotation.dart';

class GlobalFilter {
  final String id;
  final String label;
  final String type; // date_range, category, status
  final String? fieldId;
  final dynamic value;
  final bool isActive;

  const GlobalFilter({
    required this.id,
    required this.label,
    required this.type,
    this.fieldId,
    this.value,
    this.isActive = true,
  });

  GlobalFilter copyWith({
    String? id,
    String? label,
    String? type,
    String? fieldId,
    dynamic value,
    bool? isActive,
  }) {
    return GlobalFilter(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      fieldId: fieldId ?? this.fieldId,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
    );
  }

  factory GlobalFilter.fromJson(Map<String, dynamic> json) {
    return GlobalFilter(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      fieldId: json['field_id'] as String?,
      value: json['value'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'field_id': fieldId,
      'value': value,
      'is_active': isActive,
    };
  }
}