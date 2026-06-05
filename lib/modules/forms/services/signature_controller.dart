import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/models/signature_request.dart';
import 'package:frontend/modules/forms/services/signature_repository.dart';

class SignatureController extends ChangeNotifier {
  SignatureController(this.ref);

  final Ref ref;
  List<SignatureRequest> _state = const [];

  List<SignatureRequest> get state => _state;

  set state(List<SignatureRequest> value) {
    _state = value;
    notifyListeners();
  }

  Future<void> loadRequests(String formId) async {
    final repository = ref.read(signatureRepositoryProvider);
    state = await repository.getRequestsForForm(formId);
  }

  Future<SignatureRequest> createRequest({
    required String formId,
    required String signerEmail,
    required String signerName,
    String? message,
  }) async {
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

  Future<SignatureRequest> sendRequest(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.sendRequest(requestId);
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  Future<SignatureRequest> recordSignature({
    required String requestId,
    required String signatureData,
    required String ipAddress,
  }) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.recordSignature(
      requestId,
      signatureData: signatureData,
      ipAddress: ipAddress,
    );
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  Future<SignatureRequest> declineRequest({
    required String requestId,
    required String ipAddress,
    String? reason,
  }) async {
    final repository = ref.read(signatureRepositoryProvider);
    final updated = await repository.declineRequest(
      requestId,
      ipAddress: ipAddress,
      reason: reason,
    );
    state = state.map((r) => r.id == requestId ? updated : r).toList();
    return updated;
  }

  Future<void> cancelRequest(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    await repository.cancelRequest(requestId);
    state = state.where((r) => r.id != requestId).toList();
  }

  Future<List<SignatureAuditEntry>> getAuditTrail(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    return repository.getAuditTrail(requestId);
  }

  Future<bool> verifySignature(String requestId) async {
    final repository = ref.read(signatureRepositoryProvider);
    return repository.verifySignature(requestId);
  }

  List<SignatureRequest> getRequestsByStatus(SignatureRequestStatus status) {
    return state.where((r) => r.status == status).toList();
  }

  int getPendingCount() {
    return state.where((r) => r.status == SignatureRequestStatus.pending).length;
  }

  int getCompletedCount() {
    return state.where((r) => r.status == SignatureRequestStatus.signed).length;
  }
}

final signatureControllerProvider = Provider<SignatureController>((ref) {
  final controller = SignatureController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
