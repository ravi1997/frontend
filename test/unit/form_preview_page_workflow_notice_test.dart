import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('preview page workflow notice uses non-simulated wording', () {
    final source = File(
      'lib/modules/forms/pages/form_preview_page.dart',
    ).readAsStringSync();

    expect(
      source,
      contains('Preview Mode: Workflow actions are not executed.'),
    );
    expect(source, isNot(contains('simulated in logs')));
  });
}
