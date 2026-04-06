import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_source.dart';
import 'package:frontend/core/network/api_client_wrapper.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthRemoteSourceImpl remoteSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    remoteSource = AuthRemoteSourceImpl(mockApiClient);
  });

  group('getCurrentUser parsing tests', () {
    test('parses user in nested key', () async {
      final responseData = {
        'user': {
          'id': 'u1',
          'username': 'testuser',
          'email': 'test@example.com',
          'user_type': 'admin',
          'roles': ['admin'],
        }
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
      expect(user!.id, 'u1');
      expect(user.username, 'testuser');
    });

    test('parses user in top level (after unwrap)', () async {
      final responseData = {
        'id': 'u2',
        'username': 'admin_user',
        'email': 'admin@example.com',
        'user_type': 'superadmin',
        'roles': ['superadmin'],
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
      expect(user.username, 'admin_user');
    });

    test('returns null when user fields are missing', () async {
      final responseData = {
        'something': 'else',
      };

      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      final user = await remoteSource.getCurrentUser();
      expect(user, isNull);
    });
  });
}
