import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';
import 'package:frontend/modules/forms/services/form_builder_repository.dart';

class FormAdvancedSettings extends ConsumerStatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormAdvancedSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  ConsumerState<FormAdvancedSettings> createState() =>
      _FormAdvancedSettingsState();
}

class _FormAdvancedSettingsState extends ConsumerState<FormAdvancedSettings> {
  late TextEditingController _slugController;
  late TextEditingController _internalCodeController;
  late TextEditingController _localeController;
  late TextEditingController _fallbackController;
  late TextEditingController _apiIdController;
  late TextEditingController _webhookIdController;
  String? _slugAvailabilityMessage;
  bool? _slugAvailable;
  bool _checkingSlug = false;
  int _slugValidationEpoch = 0;

  Map<String, dynamic> get _settings => Map<String, dynamic>.from(
    widget.form['advanced_settings'] ?? const {},
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
          settings['internal_code']?.toString() ??
          '',
    );
    _localeController = TextEditingController(
      text:
          settings['locale_default']?.toString() ??
          'en',
    );
    _fallbackController = TextEditingController(
      text:
          settings['fallback_language']?.toString() ??
          'en',
    );
    final apiIds = Map<String, dynamic>.from(
      settings['api_identifiers'] ?? const {},
    );
    _apiIdController = TextEditingController(
      text: apiIds['api']?.toString() ?? '',
    );
    _webhookIdController = TextEditingController(
      text: apiIds['webhook']?.toString() ?? '',
    );
    _scheduleSlugValidation(_slugController.text);
  }

  @override
  void didUpdateWidget(covariant FormAdvancedSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    final settings = _settings;
    final apiIds = Map<String, dynamic>.from(
      settings['api_identifiers'] ?? const {},
    );
    _sync(
      _slugController,
      settings['slug']?.toString() ?? widget.form['slug']?.toString() ?? '',
    );
    _sync(
      _internalCodeController,
      settings['internal_code']?.toString() ?? '',
    );
    _sync(
      _localeController,
      settings['locale_default']?.toString() ?? 'en',
    );
    _sync(
      _fallbackController,
      settings['fallback_language']?.toString() ?? 'en',
    );
    _sync(_apiIdController, apiIds['api']?.toString() ?? '');
    _sync(_webhookIdController, apiIds['webhook']?.toString() ?? '');
    if (oldWidget.form['slug']?.toString() != widget.form['slug']?.toString()) {
      _scheduleSlugValidation(_slugController.text);
    }
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

  bool _isSlugFormatValid(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return false;
    return RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(normalized);
  }

  Future<void> _scheduleSlugValidation(String value) async {
    final trimmed = value.trim();
    final validationEpoch = ++_slugValidationEpoch;
    if (trimmed.isEmpty) {
      if (!mounted) return;
      setState(() {
        _checkingSlug = false;
        _slugAvailable = null;
        _slugAvailabilityMessage = null;
      });
      return;
    }
    if (!_isSlugFormatValid(trimmed)) {
      if (!mounted) return;
      setState(() {
        _checkingSlug = false;
        _slugAvailable = false;
        _slugAvailabilityMessage =
            'Use lowercase letters, numbers, and hyphens only.';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _checkingSlug = true;
      _slugAvailabilityMessage = 'Checking slug availability...';
      _slugAvailable = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted || validationEpoch != _slugValidationEpoch) return;

    final repository = ref.read(formBuilderRepositoryProvider);
    final available = await repository.isSlugAvailable(
      trimmed,
      formId: widget.form['id']?.toString(),
    );

    if (!mounted || validationEpoch != _slugValidationEpoch) return;
    setState(() {
      _checkingSlug = false;
      _slugAvailable = available;
      _slugAvailabilityMessage = available
          ? 'Slug is available.'
          : 'Slug is already in use or reserved.';
    });
  }

  void _emit(Map<String, dynamic> settings) {
    widget.onChanged({
      ...widget.form,
      'slug': settings['slug'],
      'advanced_settings': settings,
    });
  }

  Map<String, dynamic> _apiIdentifiers(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(
      settings['api_identifiers'] ?? const {},
    );
  }

  Map<String, dynamic> _experimentalFlags(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(
      settings['experimental_flags'] ?? const {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    final experimentalFlags = _experimentalFlags(settings);
    final lookupEnabled = experimentalFlags['history_lookup'] == true;
    final betaEnabled = experimentalFlags['beta_builder'] == true;
    final slugStatusColor = _slugAvailable == true
        ? Theme.of(context).colorScheme.primary
        : _slugAvailable == false
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return SingleChildScrollView(
      child: Column(
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
            key: const Key('advanced-form-slug'),
            onChanged: (val) {
              _emit({...settings, 'slug': val});
              _scheduleSlugValidation(val);
            },
            validator: (_) {
              if (_checkingSlug) return null;
              return _slugAvailabilityMessage == null ||
                      _slugAvailable == true
                  ? null
                  : _slugAvailabilityMessage;
            },
          ),
          if (_slugAvailabilityMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              _slugAvailabilityMessage!,
              style: TextStyle(
                color: slugStatusColor,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildTextField(
            label: 'Internal code',
            placeholder: 'ONB_2026',
            controller: _internalCodeController,
            onChanged: (val) => _emit({...settings, 'internal_code': val}),
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildTextField(
            label: 'Default locale',
            placeholder: 'en',
            controller: _localeController,
            onChanged: (val) => _emit({...settings, 'locale_default': val}),
          ),
          const SizedBox(height: 12),
          PropertyBuilderUtils.buildTextField(
            label: 'Fallback language',
            placeholder: 'en',
            controller: _fallbackController,
            onChanged: (val) => _emit({...settings, 'fallback_language': val}),
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
              _emit({...settings, 'api_identifiers': identifiers});
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
              _emit({...settings, 'api_identifiers': identifiers});
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
              _emit({...settings, 'experimental_flags': flags});
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
              _emit({...settings, 'experimental_flags': flags});
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
      ),
    );
  }
}
