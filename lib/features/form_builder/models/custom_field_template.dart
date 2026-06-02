class CustomFieldTemplate {
  final String id;
  final String name;
  final String category;
  final String template_type;
  final Map<String, dynamic> data;

  CustomFieldTemplate({
    required this.id,
    required this.name,
    required this.category,
    this.template_type = 'question',
    this.data = const {},
  });

  factory CustomFieldTemplate.fromJson(Map<String, dynamic> json) {
    return CustomFieldTemplate(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      template_type: json['template_type'] as String? ?? 'question',
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'template_type': template_type,
      'data': data,
    };
  }

  CustomFieldTemplate copyWith({
    String? id,
    String? name,
    String? category,
    String? template_type,
    Map<String, dynamic>? data,
  }) {
    return CustomFieldTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      template_type: template_type ?? this.template_type,
      data: data ?? this.data,
    );
  }
}
