class ProjectSummary {
  final String id;
  final String title;
  final String description;
  final String status;
  final int forms;
  final int responses;
  final int members;
  final String? helpText;
  final List<String> tags;
  final String? updatedAt;

  const ProjectSummary({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'draft',
    this.forms = 0,
    this.responses = 0,
    this.members = 0,
    this.helpText,
    this.tags = const [],
    this.updatedAt,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    return ProjectSummary(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Project',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'draft',
      forms: (json['forms'] is List) ? (json['forms'] as List).length : 0,
      responses: (json['response_count'] as num? ??
              json['responses_count'] as num? ??
              0)
          .toInt(),
      members: (json['members'] is List) ? (json['members'] as List).length : 0,
      helpText: json['help_text']?.toString(),
      tags: (json['tags'] is List)
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : const [],
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'forms': forms,
      'responses': responses,
      'members': members,
      'help_text': helpText,
      'tags': tags,
      'updated_at': updatedAt,
    };
  }

  ProjectSummary copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    int? forms,
    int? responses,
    int? members,
    String? helpText,
    List<String>? tags,
    String? updatedAt,
  }) {
    return ProjectSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      forms: forms ?? this.forms,
      responses: responses ?? this.responses,
      members: members ?? this.members,
      helpText: helpText ?? this.helpText,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
