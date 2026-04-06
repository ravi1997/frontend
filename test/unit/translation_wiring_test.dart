import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Translation controller tests', () {
    test('Constructs proper manual translation update map', () {
      final Map<String, dynamic> manualTranslations = {};
      
      final lang = 'es';
      final type = 'question';
      final id = 'q1';
      final field = 'label';
      final value = 'Nombre';

      if (!manualTranslations.containsKey(lang)) {
        manualTranslations[lang] = {};
      }
      
      final langData = Map<String, dynamic>.from(manualTranslations[lang]);
      if (!langData.containsKey(type)) {
        langData[type] = {};
      }
      
      final typeData = Map<String, dynamic>.from(langData[type]);
      if (!typeData.containsKey(id)) {
        typeData[id] = {};
      }
      
      final idData = Map<String, dynamic>.from(typeData[id]);
      idData[field] = value;
      typeData[id] = idData;
      langData[type] = typeData;
      
      manualTranslations[lang] = langData;

      expect(manualTranslations['es']['question']['q1']['label'], 'Nombre');
    });
  });
}
