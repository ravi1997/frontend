import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/networking/api_endpoints.dart';
import 'package:frontend/modules/forms/data/dto/form_dto.dart';
import 'package:frontend/modules/forms/data/mappers/form_mapper.dart';
import 'package:frontend/modules/forms/models/form_style.dart';
import 'package:frontend/shared/models/form_models.dart';

void main() {
  test('Form preserves submission and advanced settings in round trip', () {
    final form = Form.fromJson({
      'id': 'form-1',
      'title': 'Demo',
      'description': 'Demo description',
      'slug': 'demo-form',
      'submissionSettings': {
        'confirmation_message': 'Thanks',
        'redirect_after_submit': true,
        'redirect_url': 'https://example.com/thanks',
      },
      'dataExportSettings': {
        'csv_defaults': {'delimiter': ';', 'header_mode': 'keys'},
        'retention_days': 21,
        'field_mapping': {'ssn': 'Government ID'},
        'anonymization': {
          'mode': 'hash',
          'fields': ['ssn'],
        },
      },
      'advancedSettings': {
        'slug': 'demo-form',
        'internalCode': 'DEMO_01',
        'localeDefault': 'en-US',
        'fallbackLanguage': 'en',
        'apiIdentifiers': {'api': 'demo-api'},
        'experimentalFlags': {'history_lookup': true},
      },
      'style': {
        'accentColor': '#123456',
        'logoUrl': 'https://example.com/logo.png',
        'headerStyle': 'banner',
        'thankYouTheme': 'celebratory',
      },
    });

    expect(form.slug, 'demo-form');
    expect(form.description, 'Demo description');
    expect(form.submissionSettings['redirect_after_submit'], true);
    expect(form.dataExportSettings['retention_days'], 21);
    expect(form.advancedSettings['internalCode'], 'DEMO_01');
    expect(form.style['accentColor'], '#123456');

    final payload = FormMapper.toBackendJson(form);
    expect(payload['slug'], 'demo-form');
    expect(payload['description'], 'Demo description');
    expect(payload['submissionSettings'], isA<Map>());
    expect(payload['dataExportSettings'], isA<Map>());
    expect(payload['data_export_settings'], isA<Map>());
    expect(payload['advancedSettings'], isA<Map>());
    expect(payload['style'], isA<Map>());
  });

  test('FormMapper.fromDto preserves backend settings on load', () {
    final dto = FormDto.fromJson({
      'id': 'form-1',
      'title': 'Demo',
      'slug': 'demo-form',
      'description': 'Demo description',
      'submissionSettings': {
        'confirmation_message': 'Thanks',
        'redirect_after_submit': true,
        'redirect_url': 'https://example.com/thanks',
      },
      'dataExportSettings': {
        'csv_defaults': {'delimiter': ';', 'header_mode': 'keys'},
        'retention_days': 21,
        'field_mapping': {'ssn': 'Government ID'},
        'anonymization': {
          'mode': 'hash',
          'fields': ['ssn'],
        },
      },
      'advancedSettings': {
        'slug': 'demo-form',
        'internalCode': 'DEMO_01',
        'localeDefault': 'en-US',
        'fallbackLanguage': 'en',
        'apiIdentifiers': {'api': 'demo-api'},
        'experimentalFlags': {'history_lookup': true},
      },
      'style': {'accentColor': '#123456'},
      'versions': [
        {
          'version': '1.0',
          'sections': const [],
          'created_at': '2026-06-01T00:00:00Z',
        },
      ],
      'active_version': '1.0',
    });

    final form = FormMapper.fromDto(dto);

    expect(form.slug, 'demo-form');
    expect(form.description, 'Demo description');
    expect(form.submissionSettings['confirmation_message'], 'Thanks');
    expect(form.dataExportSettings['retention_days'], 21);
    expect(form.advancedSettings['internalCode'], 'DEMO_01');
    expect(form.style['accentColor'], '#123456');
  });

  test('FormStyle preserves branding keys', () {
    final style = FormStyle.fromJson({
      'backgroundColor': '#FFFFFF',
      'primaryColor': '#1976D2',
      'accentColor': '#00AAFF',
      'logoUrl': 'https://example.com/logo.png',
      'coverImageUrl': 'https://example.com/cover.png',
      'faviconUrl': 'https://example.com/favicon.ico',
      'headerStyle': 'banner',
      'thankYouTheme': 'calm',
    });

    final json = style.toJson();
    expect(json['accentColor'], '#00AAFF');
    expect(json['logoUrl'], 'https://example.com/logo.png');
    expect(json['coverImageUrl'], 'https://example.com/cover.png');
    expect(json['faviconUrl'], 'https://example.com/favicon.ico');
    expect(json['headerStyle'], 'banner');
    expect(json['thankYouTheme'], 'calm');
  });

  test('same-form lookup endpoint encodes parameters safely', () {
    final url = ApiEndpoints.sameFormLookup('form 1', 'patient id', 'A & B');

    expect(url, contains('/forms/form%201/fetch/same'));
    expect(url, contains('question_id=patient+id'));
    expect(url, contains('value=A+%26+B'));
  });
}
