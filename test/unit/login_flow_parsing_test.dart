import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/token_service.dart';
import 'package:frontend/features/auth/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockTokenService extends Mock implements TokenService {}

void main() {
  late AuthService authService;
  late MockApiClient mockApiClient;
  late MockTokenService mockTokenService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockTokenService = MockTokenService();
    authService = AuthService(mockApiClient, mockTokenService);
    
    registerFallbackValue(Uri());
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
        },
      };

      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      final user = await authService.getCurrentUser();
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

      final user = await authService.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.id, 'u2');
      expect(user.username, 'admin_user');
    });

    test('returns null when user fields are missing', () async {
      final responseData = {'something': 'else'};

      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: responseData,
          statusCode: 200,
        ),
      );

      final user = await authService.getCurrentUser();
      expect(user, isNull);
    });
  });
}
