import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/signature_request.dart';
import '../../domain/repositories/signature_repository.dart';

part 'signature_controller.g.dart';

/// Controller for managing signature requests.
@riverpod
class SignatureController extends _$SignatureController {
  @override
  List<SignatureRequest> build() {
    return [];
  }

  /// Loads requests for a form.
  Future<void> loadRequests(String formId) async {
    final repository = ref.read(signatureRepositoryProvider);
    final requests = await repository.getRequestsForForm(formId);
    state = requests;
  }

  /// Creates a new signature request.
  Future<SignatureRequest> createRequest({
    required String formId,
    required String signerEmail,
    required String signerName,
    String? message,
  }) async {
    final user = ref.read(authControllerProvider);
    final repository = ref.read(signatureRepositoryProvider);

    final request = SignatureRequest.create(
      formId: formId,
      signerEmail: signerEmail,
      signerName: signerName,
      message: message,
      expiresInDays: 7,
    );

    final created = await repository.createRequest(request);
    state = [...state, created];
    return created;
  }

  /// Sends a request to the signer.
  Future<SignatureRequest> sendRequest(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.sendRequest(requestId);
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  /// Records a signature (for signer view).
  Future<SignatureRequest> recordSignature({
    required String requestId,
    required String signatureData,
    required String ipAddress,
  }) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.recordSignature(
      requestId: requestId,
      signatureData: signatureData,
      ipAddress: ipAddress,
    );
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  /// Declines a request.
  Future<SignatureRequest> declineRequest({
    required String requestId,
    required String ipAddress,
    String? reason,
  }) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.declineRequest(
      requestId: requestId,
      ipAddress: ipAddress,
      reason: reason,
    );
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  /// Cancels a pending request.
  Future<void> cancelRequest(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    await repository.cancelRequest(requestId);
    state = state.where((r) => r.id != requestId).toList();
  }

  /// Gets audit trail for a request.
  Future<List<SignatureAuditEntry>> getAuditTrail(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    return repository.getAuditTrail(requestId);
  }

  /// Verifies a signature.
  Future<bool> verifySignature(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    return repository.verifySignature(requestId);
  }

  /// Gets requests by status.
  List<SignatureRequest> getRequestsByStatus(SignatureRequestStatus status) {
    return state.where((r) => r.status == status).toList();
  }

  /// Gets pending requests count.
  int getPendingCount() {
    return state
        .where((r) => r.status == SignatureRequestStatus.pending)
        .length;
  }

  /// Gets completed requests count.
  int getCompletedCount() {
    return state.where((r) => r.status == SignatureRequestStatus.signed).length;
  }
}
