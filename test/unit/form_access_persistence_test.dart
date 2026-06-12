import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/models/access_policy.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';
import 'package:frontend/modules/forms/widgets/form_access_settings.dart';
import 'package:frontend/shared/models/form_models.dart';

class _FakeFormBuilderRepository implements FormBuilderRepository {
  BuilderForm? savedForm;

  @override
  Future<BuilderForm> saveForm(
    BuilderForm form, {
    required String projectId,
    String versionType = 'patch',
  }) async {
    savedForm = form;
    return form;
  }

  @override
  Future<BuilderForm> getForm(String projectId, String id) async {
    throw UnimplementedError('Not needed');
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<ProviderContainer> _makeContainer(
  _FakeFormBuilderRepository repo,
) async {
  final container = ProviderContainer(
    overrides: [formBuilderRepositoryProvider.overrideWithValue(repo)],
  );
  final sub = container.listen(
    formBuilderControllerProvider('project-1::new'),
    (_, _) {},
    fireImmediately: true,
  );
  while (container
      .read(formBuilderControllerProvider('project-1::new'))
      .isLoading) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  addTearDown(sub.close);
  return container;
}

void main() {
  test('form access policy updates and saves', () async {
    final repo = _FakeFormBuilderRepository();
    final container = await _makeContainer(repo);
    addTearDown(container.dispose);

    final notifier = container.read(
      formBuilderControllerProvider('project-1::new').notifier,
    );
    notifier.updateAccessPolicy(
      AccessPolicy(
        accessMode: 'private',
        requireLogin: true,
        allowedUserIds: const ['user-1'],
        passwordProtected: true,
        submissionLimitEnabled: true,
        submissionLimitCount: 10,
        responseIdentityMode: 'identified',
        requireLoginForResponse: true,
        collectName: true,
        collectEmail: true,
      ),
    );

    final afterUpdate = container
        .read(formBuilderControllerProvider('project-1::new'))
        .value!;
    expect(afterUpdate.form.accessPolicy['accessMode'], 'private');
    expect(afterUpdate.form.accessPolicy['requireLogin'], true);
    expect(afterUpdate.form.accessPolicy['submissionLimitCount'], 10);
    expect(afterUpdate.form.accessPolicy['responseIdentityMode'], 'identified');

    await notifier.saveForm();
    expect(repo.savedForm, isNotNull);
    expect(repo.savedForm!.accessPolicy['accessMode'], 'private');
    expect(repo.savedForm!.accessPolicy['collectEmail'], true);
  });

  testWidgets(
    'form access controls keep password confirmation and invites distinct',
    (tester) async {
      AccessPolicy? latestPolicy;
      Map<String, dynamic> form = {
        'accessPolicy': AccessPolicy(
          passwordProtected: true,
          inviteOnly: true,
        ).toJson(),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return FormAccessSettings(
                    form: form,
                    onChanged: (policy) {
                      latestPolicy = policy;
                      setState(() {
                        form = {'accessPolicy': policy.toJson()};
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(5));

      await tester.enterText(fields.at(0), 'secret-123');
      await tester.pump();
      await tester.enterText(fields.at(1), 'secret-xyz');
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
      expect(
        tester.widget<TextFormField>(fields.at(0)).controller!.text,
        'secret-123',
      );
      expect(
        tester.widget<TextFormField>(fields.at(1)).controller!.text,
        'secret-xyz',
      );
      expect(latestPolicy!.passwordHash, 'secret-123');

      await tester.enterText(fields.at(1), 'secret-123');
      await tester.pump();
      expect(find.text('Passwords do not match.'), findsNothing);

      await tester.enterText(fields.at(3), 'invitee@example.com');
      await tester.pump();
      await tester.enterText(fields.at(4), '2026-12-31');
      await tester.pump();

      expect(latestPolicy!.invites, hasLength(1));
      expect(latestPolicy!.invites.first['invitee'], 'invitee@example.com');
      expect(latestPolicy!.invites.first['expiresAt'], '2026-12-31');
    },
  );
}
