import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';
import 'package:frontend/features/form_builder/domain/entities/form_version_history.dart';
import 'package:frontend/features/form_builder/presentation/controllers/version_history_controller.dart';

class MockFormBuilderRepository extends Mock implements FormBuilderRepository {}

void main() {
  late MockFormBuilderRepository mockRepository;

  setUp(() {
    mockRepository = MockFormBuilderRepository();
  });

  group('VersionHistoryController', () {
    const formId = 'test-form-id';
    final testVersion = FormVersionHistory(
      version: '1.0.0',
      createdAt: DateTime.now(),
      changeLog: 'Initial version',
      authorId: 'user-1',
    );

    test('initial state should be loading immediately', () {
      final container = ProviderContainer(
        overrides: [
          formBuilderRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(() => mockRepository.getVersionHistory(formId)).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return [testVersion];
      });

      // Reading the provider should trigger build
      container.listen(versionHistoryControllerProvider(formId), (_, __) {});

      final initialState = container.read(
        versionHistoryControllerProvider(formId),
      );

      expect(initialState.isLoading, true);
    });

    test('should load versions successfully', () async {
      final container = ProviderContainer(
        overrides: [
          formBuilderRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      when(
        () => mockRepository.getVersionHistory(formId),
      ).thenAnswer((_) async => [testVersion]);

      // Trigger
      container.listen(versionHistoryControllerProvider(formId), (_, __) {});

      // Wait for async operations
      // The controller uses Future.microtask, so we wait for microtasks.
      await Future.value();
      await container.pump();

      // We might need a small delay because of the async repository call even if mocked
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(versionHistoryControllerProvider(formId));

      expect(state.isLoading, false);
      expect(state.versions, hasLength(1));
      expect(state.versions.first, testVersion);
      expect(state.error, null);
    });
  });
}
