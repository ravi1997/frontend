import '../../../../core/utils/date_utils.dart';

/// Lightweight response model.
///
/// This used to rely on json_serializable/freezed generated code, but the
/// generated `form_response.g.dart` is not present in the repo, which breaks
/// analysis and builds. Keep this file generator-free.
class FormResponse {
  final String id;
  final String formId;
  final String? organizationId;
  final String? submittedBy;
  final DateTime? submittedAt;
  final Map<String, dynamic> answers;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic> aiResults;
  final String status;

  const FormResponse({
    required this.id,
    required this.formId,
    this.organizationId,
    this.submittedBy,
    this.submittedAt,
    required this.answers,
    this.ipAddress,
    this.userAgent,
    this.aiResults = const <String, dynamic>{},
    this.status = 'pending',
  });

  factory FormResponse.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);

    // Backend may return `_id` while some callers use `id`.
    final String id = (normalized['_id'] ?? normalized['id'] ?? '').toString();

    return FormResponse(
      id: id,
      formId: (normalized['form'] ?? normalized['form_id'] ?? '').toString(),
      organizationId: normalized['organization_id']?.toString(),
      submittedBy: normalized['submitted_by']?.toString(),
      submittedAt: AppDateUtils.parse(normalized['submitted_at']),
      answers: Map<String, dynamic>.from(normalized['data'] as Map? ?? const {}),
      ipAddress: normalized['ip_address']?.toString(),
      userAgent: normalized['user_agent']?.toString(),
      aiResults: Map<String, dynamic>.from(
        normalized['ai_results'] as Map? ?? const {},
      ),
      status: (normalized['status'] ?? 'pending').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'id': id,
      'form': formId,
      'organization_id': organizationId,
      'submitted_by': submittedBy,
      'submitted_at': AppDateUtils.toIso8601(submittedAt),
      'data': answers,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'ai_results': aiResults,
      'status': status,
    }..removeWhere((k, v) => v == null);
  }
}

