import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend/core/network/token_service.dart';

class MockAuthRepository extends Mock implements AuthRepositoryImpl {}

class FakeTokenService extends TokenService {
  final AuthTokens tokens;
  FakeTokenService(this.tokens);
  @override
  FutureOr<AuthTokens> build() => tokens;
}

void main() {
  late MockAuthRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryImplProvider.overrideWithValue(mockRepo),
        tokenServiceProvider.overrideWith(() => FakeTokenService(AuthTokens())),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController', () {
    test('login sets user on success', () async {
      const user = User(
        id: '1',
        email: 'test@example.com',
        username: 'test',
        userType: 'Admin',
      );
      when(
        () => mockRepo.login('test@example.com', 'password'),
      ).thenAnswer((_) async => user);

      final controller = container.read(authControllerProvider.notifier);
      await controller.login('test@example.com', 'password');

      expect(container.read(authControllerProvider).value, user);
    });

    test('login sets error on failure', () async {
      when(
        () => mockRepo.login('test@example.com', 'password'),
      ).thenThrow(Exception('Login failed'));

      final states = <AsyncValue<User?>>[];
      container.listen(
        authControllerProvider,
        (prev, next) => states.add(next),
        fireImmediately: true,
      );

      final controller = container.read(authControllerProvider.notifier);
      await controller.login('test@example.com', 'password');

      // ignore: avoid_print
      print('States during login: $states');
      expect(states.any((s) => s.hasError), true);
    });

    test('logout clears user', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async {});

      final controller = container.read(authControllerProvider.notifier);
      await controller.logout();

      expect(container.read(authControllerProvider).value, null);
    });
  });
}
