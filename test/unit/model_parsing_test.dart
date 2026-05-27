import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_source.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/core/network/api_client_wrapper.dart';
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthRemoteSourceImpl remoteSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    remoteSource = AuthRemoteSourceImpl(mockApiClient);
  });

  group('User entity parsing tests', () {
    test('parses organization_id correctly', () async {
      final responseData = {
        'user': {
          'id': 'u1',
          'username': 'testuser',
          'email': 'test@example.com',
          'roles': ['admin'],
          'organization_id': 'org-123',
        },
      };

      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      final user = await remoteSource.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.organizationId, 'org-123');
    });

    test('parses user in top level (after unwrap)', () async {
      final responseData = {
        'id': 'u2',
        'username': 'admin_user',
        'email': 'admin@example.com',
        'roles': ['superadmin'],
        'organization_id': 'org-456',
        'is_admin': true,
      };

      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      final user = await remoteSource.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.id, 'u2');
      expect(user.organizationId, 'org-456');
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from roles', () {
      final user = User(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['admin'],
        isAdminFlag: false,
      );
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from isAdminFlag', () {
      final user = User(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['user'],
        isAdminFlag: true,
      );
      expect(user.isAdmin, true);
    });

    test('isAdmin computed correctly from superadmin role', () {
      final user = User(
        id: '1',
        username: 'test',
        email: 'test@test.com',
        roles: ['superadmin'],
        isAdminFlag: false,
      );
      expect(user.isAdmin, true);
    });

    test('hasAtLeastRole respects role order', () {
      final user = User(
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
        'form': 'form-456',
        'organization_id': 'org-789',
        'submitted_by': 'user-abc',
        'submitted_at': '2026-04-01T10:30:00Z',
        'data': {'patient_name': 'John Doe', 'age': 35},
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

      expect(json['_id'], 'resp-123');
      expect(json['form'], 'form-456');
      expect(json['organization_id'], 'org-789');
      expect(json['submitted_by'], 'user-abc');
      expect(json['data'], {'patient_name': 'John Doe'});
      expect(json['status'], 'submitted');
    });
  });

  group('Register payload mapping tests', () {
    test('sends correct payload with default userType', () async {
      when(
        () => mockApiClient.post(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {'success': true},
          statusCode: 201,
        ),
      );

      await remoteSource.register(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        employeeId: 'EMP001',
        mobile: '1234567890',
      );

        verify(
        () => mockApiClient.post(
          ApiEndpoints.register,
          data: {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'password123',
            'user_type': 'general',
            'employee_id': 'EMP001',
            'mobile': '1234567890',
          },
        ),
      ).called(1);
    });
  });
}
