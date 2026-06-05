class ProjectSummary {
  final String id;
  final String title;
  final String description;
  final String status;
  final int forms;
  final int responses;
  final int members;
  final List<String> collaborators;
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
    this.collaborators = const [],
    this.helpText,
    this.tags = const [],
    this.updatedAt,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) {
    final List<String> extractedMembers = [];

    // 1. Check explicit members/collaborators list
    final rawMembers = json['members'] ?? json['collaborators'];
    if (rawMembers is List) {
      extractedMembers.addAll(rawMembers.map((e) => e.toString()));
    }

    // 2. Check role-based lists (editors, viewers, submitters)
    final roleFields = ['editors', 'viewers', 'submitters'];
    for (final field in roleFields) {
      final roleList = json[field];
      if (roleList is List) {
        for (final item in roleList) {
          final member = item.toString();
          if (!extractedMembers.contains(member)) {
            extractedMembers.add(member);
          }
        }
      }
    }

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
      collaborators: extractedMembers,
      members: extractedMembers.length,
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
      'collaborators': collaborators,
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
    List<String>? collaborators,
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
      collaborators: collaborators ?? this.collaborators,
      helpText: helpText ?? this.helpText,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
