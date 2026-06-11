import 'package:flutter/material.dart';

class SectionVisibilitySettings extends StatelessWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionVisibilitySettings({
    super.key,
    required this.section,
    required this.onChanged,
  });

  Map<String, dynamic> get _metadata =>
      Map<String, dynamic>.from(section['metadata'] ?? const {});

  void _onEnvironmentChanged(String? val) {
    if (val == null) return;
    onChanged({
      ...section,
      'metadata': {
        ..._metadata,
        'showOnlyInPreview': val == 'preview_only',
        'showOnlyInPublished': val == 'published_only',
      },
    });
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadata = _metadata;
    final showOnMobile = metadata['showOnMobile'] as bool? ?? true;
    final showOnTablet = metadata['showOnTablet'] as bool? ?? true;
    final showOnDesktop = metadata['showOnDesktop'] as bool? ?? true;
    final isPreviewOnly = metadata['showOnlyInPreview'] == true;
    final isPublishedOnly = metadata['showOnlyInPublished'] == true;
    final environment = isPreviewOnly
        ? 'preview_only'
        : isPublishedOnly
            ? 'published_only'
            : 'all';

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visibility', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _switchTile(
          title: 'Show on mobile',
          value: showOnMobile,
          onChanged: (val) => onChanged({
            ...section,
            'metadata': {...metadata, 'showOnMobile': val},
          }),
        ),
        _switchTile(
          title: 'Show on tablet',
          value: showOnTablet,
          onChanged: (val) => onChanged({
            ...section,
            'metadata': {...metadata, 'showOnTablet': val},
          }),
        ),
        _switchTile(
          title: 'Show on desktop',
          value: showOnDesktop,
          onChanged: (val) => onChanged({
            ...section,
            'metadata': {...metadata, 'showOnDesktop': val},
          }),
        ),
        const SizedBox(height: 16),
        Text('Environment', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        RadioGroup<String>(
          groupValue: environment,
          onChanged: _onEnvironmentChanged,
          child: Column(
            children: [
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('All environments'),
                subtitle: const Text('Visible in preview and published form'),
                value: 'all',
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Preview only'),
                subtitle: const Text('Hidden when the form is published'),
                value: 'preview_only',
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Published only'),
                subtitle: const Text('Hidden during preview'),
                value: 'published_only',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
