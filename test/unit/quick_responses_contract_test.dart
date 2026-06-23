import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/forms/data/dto/form_dto.dart';
import 'package:frontend/modules/forms/data/mappers/form_mapper.dart';
import 'package:frontend/modules/forms/utility/quick_response_utils.dart';

void main() {
  test('mergeQuickResponses preserves manual edits and fills missing fields', () {
    final result = mergeQuickResponses(
      quickResponses: [
        {
          'name': 'Patient preset',
          'field_values': {
            'patient_id': 'P-1001',
            'email': 'preset@example.com',
          },
        },
        {
          'name': 'Follow-up preset',
          'field_values': {'phone': '555-1010'},
        },
      ],
      currentValues: {'email': 'manual@example.com'},
    );

    expect(result.conflictingFields, isEmpty);
    expect(result.mergedValues['patient_id'], 'P-1001');
    expect(result.mergedValues['phone'], '555-1010');
    expect(result.mergedValues['email'], 'manual@example.com');
  });

  test('mergeQuickResponses reports conflicting fields without overwriting', () {
    final result = mergeQuickResponses(
      quickResponses: [
        {
          'name': 'Preset A',
          'field_values': {'patient_id': 'P-1001'},
        },
        {
          'name': 'Preset B',
          'field_values': {'patient_id': 'P-2002'},
        },
      ],
      currentValues: const {},
    );

    expect(result.conflictingFields, contains('patient_id'));
    expect(result.mergedValues['patient_id'], isNull);
  });

  test('FormDto and FormMapper preserve quick response presets', () {
    final dto = FormDto.fromJson({
      'id': 'form-1',
      'title': 'Quick responses',
      'status': 'draft',
      'versions': [
        {
          'version': '1.0',
          'sections': const [],
          'quick_responses': const [],
        },
      ],
      'quick_responses': [
        {
          'name': 'Patient preset',
          'description': 'Fill intake fields',
          'tags': ['patient', 'intake'],
          'visibility': 'project',
          'ownerId': 'user-1',
          'fieldValues': {'patient_id': 'P-1001'},
          'isArchived': false,
        },
      ],
    });

    final form = FormMapper.fromDto(dto);
    expect(form.quickResponses, hasLength(1));
    expect(form.quickResponses.first['name'], 'Patient preset');
    expect(form.quickResponses.first['field_values']['patient_id'], 'P-1001');

    final payload = FormMapper.toBackendJson(form);
    expect(payload['quick_responses'], hasLength(1));
    expect(
      (payload['versions'] as List).first['quick_responses'],
      hasLength(1),
    );
  });
}
