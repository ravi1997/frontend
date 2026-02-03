import '../entities/signature_request.dart';

/// Repository interface for signature operations.
///
/// Handles signature requests, verification, and audit trails.
abstract class SignatureRepository {
  /// Creates a new signature request.
  Future<SignatureRequest> createRequest(SignatureRequest request);

  /// Gets a signature request by ID.
  Future<SignatureRequest> getRequest(String requestId);

  /// Gets all requests for a form.
  Future<List<SignatureRequest>> getRequestsForForm(String formId);

  /// Gets all requests for a signer.
  Future<List<SignatureRequest>> getRequestsForSigner(String email);

  /// Sends a signature request to signer.
  Future<SignatureRequest> sendRequest(String requestId);

  /// Records that a request was viewed.
  Future<SignatureRequest> markViewed(
    String requestId, {
    required String ipAddress,
    required String userAgent,
  });

  /// Records a signature.
  Future<SignatureRequest> recordSignature(
    String requestId, {
    required String signatureData,
    required String ipAddress,
  });

  /// Marks a request as declined.
  Future<SignatureRequest> declineRequest(
    String requestId, {
    required String ipAddress,
    String? reason,
  });

  /// Cancels a pending request.
  Future<void> cancelRequest(String requestId);

  /// Gets audit trail for a request.
  Future<List<SignatureAuditEntry>> getAuditTrail(String requestId);

  /// Verifies a signature is authentic.
  Future<bool> verifySignature(String requestId);

  /// Generates a PDF document for signing.
  Future<String> generateSigningDocument(String requestId);
}
