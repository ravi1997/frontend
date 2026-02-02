import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/localization/locale_controller.dart';

void main() {
  group('i18n Extensions', () {
    test('translate extension handles String', () {
      const String label = 'Name';
      expect(label.translate('es'), 'Name');
    });

    test('translate extension handles Map with locale', () {
      final map = {'en': 'Name', 'es': 'Nombre'};
      expect(map.translate('es'), 'Nombre');
    });

    test('translate extension handles Map with fallback', () {
      final map = {'en': 'Name', 'es': 'Nombre'};
      expect(map.translate('fr'), 'Name');
    });

    test('translate extension handles Map with first item if no fallback', () {
      final map = {'es': 'Nombre'};
      expect(map.translate('fr'), 'Nombre');
    });

    test('translate extension handles empty map', () {
      final map = {};
      expect(map.translate('es'), '');
    });
  });
}
