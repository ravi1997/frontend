import 'package:flutter/material.dart';

class FormGeneralSettings extends StatelessWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormGeneralSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: form['title'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Form Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => onChanged({...form, 'title': value}),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: form['description'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => onChanged({...form, 'description': value}),
        ),
      ],
    );
  }
}

class SectionGeneralSettings extends StatefulWidget {
  final Map<String, dynamic> section;
  final Function(Map<String, dynamic>) onChanged;

  const SectionGeneralSettings({
    super.key,
    required this.section,
    required this.onChanged,
  });

  @override
  State<SectionGeneralSettings> createState() => _SectionGeneralSettingsState();
}

class _SectionGeneralSettingsState extends State<SectionGeneralSettings> {
  late List<String> _tags;
  late TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _tags = _readTags(widget.section['tags']);
    _tagController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant SectionGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section['id'] != widget.section['id']) {
      _tags = _readTags(widget.section['tags']);
      _tagController.clear();
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  List<String> _readTags(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }

  void _commitTag(String raw) {
    final incoming = raw
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty && !_tags.contains(t))
        .toList();
    if (incoming.isEmpty) return;
    setState(() => _tags.addAll(incoming));
    _tagController.clear();
    _emit();
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    _emit();
  }

  void _emit() {
    widget.onChanged({...widget.section, 'tags': List<String>.from(_tags)});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['title']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Section Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'title': value,
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['description']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'description': value,
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['help_text']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Help text',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'help_text': value,
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['order']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Order',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'order': int.tryParse(value),
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['id']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Internal key / slug',
            helperText: 'Unique identifier used for logic and API references.',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'id': value,
          }),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.section['short_label']?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Short label',
            helperText: 'Shown in stepper indicators and breadcrumbs.',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => widget.onChanged({
            ...widget.section,
            'short_label': value,
          }),
        ),
        const SizedBox(height: 16),
        if (_tags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => _removeTag(tag),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _tagController,
          decoration: InputDecoration(
            labelText: 'Add tag',
            hintText: 'Type and press Enter',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _commitTag(_tagController.text),
            ),
          ),
          onFieldSubmitted: _commitTag,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: const ['personal', 'billing', 'contact', 'survey', 'feedback', 'security']
              .where((t) => !_tags.contains(t))
              .map((tag) => ActionChip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    onPressed: () => _commitTag(tag),
                    visualDensity: VisualDensity.compact,
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'BEHAVIOR',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Allow Collapsing'),
          subtitle: const Text('Allow users to expand or collapse this section.'),
          value: widget.section['metadata']?['allowCollapsing'] ?? true,
          onChanged: (val) {
            final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
            metadata['allowCollapsing'] = val;
            widget.onChanged({...widget.section, 'metadata': metadata});
          },
        ),
        if (widget.section['metadata']?['allowCollapsing'] ?? true) ...[
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start Collapsed'),
            subtitle: const Text('Render the section collapsed by default.'),
            value: widget.section['metadata']?['startCollapsed'] ?? false,
            onChanged: (val) {
              final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
              metadata['startCollapsed'] = val;
              widget.onChanged({...widget.section, 'metadata': metadata});
            },
          ),
        ],
        const SizedBox(height: 20),
        _buildIconPicker(),
      ],
    );
  }

  Widget _buildIconPicker() {
    final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
    final currentIcon = metadata['icon'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Section Icon',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showIconPickerDialog(currentIcon),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentIcon != null && currentIcon.isNotEmpty) ...[
                  _getIconWidget(currentIcon),
                  const SizedBox(width: 8),
                  Text(
                    currentIcon.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ] else
                  const Text(
                    'Select Icon',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getIconWidget(String iconName) {
    final IconData iconData;
    switch (iconName.toLowerCase()) {
      case 'info':
        iconData = Icons.info_outline;
        break;
      case 'person':
        iconData = Icons.person_outline;
        break;
      case 'location':
        iconData = Icons.location_on_outlined;
        break;
      case 'payment':
        iconData = Icons.payment;
        break;
      case 'contact':
        iconData = Icons.contact_mail_outlined;
        break;
      case 'settings':
        iconData = Icons.settings_outlined;
        break;
      case 'list':
        iconData = Icons.list_alt;
        break;
      case 'star':
        iconData = Icons.star_outline;
        break;
      case 'home':
        iconData = Icons.home_outlined;
        break;
      case 'work':
        iconData = Icons.work_outline;
        break;
      default:
        iconData = Icons.help_outline;
    }
    return Icon(iconData, color: Theme.of(context).primaryColor);
  }

  void _showIconPickerDialog(String? currentIcon) {
    final Map<String, IconData> icons = {
      'info': Icons.info_outline,
      'person': Icons.person_outline,
      'location': Icons.location_on_outlined,
      'payment': Icons.payment,
      'contact': Icons.contact_mail_outlined,
      'settings': Icons.settings_outlined,
      'list': Icons.list_alt,
      'star': Icons.star_outline,
      'home': Icons.home_outlined,
      'work': Icons.work_outline,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Section Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            children: icons.entries
                .map(
                  (e) => IconButton(
                    icon: Icon(e.value),
                    onPressed: () {
                      final metadata = Map<String, dynamic>.from(widget.section['metadata'] ?? const {});
                      metadata['icon'] = e.key;
                      widget.onChanged({...widget.section, 'metadata': metadata});
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
