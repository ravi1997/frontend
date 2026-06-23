import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class FormSubmissionSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormSubmissionSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormSubmissionSettings> createState() => _FormSubmissionSettingsState();
}

class _FormSubmissionSettingsState extends State<FormSubmissionSettings> {
  late TextEditingController _confirmationController;
  late TextEditingController _redirectController;
  late TextEditingController _draftExpiryController;
  late TextEditingController _draftCleanupController;

  Map<String, dynamic> get _settings => Map<String, dynamic>.from(
    widget.form['submission_settings'] ?? const {},
  );

  @override
  void initState() {
    super.initState();
    final settings = _settings;
    final draft = Map<String, dynamic>.from(
      settings['draft_handling'] ?? const {},
    );
    _confirmationController = TextEditingController(
      text: settings['confirmation_message']?.toString() ?? '',
    );
    _redirectController = TextEditingController(
      text: settings['redirect_url']?.toString() ?? '',
    );
    _draftExpiryController = TextEditingController(
      text:
          draft['expirationDays']?.toString() ??
          draft['expiration_days']?.toString() ??
          '',
    );
    _draftCleanupController = TextEditingController(
      text:
          draft['cleanupAfterDays']?.toString() ??
          draft['cleanup_after_days']?.toString() ??
          '',
    );
  }

  @override
  void didUpdateWidget(covariant FormSubmissionSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    final settings = _settings;
    final draft = Map<String, dynamic>.from(
      settings['draft_handling'] ?? const {},
    );
    _sync(
      _confirmationController,
      settings['confirmation_message']?.toString() ?? '',
    );
    _sync(_redirectController, settings['redirect_url']?.toString() ?? '');
    _sync(
      _draftExpiryController,
      draft['expirationDays']?.toString() ??
          draft['expiration_days']?.toString() ??
          '',
    );
    _sync(
      _draftCleanupController,
      draft['cleanupAfterDays']?.toString() ??
          draft['cleanup_after_days']?.toString() ??
          '',
    );
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    if (controller.value.text == value) return;
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    _redirectController.dispose();
    _draftExpiryController.dispose();
    _draftCleanupController.dispose();
    super.dispose();
  }

  void _emit(Map<String, dynamic> settings) {
    widget.onChanged({...widget.form, 'submission_settings': settings});
  }

  bool _isValidRedirectUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  String? _redirectValidator(String? value, bool enabled) {
    final trimmed = value?.trim() ?? '';
    if (!enabled) return null;
    if (trimmed.isEmpty) {
      return 'Redirect URL is required.';
    }
    if (!_isValidRedirectUrl(trimmed)) {
      return 'Enter a valid http(s) URL.';
    }
    return null;
  }

  String? _positiveIntValidator(String? value, {required bool required}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return required ? 'This field is required.' : null;
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 1) {
      return 'Enter a positive number.';
    }
    return null;
  }

  Map<String, dynamic> _draftSettings(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(
      settings['draft_handling'] ?? const {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    final redirectEnabled = settings['redirect_after_submit'] == true;
    final saveAndResume = settings['save_and_resume'] == true;
    final allowMultiple = settings['allow_multiple_submissions'] == true;
    final draft = _draftSettings(settings);
    final autoSave = draft['auto_save'] == true;
    final manualSave = draft['manual_save'] == true;
    final restoreMode = draft['restore_mode']?.toString() ?? 'token';

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submission Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Control confirmation, redirects, repeat submissions, and draft resume behavior.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildTextField(
              label: 'Confirmation message',
              placeholder: 'Your response has been saved.',
              controller: _confirmationController,
              maxLines: 3,
              onChanged: (val) =>
                  _emit({...settings, 'confirmation_message': val}),
            ),
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildSwitch(
              label: 'Redirect after submit',
              value: redirectEnabled,
              description: 'Send respondents to a different page after submit.',
              onChanged: (val) => _emit({
                ...settings,
                'redirect_after_submit': val,
                'redirect_url': val ? settings['redirect_url'] : null,
              }),
            ),
            if (redirectEnabled) ...[
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildTextField(
                label: 'Redirect URL',
                placeholder: 'https://example.com/thanks',
                validator: (value) => _redirectValidator(value, redirectEnabled),
                controller: _redirectController,
                key: const Key('submission-settings-redirect-url'),
                onChanged: (val) => _emit({
                  ...settings,
                  'redirect_after_submit': true,
                  'redirect_url': val,
                }),
              ),
            ],
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildSwitch(
              label: 'Allow multiple submissions',
              value: allowMultiple,
              description: 'Let the same respondent submit more than once.',
              onChanged: (val) =>
                  _emit({...settings, 'allow_multiple_submissions': val}),
            ),
            const SizedBox(height: 16),
            PropertyBuilderUtils.buildSwitch(
              label: 'Save and resume',
              value: saveAndResume,
              description: 'Allow long forms to be resumed later.',
              onChanged: (val) => _emit({
                ...settings,
                'save_and_resume': val,
                'draft_handling': val ? settings['draft_handling'] : null,
              }),
            ),
            if (saveAndResume) ...[
              const SizedBox(height: 16),
              const Text(
                'Draft handling',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              PropertyBuilderUtils.buildSwitch(
                label: 'Auto-save progress',
                value: autoSave,
                onChanged: (val) {
                  final next = _draftSettings(settings);
                  next['auto_save'] = val;
                  _emit({...settings, 'draft_handling': next});
                },
              ),
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildSwitch(
                label: 'Manual save',
                value: manualSave,
                onChanged: (val) {
                  final next = _draftSettings(settings);
                  next['manual_save'] = val;
                  _emit({...settings, 'draft_handling': next});
                },
              ),
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildTextField(
                label: 'Draft expiration (days)',
                controller: _draftExpiryController,
                keyboardType: TextInputType.number,
                key: const Key('submission-settings-draft-expiration-days'),
                validator: (value) =>
                    _positiveIntValidator(value, required: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  final next = _draftSettings(settings);
                  final parsed = int.tryParse(val);
                  next['expiration_days'] = parsed;
                  _emit({...settings, 'draft_handling': next});
                },
              ),
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildTextField(
                label: 'Draft cleanup (days)',
                controller: _draftCleanupController,
                keyboardType: TextInputType.number,
                key: const Key('submission-settings-draft-cleanup-days'),
                validator: (value) =>
                    _positiveIntValidator(value, required: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  final next = _draftSettings(settings);
                  final parsed = int.tryParse(val);
                  next['cleanup_after_days'] = parsed;
                  _emit({...settings, 'draft_handling': next});
                },
              ),
              const SizedBox(height: 12),
              PropertyBuilderUtils.buildDropdown<String>(
                label: 'Resume mode',
                value: restoreMode,
                items: const [
                  DropdownMenuItem(
                    value: 'token',
                    child: Text('Recovery token'),
                  ),
                  DropdownMenuItem(
                    value: 'login',
                    child: Text('Login required'),
                  ),
                  DropdownMenuItem(
                    value: 'session',
                    child: Text('Same session'),
                  ),
                ],
                onChanged: (val) {
                  if (val == null) return;
                  final next = _draftSettings(settings);
                  next['restore_mode'] = val;
                  _emit({...settings, 'draft_handling': next});
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
