import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/responses/data/mappers/response_mapper.dart';

void main() {
  group('ResponseMapper', () {
    test('should prune hidden fields', () {
      final flatAnswers = {
        'field1': 'value1',
        'field2': 'value2',
      };
      final visibilityMap = {
        'field1': true,
        'field2': false,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);

      expect(result.containsKey('field1'), isTrue);
      expect(result.containsKey('field2'), isFalse);
      expect(result['field1'], equals('value1'));
    });

    test('should transform flat repeat keys to nested structure', () {
      final flatAnswers = {
        'members[0].name': 'John',
        'members[0].age': 30,
        'members[1].name': 'Jane',
        'members[1].age': 25,
        'other_field': 'hello',
      };
      final visibilityMap = {
        'members': true,
        'name': true,
        'age': true,
        'other_field': true,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);

      expect(result['other_field'], equals('hello'));
      expect(result['members'], isA<List>());
      final members = result['members'] as List;
      expect(members.length, equals(2));
      expect(members[0]['name'], equals('John'));
      expect(members[0]['age'], equals(30));
      expect(members[1]['name'], equals('Jane'));
      expect(members[1]['age'], equals(25));
    });

    test('should prune hidden repeat sections', () {
      final flatAnswers = {
        'members[0].name': 'John',
        'other': 'data',
      };
      final visibilityMap = {
        'members': false,
        'other': true,
      };

      final result = ResponseMapper.toBackendPayload(flatAnswers, visibilityMap);

      expect(result.containsKey('members'), isFalse);
      expect(result['other'], equals('data'));
    });
  });
}
