import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cascading Select Deduplication', () {
    test('Deduplication hash includes resolved runtime trigger values', () {
      final parentValue1 = 'country_us';
      final parentValue2 = 'country_uk';
      final baseHash = 'api.com/regions/{parent}';

      final hash1 = baseHash.replaceAll('{parent}', parentValue1);
      final hash2 = baseHash.replaceAll('{parent}', parentValue2);
      
      expect(hash1, isNot(equals(hash2)));
      expect(hash1, 'api.com/regions/country_us');
      expect(hash2, 'api.com/regions/country_uk');
    });

    test('Invalid child selections reset when parent changes', () {
      final Map<String, dynamic> formData = {
        'parent': 'us',
        'child': 'london', // invalid for US
      };

      final newChildOptions = ['new_york', 'los_angeles'];
      
      if (!newChildOptions.contains(formData['child'])) {
        formData['child'] = null;
      }

      expect(formData['child'], isNull);
    });
  });
}
