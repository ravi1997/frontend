import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/auth/auth_models.dart';
import 'package:frontend/modules/forms/responses/form_response.dart';

void main() {
  group('UserModel entity parsing tests', () {
    test('parses organization_id correctly', () async {
      final user = UserModel(
        id: 'u1',
        username: 'testuser',
        email: 'test@example.com',
        roles: ['admin'],
        organizationId: 'org-123',
      );

      expect(user.organizationId, 'org-123');
    });

    test('parses user in top level (after unwrap)', () async {
      final user = UserModel(
        id: 'u2',
        username: 'admin_user',
        email: 'admin@example.com',
        roles: ['superadmin'],
        organizationId: 'org-456',
        isAdminFlag: true,
      );

      expect(user.id, 'u2');
      expect(user.organizationId, 'org-456');
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from roles', () {
      final user = UserModel(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['admin'],
        isAdminFlag: false,
      );
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from isAdminFlag', () {
      final user = UserModel(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['user'],
        isAdminFlag: true,
      );
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from superadmin role', () {
      final user = UserModel(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['superadmin'],
        isAdminFlag: false,
      );
      expect(user.isAdmin, true);
    });

    test('hasAtLeastRole respects role order', () {
      final user = UserModel(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['manager'],
      );

      expect(user.hasAtLeastRole('user'), true);
      expect(user.hasAtLeastRole('manager'), true);
      expect(user.hasAtLeastRole('admin'), false);
      expect(user.hasAtLeastRole('superadmin'), false);
    });
  });

  group('FormResponse parsing tests', () {
    test('parses backend response correctly', () {
      final json = {
        'id': 'resp-123',
        'form_id': 'form-456',
        'organization_id': 'org-789',
        'submitted_by': 'user-abc',
        'submitted_at': '2026-04-01T10:30:00Z',
        'answers': {'patient_name': 'John Doe', 'age': 35},
        'ip_address': '10.0.0.1',
        'user_agent': 'Mozilla/5.0',
        'status': 'submitted',
      };

      final response = FormResponse.fromJson(json);

      expect(response.id, 'resp-123');
      expect(response.formId, 'form-456');
      expect(response.organizationId, 'org-789');
      expect(response.submittedBy, 'user-abc');
      expect(response.answers['patient_name'], 'John Doe');
      expect(response.ipAddress, '10.0.0.1');
      expect(response.status, 'submitted');
    });

    test('serializes to backend format correctly', () {
      final response = FormResponse(
        id: 'resp-123',
        formId: 'form-456',
        organizationId: 'org-789',
        submittedBy: 'user-abc',
        answers: {'patient_name': 'John Doe'},
        status: 'submitted',
      );

      final json = response.toJson();

      expect(json['id'], 'resp-123');
      expect(json['form_id'], 'form-456');
      expect(json['organization_id'], 'org-789');
      expect(json['submitted_by'], 'user-abc');
      expect(json['answers'], {'patient_name': 'John Doe'});
      expect(json['status'], 'submitted');
    });
  });

}
