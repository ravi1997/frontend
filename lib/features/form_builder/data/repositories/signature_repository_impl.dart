import 'package:logger/logger.dart';
import '../../domain/entities/signature_request.dart';
import '../../domain/repositories/signature_repository.dart';
import '../../../../core/network/api_client_wrapper.dart';

/// Implementation of [SignatureRepository] for signature operations.
///
/// Handles signature requests, verification, and audit trails via the backend API.
class SignatureRepositoryImpl implements SignatureRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  SignatureRepositoryImpl(this._apiClient);

  @override
  Future<SignatureRequest> createRequest(SignatureRequest request) async {
    try {
      final response = await _apiClient.post(
        '/forms/${request.formId}/signature-requests',
        data: request.toJson(),
      );

      _logger.i('Created signature request for: ${request.signerEmail}');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e(
        'Failed to create signature request',
        error: e,
        stackTrace: stack,
      );
      throw _createException('Failed to create signature request', e, stack);
    }
  }

  @override
  Future<SignatureRequest> getRequest(String requestId) async {
    try {
      final response = await _apiClient.get('/signature-requests/$requestId');

      _logger.i('Loaded signature request: $requestId');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e(
        'Failed to load signature request',
        error: e,
        stackTrace: stack,
      );
      throw _createException('Failed to load signature request', e, stack);
    }
  }

  @override
  Future<List<SignatureRequest>> getRequestsForForm(String formId) async {
    try {
      final response = await _apiClient.get(
        '/forms/$formId/signature-requests',
      );
      final data = response.data as List<dynamic>;

      final requests = data.map((item) {
        return SignatureRequest.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${requests.length} requests for form: $formId');
      return requests;
    } catch (e, stack) {
      _logger.e('Failed to load requests', error: e, stackTrace: stack);
      throw _createException('Failed to load requests for form', e, stack);
    }
  }

  @override
  Future<List<SignatureRequest>> getRequestsForSigner(String email) async {
    try {
      final response = await _apiClient.get('/signature-requests?email=$email');
      final data = response.data as List<dynamic>;

      final requests = data.map((item) {
        return SignatureRequest.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${requests.length} requests for signer: $email');
      return requests;
    } catch (e, stack) {
      _logger.e(
        'Failed to load requests for signer',
        error: e,
        stackTrace: stack,
      );
      throw _createException('Failed to load requests for signer', e, stack);
    }
  }

  @override
  Future<SignatureRequest> sendRequest(String requestId) async {
    try {
      final response = await _apiClient.post(
        '/signature-requests/$requestId/send',
      );

      _logger.i('Sent signature request: $requestId');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to send request', error: e, stackTrace: stack);
      throw _createException('Failed to send signature request', e, stack);
    }
  }

  @override
  Future<SignatureRequest> markViewed(
    String requestId, {
    required String ipAddress,
    required String userAgent,
  }) async {
    try {
      final response = await _apiClient.post(
        '/signature-requests/$requestId/view',
        data: {'ipAddress': ipAddress, 'userAgent': userAgent},
      );

      _logger.i('Marked request as viewed: $requestId');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to mark as viewed', error: e, stackTrace: stack);
      throw _createException('Failed to mark request as viewed', e, stack);
    }
  }

  @override
  Future<SignatureRequest> recordSignature(
    String requestId, {
    required String signatureData,
    required String ipAddress,
  }) async {
    try {
      final response = await _apiClient.post(
        '/signature-requests/$requestId/sign',
        data: {'signatureData': signatureData, 'ipAddress': ipAddress},
      );

      _logger.i('Recorded signature for request: $requestId');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to record signature', error: e, stackTrace: stack);
      throw _createException('Failed to record signature', e, stack);
    }
  }

  @override
  Future<SignatureRequest> declineRequest(
    String requestId, {
    required String ipAddress,
    String? reason,
  }) async {
    try {
      final response = await _apiClient.post(
        '/signature-requests/$requestId/decline',
        data: {'ipAddress': ipAddress, 'reason': reason},
      );

      _logger.i('Declined request: $requestId');
      return SignatureRequest.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stack) {
      _logger.e('Failed to decline request', error: e, stackTrace: stack);
      throw _createException('Failed to decline request', e, stack);
    }
  }

  @override
  Future<void> cancelRequest(String requestId) async {
    try {
      await _apiClient.delete('/signature-requests/$requestId');
      _logger.i('Cancelled request: $requestId');
    } catch (e, stack) {
      _logger.e('Failed to cancel request', error: e, stackTrace: stack);
      throw _createException('Failed to cancel request', e, stack);
    }
  }

  @override
  Future<List<SignatureAuditEntry>> getAuditTrail(String requestId) async {
    try {
      final response = await _apiClient.get(
        '/signature-requests/$requestId/audit',
      );
      final data = response.data as List<dynamic>;

      final entries = data.map((item) {
        return SignatureAuditEntry.fromJson(item as Map<String, dynamic>);
      }).toList();

      _logger.i('Loaded ${entries.length} audit entries for: $requestId');
      return entries;
    } catch (e, stack) {
      _logger.e('Failed to load audit trail', error: e, stackTrace: stack);
      throw _createException('Failed to load audit trail', e, stack);
    }
  }

  @override
  Future<bool> verifySignature(String requestId) async {
    try {
      final response = await _apiClient.get(
        '/signature-requests/$requestId/verify',
      );
      return response.data['valid'] as bool;
    } catch (e, stack) {
      _logger.e('Failed to verify signature', error: e, stackTrace: stack);
      throw _createException('Failed to verify signature', e, stack);
    }
  }

  @override
  Future<String> generateSigningDocument(String requestId) async {
    try {
      final response = await _apiClient.get(
        '/signature-requests/$requestId/document',
      );
      return response.data['documentBase64'] as String;
    } catch (e, stack) {
      _logger.e('Failed to generate document', error: e, stackTrace: stack);
      throw _createException('Failed to generate signing document', e, stack);
    }
  }

  Exception _createException(String message, Object error, StackTrace stack) {
    return Exception('$message: $error');
  }
}
