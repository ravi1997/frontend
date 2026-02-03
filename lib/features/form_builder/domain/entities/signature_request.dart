import 'package:uuid/uuid.dart';

/// Status of a signature request.
enum SignatureRequestStatus { pending, sent, viewed, signed, declined, expired }

/// Represents a signature request sent to a signer.
class SignatureRequest {
  /// Unique identifier for this request.
  final String id;

  /// Form ID this signature is for.
  final String formId;

  /// Response ID if applicable.
  final String? responseId;

  /// Signer email.
  final String signerEmail;

  /// Signer name.
  final String signerName;

  /// Current status.
  final SignatureRequestStatus status;

  /// Signature data (base64 PNG or SVG).
  final String? signatureData;

  /// Timestamp when request was created.
  final DateTime createdAt;

  /// Timestamp when request was sent.
  final DateTime? sentAt;

  /// Timestamp when viewed by signer.
  final DateTime? viewedAt;

  /// Timestamp when signed.
  final DateTime? signedAt;

  /// IP address of signer.
  final String? signerIp;

  /// User agent of signer.
  final String? signerUserAgent;

  /// Message to signer.
  final String? message;

  /// Expiration date.
  final DateTime? expiresAt;

  /// PDF document with signature field (base64).
  final String? documentBase64;

  const SignatureRequest({
    required this.id,
    required this.formId,
    this.responseId,
    required this.signerEmail,
    required this.signerName,
    required this.status,
    this.signatureData,
    required this.createdAt,
    this.sentAt,
    this.viewedAt,
    this.signedAt,
    this.signerIp,
    this.signerUserAgent,
    this.message,
    this.expiresAt,
    this.documentBase64,
  });

  /// Creates a new signature request.
  factory SignatureRequest.create({
    required String formId,
    required String signerEmail,
    required String signerName,
    String? message,
    int expiresInDays = 7,
  }) {
    final now = DateTime.now();
    return SignatureRequest(
      id: const Uuid().v4(),
      formId: formId,
      signerEmail: signerEmail,
      signerName: signerName,
      status: SignatureRequestStatus.pending,
      createdAt: now,
      expiresAt: now.add(Duration(days: expiresInDays)),
      message: message,
    );
  }

  /// Creates a copy with updated values.
  SignatureRequest copyWith({
    String? id,
    String? formId,
    String? responseId,
    String? signerEmail,
    String? signerName,
    SignatureRequestStatus? status,
    String? signatureData,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? viewedAt,
    DateTime? signedAt,
    String? signerIp,
    String? signerUserAgent,
    String? message,
    DateTime? expiresAt,
    String? documentBase64,
  }) {
    return SignatureRequest(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      responseId: responseId ?? this.responseId,
      signerEmail: signerEmail ?? this.signerEmail,
      signerName: signerName ?? this.signerName,
      status: status ?? this.status,
      signatureData: signatureData ?? this.signatureData,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      viewedAt: viewedAt ?? this.viewedAt,
      signedAt: signedAt ?? this.signedAt,
      signerIp: signerIp ?? this.signerIp,
      signerUserAgent: signerUserAgent ?? this.signerUserAgent,
      message: message ?? this.message,
      expiresAt: expiresAt ?? this.expiresAt,
      documentBase64: documentBase64 ?? this.documentBase64,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'responseId': responseId,
      'signerEmail': signerEmail,
      'signerName': signerName,
      'status': status.name,
      'signatureData': signatureData,
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'viewedAt': viewedAt?.toIso8601String(),
      'signedAt': signedAt?.toIso8601String(),
      'signerIp': signerIp,
      'signerUserAgent': signerUserAgent,
      'message': message,
      'expiresAt': expiresAt?.toIso8601String(),
      'documentBase64': documentBase64,
    };
  }

  /// Creates from JSON.
  factory SignatureRequest.fromJson(Map<String, dynamic> json) {
    return SignatureRequest(
      id: json['id'] as String,
      formId: json['formId'] as String,
      responseId: json['responseId'] as String?,
      signerEmail: json['signerEmail'] as String,
      signerName: json['signerName'] as String,
      status: SignatureRequestStatus.values.byName(json['status'] as String),
      signatureData: json['signatureData'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
      viewedAt: json['viewedAt'] != null
          ? DateTime.parse(json['viewedAt'] as String)
          : null,
      signedAt: json['signedAt'] != null
          ? DateTime.parse(json['signedAt'] as String)
          : null,
      signerIp: json['signerIp'] as String?,
      signerUserAgent: json['signerUserAgent'] as String?,
      message: json['message'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      documentBase64: json['documentBase64'] as String?,
    );
  }
}

/// Represents an audit trail entry for a signature.
class SignatureAuditEntry {
  /// Unique identifier.
  final String id;

  /// Signature request ID.
  final String requestId;

  /// Action type.
  final String action;

  /// Timestamp.
  final DateTime timestamp;

  /// IP address.
  final String? ipAddress;

  /// Additional details.
  final Map<String, dynamic>? details;

  const SignatureAuditEntry({
    required this.id,
    required this.requestId,
    required this.action,
    required this.timestamp,
    this.ipAddress,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'ipAddress': ipAddress,
      'details': details,
    };
  }

  factory SignatureAuditEntry.fromJson(Map<String, dynamic> json) {
    return SignatureAuditEntry(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ipAddress: json['ipAddress'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
}
