class FormResponse {
  final String? id;
  final String formId;
  final String organizationId;
  final String submittedBy;
  final DateTime? submittedAt;
  final Map<String, dynamic> answers;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? aiResults;
  final String status;

  const FormResponse({
    this.id,
    required this.formId,
    required this.organizationId,
    required this.submittedBy,
    this.submittedAt,
    required this.answers,
    this.ipAddress,
    this.userAgent,
    this.aiResults,
    this.status = 'submitted',
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) {
    return FormResponse(
      id: json['id'] as String?,
      formId: json['form_id'] as String,
      organizationId: json['organization_id'] as String? ?? '',
      submittedBy: json['submitted_by'] as String? ?? '',
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      answers: Map<String, dynamic>.from(json['answers'] ?? {}),
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      aiResults: json['ai_results'] != null
          ? Map<String, dynamic>.from(json['ai_results'])
          : null,
      status: json['status'] as String? ?? 'submitted',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_id': formId,
      'organization_id': organizationId,
      'submitted_by': submittedBy,
      'submitted_at': submittedAt?.toIso8601String(),
      'answers': answers,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'ai_results': aiResults,
      'status': status,
    };
  }
}

class ResponseHistory {
  final String id;
  final String responseId;
  final String action;
  final String performedBy;
  final DateTime performedAt;
  final Map<String, dynamic> changes;

  const ResponseHistory({
    required this.id,
    required this.responseId,
    required this.action,
    required this.performedBy,
    required this.performedAt,
    required this.changes,
  });

  factory ResponseHistory.fromJson(Map<String, dynamic> json) {
    return ResponseHistory(
      id: json['id'] as String? ?? '',
      responseId: json['response_id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      performedBy: json['performed_by'] as String? ?? '',
      performedAt: DateTime.tryParse(json['performed_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      changes: Map<String, dynamic>.from(json['changes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'response_id': responseId,
      'action': action,
      'performed_by': performedBy,
      'performed_at': performedAt.toIso8601String(),
      'changes': changes,
    };
  }
}
