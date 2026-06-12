import 'package:flutter/material.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class FormAdvancedSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormAdvancedSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormAdvancedSettings> createState() => _FormAdvancedSettingsState();
}

class _FormAdvancedSettingsState extends State<FormAdvancedSettings> {
  late TextEditingController _slugController;
  late TextEditingController _internalCodeController;
  late TextEditingController _localeController;
  late TextEditingController _fallbackController;
  late TextEditingController _apiIdController;
  late TextEditingController _webhookIdController;

  Map<String, dynamic> get _settings => Map<String, dynamic>.from(
    widget.form['advancedSettings'] ??
        widget.form['advanced_settings'] ??
        const {},
  );

  @override
  void initState() {
    super.initState();
    final settings = _settings;
    _slugController = TextEditingController(
      text:
          settings['slug']?.toString() ?? widget.form['slug']?.toString() ?? '',
    );
    _internalCodeController = TextEditingController(
      text:
          settings['internalCode']?.toString() ??
          settings['internal_code']?.toString() ??
          '',
    );
    _localeController = TextEditingController(
      text:
          settings['localeDefault']?.toString() ??
          settings['locale_default']?.toString() ??
          'en',
    );
    _fallbackController = TextEditingController(
      text:
          settings['fallbackLanguage']?.toString() ??
          settings['fallback_language']?.toString() ??
          'en',
    );
    final apiIds = Map<String, dynamic>.from(
      settings['apiIdentifiers'] ?? settings['api_identifiers'] ?? const {},
    );
    _apiIdController = TextEditingController(
      text: apiIds['api']?.toString() ?? '',
    );
    _webhookIdController = TextEditingController(
      text: apiIds['webhook']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant FormAdvancedSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    final settings = _settings;
    final apiIds = Map<String, dynamic>.from(
      settings['apiIdentifiers'] ?? settings['api_identifiers'] ?? const {},
    );
    _sync(
      _slugController,
      settings['slug']?.toString() ?? widget.form['slug']?.toString() ?? '',
    );
    _sync(
      _internalCodeController,
      settings['internalCode']?.toString() ??
          settings['internal_code']?.toString() ??
          '',
    );
    _sync(
      _localeController,
      settings['localeDefault']?.toString() ??
          settings['locale_default']?.toString() ??
          'en',
    );
    _sync(
      _fallbackController,
      settings['fallbackLanguage']?.toString() ??
          settings['fallback_language']?.toString() ??
          'en',
    );
    _sync(_apiIdController, apiIds['api']?.toString() ?? '');
    _sync(_webhookIdController, apiIds['webhook']?.toString() ?? '');
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  void dispose() {
    _slugController.dispose();
    _internalCodeController.dispose();
    _localeController.dispose();
    _fallbackController.dispose();
    _apiIdController.dispose();
    _webhookIdController.dispose();
    super.dispose();
  }

  void _emit(Map<String, dynamic> settings) {
    widget.onChanged({
      ...widget.form,
      'slug': settings['slug'],
      'advancedSettings': settings,
    });
  }

  Map<String, dynamic> _apiIdentifiers(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(
      settings['apiIdentifiers'] ?? settings['api_identifiers'] ?? const {},
    );
  }

  Map<String, dynamic> _experimentalFlags(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(
      settings['experimentalFlags'] ??
          settings['experimental_flags'] ??
          const {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    final experimentalFlags = _experimentalFlags(settings);
    final lookupEnabled = experimentalFlags['history_lookup'] == true;
    final betaEnabled = experimentalFlags['beta_builder'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Advanced', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Administrative settings for URLs, localization, integration keys, and feature flags.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildTextField(
          label: 'Form slug',
          placeholder: 'customer-onboarding',
          controller: _slugController,
          onChanged: (val) => _emit({...settings, 'slug': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Internal code',
          placeholder: 'ONB_2026',
          controller: _internalCodeController,
          onChanged: (val) => _emit({...settings, 'internalCode': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Default locale',
          placeholder: 'en',
          controller: _localeController,
          onChanged: (val) => _emit({...settings, 'localeDefault': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Fallback language',
          placeholder: 'en',
          controller: _fallbackController,
          onChanged: (val) => _emit({...settings, 'fallbackLanguage': val}),
        ),
        const SizedBox(height: 16),
        const Text(
          'API / webhook identifiers',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildTextField(
          label: 'API identifier',
          placeholder: 'form-api',
          controller: _apiIdController,
          onChanged: (val) {
            final identifiers = _apiIdentifiers(settings);
            identifiers['api'] = val;
            _emit({...settings, 'apiIdentifiers': identifiers});
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Webhook identifier',
          placeholder: 'form-webhook',
          controller: _webhookIdController,
          onChanged: (val) {
            final identifiers = _apiIdentifiers(settings);
            identifiers['webhook'] = val;
            _emit({...settings, 'apiIdentifiers': identifiers});
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Experimental flags',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        PropertyBuilderUtils.buildSwitch(
          label: 'History lookup experiments',
          value: lookupEnabled,
          description: 'Enables the history lookup action button UI.',
          onChanged: (val) {
            final flags = _experimentalFlags(settings);
            flags['history_lookup'] = val;
            _emit({...settings, 'experimentalFlags': flags});
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildSwitch(
          label: 'Beta builder experiments',
          value: betaEnabled,
          description: 'Gate experimental admin-only builder behavior.',
          onChanged: (val) {
            final flags = _experimentalFlags(settings);
            flags['beta_builder'] = val;
            _emit({...settings, 'experimentalFlags': flags});
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Text(
            'Public URL preview: /forms/${_slugController.text.isEmpty ? '(slug)' : _slugController.text}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
