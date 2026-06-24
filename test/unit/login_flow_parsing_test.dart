import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/networking/api_client.dart';
import 'package:frontend/core/networking/token_service.dart';
import 'package:frontend/modules/auth/auth_service.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:frontend/modules/auth/auth_widgets.dart';

class MockDio extends Mock implements Dio {}
class MockTokenService extends Mock implements TokenService {}

void main() {
  late AuthService authService;
  late MockDio mockApiClient;
  late MockTokenService mockTokenService;

  setUp(() {
    mockApiClient = MockDio();
    mockTokenService = MockTokenService();
    authService = AuthService(ApiClient(mockApiClient), mockTokenService);
    
    registerFallbackValue(Uri());
  });

  group('UI login widget tests', () {
    flutter_test.testWidgets('submits env credentials via UI', (flutter_test.WidgetTester tester) async {
      final envEmail = Platform.environment['TEST_EMAIL'] ?? 'alice@hospital.org';
      final envPassword = Platform.environment['TEST_PASSWORD'] ?? 'SecureP@ss2026';

      String? submittedEmail;
      String? submittedPassword;


      // Use the real `AuthTextFormField` from the app to exercise shared input styling
      final emailController = TextEditingController();
      final passwordController = TextEditingController();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AuthTextFormField(
                  key: const Key('emailField'),
                  controller: emailController,
                  label: 'Email',
                  placeholder: 'you@example.com',
                ),
                AuthTextFormField(
                  key: const Key('passwordField'),
                  controller: passwordController,
                  label: 'Password',
                  placeholder: 'Password',
                  obscureText: true,
                ),
                ElevatedButton(
                  key: const Key('submitBtn'),
                  onPressed: () {
                    submittedEmail = emailController.text;
                    submittedPassword = passwordController.text;
                  },
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ),
        ),
      ));

      await tester.enterText(find.byKey(const Key('emailField')), envEmail);
      await tester.enterText(find.byKey(const Key('passwordField')), envPassword);
      await tester.tap(find.byKey(const Key('submitBtn')));
      await tester.pumpAndSettle();

      flutter_test.expect(submittedEmail, envEmail);
      flutter_test.expect(submittedPassword, envPassword);
    });
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
