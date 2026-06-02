import 'package:frontend/core/form_models.dart';

/// Represents a pre-built form template that users can use to quickly create forms.
class FormTemplate {
  final String id;
  final String name;
  final String description;
  final FormTemplateCategory category;
  final Form form;
  final String thumbnailUrl;
  final List<String> tags;
  final int usageCount;
  final DateTime? createdAt;

  FormTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.form,
    this.thumbnailUrl = '',
    this.tags = const [],
    this.usageCount = 0,
    this.createdAt,
  });

  factory FormTemplate.fromJson(Map<String, dynamic> json) {
    return FormTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: FormTemplateCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => FormTemplateCategory.contact,
      ),
      form: Form.fromJson(json['form'] as Map<String, dynamic>),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      usageCount: json['usageCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'form': form.toJson(),
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'usageCount': usageCount,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is FormTemplate &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.category == category &&
      other.form == form &&
      other.thumbnailUrl == thumbnailUrl &&
      other.tags.toString() == tags.toString() &&
      other.usageCount == usageCount &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      category.hashCode ^
      form.hashCode ^
      thumbnailUrl.hashCode ^
      tags.hashCode ^
      usageCount.hashCode ^
      createdAt.hashCode;
  }

  FormTemplate copyWith({
    String? id,
    String? name,
    String? description,
    FormTemplateCategory? category,
    Form? form,
    String? thumbnailUrl,
    List<String>? tags,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return FormTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      form: form ?? this.form,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tags: tags ?? this.tags,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Represents categories for organizing form templates.
enum FormTemplateCategory {
  contact('Contact Forms'),
  survey('Survey & Feedback'),
  registration('Registration'),
  event('Event Management'),
  feedback('Customer Feedback'),
  application('Job Application'),
  order('Order Form'),
  payment('Payment Form'),
  health('Health & Medical'),
  education('Education & Training'),
  business('Business & Finance'),
  personal('Personal & Lifestyle'),
  assessment('Assessment'),
  other('Other');

  const FormTemplateCategory(this.displayName);

  final String displayName;
}