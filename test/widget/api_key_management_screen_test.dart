import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/modules/platform/api_key_repository.dart';
import 'package:frontend/modules/platform/screens/api_key_management_screen.dart';

void main() {
  testWidgets('api key management screen renders keys from repository', (
    tester,
  ) async {
    final repo = _FakeApiKeyRepository(
      keys: [
        {
          'id': 'key-1',
          'name': 'External Mail',
          'key_prefix': 'abcd1234',
          'is_active': true,
          'scopes': const ['mail:send'],
        },
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiKeyRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: ApiKeyManagementScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('API Key Management'), findsOneWidget);
    expect(find.text('External Mail'), findsOneWidget);
    expect(find.text('Prefix: abcd1234'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
  });
}

class _FakeApiKeyRepository implements ApiKeyRepository {
  final List<Map<String, dynamic>> keys;

  _FakeApiKeyRepository({this.keys = const []});

  @override
  Future<Map<String, dynamic>> createApiKey({
    required String name,
    List<String> scopes = const [],
  }) async {
    return {
      'id': 'created-1',
      'name': name,
      'key_prefix': 'abcd1234',
      'raw_key': 'fbp_abcd1234_secret',
      'scopes': scopes,
      'is_active': true,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> listApiKeys() async {
    return keys;
  }
}
