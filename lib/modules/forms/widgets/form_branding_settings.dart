import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class FormBrandingSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FormBrandingSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormBrandingSettings> createState() => _FormBrandingSettingsState();
}

class _FormBrandingSettingsState extends State<FormBrandingSettings> {
  late TextEditingController _logoController;
  late TextEditingController _coverController;
  late TextEditingController _faviconController;

  Map<String, dynamic> get _style =>
      Map<String, dynamic>.from(widget.form['style'] ?? const {});

  @override
  void initState() {
    super.initState();
    _logoController = TextEditingController(
      text: _style['logoUrl']?.toString() ?? '',
    );
    _coverController = TextEditingController(
      text: _style['coverImageUrl']?.toString() ?? '',
    );
    _faviconController = TextEditingController(
      text: _style['faviconUrl']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant FormBrandingSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(_logoController, _style['logoUrl']?.toString() ?? '');
    _sync(_coverController, _style['coverImageUrl']?.toString() ?? '');
    _sync(_faviconController, _style['faviconUrl']?.toString() ?? '');
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
    _logoController.dispose();
    _coverController.dispose();
    _faviconController.dispose();
    super.dispose();
  }

  void _emit(Map<String, dynamic> style) {
    widget.onChanged({...widget.form, 'style': style});
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final accentColor =
        style['accentColor']?.toString() ??
        style['primaryColor']?.toString() ??
        '#1976D2';
    final headerStyle = style['headerStyle']?.toString() ?? 'default';
    final thankYouTheme = style['thankYouTheme']?.toString() ?? 'default';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: DesignTokens.spaceM),
        const Text('Branding', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: DesignTokens.spaceS),
        PropertyBuilderUtils.buildTextField(
          label: 'Logo URL',
          placeholder: 'https://...',
          controller: _logoController,
          onChanged: (val) => _emit({...style, 'logoUrl': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Cover image URL',
          placeholder: 'https://...',
          controller: _coverController,
          onChanged: (val) => _emit({...style, 'coverImageUrl': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildTextField(
          label: 'Favicon URL',
          placeholder: 'https://...',
          controller: _faviconController,
          onChanged: (val) => _emit({...style, 'faviconUrl': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildColorPicker(
          label: 'Accent color',
          value: accentColor,
          onChanged: (val) => _emit({...style, 'accentColor': val}),
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Header style',
          value: headerStyle,
          items: const [
            DropdownMenuItem(value: 'default', child: Text('Default')),
            DropdownMenuItem(value: 'compact', child: Text('Compact')),
            DropdownMenuItem(value: 'banner', child: Text('Banner')),
          ],
          onChanged: (val) {
            if (val == null) return;
            _emit({...style, 'headerStyle': val});
          },
        ),
        const SizedBox(height: 12),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Thank-you screen theme',
          value: thankYouTheme,
          items: const [
            DropdownMenuItem(value: 'default', child: Text('Default')),
            DropdownMenuItem(value: 'calm', child: Text('Calm')),
            DropdownMenuItem(value: 'celebratory', child: Text('Celebratory')),
          ],
          onChanged: (val) {
            if (val == null) return;
            _emit({...style, 'thankYouTheme': val});
          },
        ),
      ],
    );
  }
}
