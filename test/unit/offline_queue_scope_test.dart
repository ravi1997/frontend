import 'package:frontend/modules/forms/responses/data/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pendingSubmissionBelongsToScope', () {
    test('matches payloads for the same user and organization', () {
      final payload = {
        'response': {
          'id': 'resp-1',
          'form_id': 'form-1',
          'organization_id': 'org-1',
          'submitted_by': 'user-1',
          'answers': {},
          'status': 'submitted',
        },
      };

      expect(
        pendingSubmissionBelongsToScope(
          payload,
          userId: 'user-1',
          organizationId: 'org-1',
        ),
        isTrue,
      );
    });

    test('rejects payloads for a different user', () {
      final payload = {
        'response': {
          'id': 'resp-1',
          'form_id': 'form-1',
          'organization_id': 'org-1',
          'submitted_by': 'user-2',
          'answers': {},
          'status': 'submitted',
        },
      };

      expect(
        pendingSubmissionBelongsToScope(
          payload,
          userId: 'user-1',
          organizationId: 'org-1',
        ),
        isFalse,
      );
    });

    test('rejects payloads when response data is missing', () {
      expect(
        pendingSubmissionBelongsToScope(
          const {},
          userId: 'user-1',
          organizationId: 'org-1',
        ),
        isFalse,
      );
    });
  });
}
