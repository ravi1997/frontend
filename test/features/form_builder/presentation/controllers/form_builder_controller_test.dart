import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/form_builder/domain/entities/question_type.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'package:frontend/features/form_builder/domain/repositories/form_builder_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFormBuilderRepository extends Mock implements FormBuilderRepository {}

void main() {
  group('FormBuilderController', () {
    late ProviderContainer container;
    late MockFormBuilderRepository mockRepo;

    setUp(() {
      mockRepo = MockFormBuilderRepository();
      container = ProviderContainer(
        overrides: [formBuilderRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    test('should initialize with a new form', () async {
      final state = await container.read(
        formBuilderControllerProvider('new').future,
      );

      expect(state.form.title, 'Untitled Form');
      expect(state.form.sections.length, 1);
    });

    test('addSection should add a new section', () async {
      await container.read(formBuilderControllerProvider('new').future);
      final controller = container.read(
        formBuilderControllerProvider('new').notifier,
      );

      controller.addSection();

      final state = container.read(formBuilderControllerProvider('new')).value!;
      expect(state.form.sections.length, 2);
    });

    test('addQuestion should add a question to a section', () async {
      final initialState = await container.read(
        formBuilderControllerProvider('new').future,
      );
      final controller = container.read(
        formBuilderControllerProvider('new').notifier,
      );
      final sectionId = initialState.form.sections.first.id;

      controller.addQuestion(sectionId, QuestionType.shortText);

      final state = container.read(formBuilderControllerProvider('new')).value!;
      expect(state.form.sections.first.questions.length, 1);
      expect(
        state.form.sections.first.questions.first.type,
        QuestionType.shortText,
      );
    });

    test('publishForm should increment version', () async {
      await container.read(formBuilderControllerProvider('new').future);
      final controller = container.read(
        formBuilderControllerProvider('new').notifier,
      );

      // Mock publishForm which is the actual method called by the controller
      when(
        () => mockRepo.publishForm(any()),
      ).thenAnswer((_) async => {'published_version': '1.0.1'});

      final success = await controller.publishForm();

      expect(success, true);
      final state = container.read(formBuilderControllerProvider('new')).value!;
      expect(state.form.version, '1.0.1');
      expect(state.form.isPublished, true);
    });
  });

  setUpAll(() {
    registerFallbackValue(BuilderForm(id: '', title: '', sections: []));
  });
}
