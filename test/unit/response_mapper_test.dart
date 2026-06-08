import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/responses/data/mappers/response_mapper.dart';

void main() {
  group('ResponseMapper', () {
    test('Prunes hidden fields correctly', () {
      final flatAnswers = {
        'field1': 'value1',
        'field2': 'value2',
        'field3': 'value3',
      };
      
      final visibilityMap = {
        'field1': true,
        'field2': false, // Hidden
        'field3': true,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);

      expect(result.containsKey('field1'), isTrue);
      expect(result.containsKey('field2'), isFalse);
      expect(result.containsKey('field3'), isTrue);
    });

    test('Maps repeatable sections correctly', () {
      final flatAnswers = {
        'section1[0].name': 'John',
        'section1[0].age': '30',
        'section1[1].name': 'Jane',
        'section1[1].age': '25',
      };

      final visibilityMap = {
        'section1': true,
        'name': true,
        'age': true,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);

      expect(result['section1'], isA<List>());
      expect(result['section1'].length, 2);
      expect(result['section1'][0]['name'], 'John');
      expect(result['section1'][1]['age'], '25');
    });

    test('Prunes deleted repeat instances based on repeatInstances map', () {
      final flatAnswers = {
        'section1[0].name': 'John',
        'section1[1].name': 'Jane', // Was deleted
      };

      final visibilityMap = {
        'section1': true,
        'name': true,
      };

      final repeatInstances = {
        'section1': 1, // Only 1 instance remains
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap, repeatInstances: repeatInstances);

      expect(result['section1'].length, 1);
      expect(result['section1'][0]['name'], 'John');
    });

    test('Maps list of primitives and handles null/empty/primitives without crashing', () {
      final flatAnswers = {
        'tags[0]': 123,
        'tags[1]': null,
        'tags[2]': 'second',
      };

      final visibilityMap = {
        'tags': true,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);
      expect(result['tags'], equals([123, null, 'second']));
    });
  });
}
