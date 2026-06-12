import 'package:flutter/material.dart';

class FormGeneralSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final Function(Map<String, dynamic>) onChanged;

  const FormGeneralSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormGeneralSettings> createState() => _FormGeneralSettingsState();
}

class _FormGeneralSettingsState extends State<FormGeneralSettings> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.form['title']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.form['description']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant FormGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(
      _titleController,
      widget.form['title']?.toString() ?? '',
      _titleFocusNode,
    );
    _syncController(
      _descriptionController,
      widget.form['description']?.toString() ?? '',
      _descriptionFocusNode,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _syncController(
    TextEditingController controller,
    String next,
    FocusNode focusNode,
  ) {
    if (focusNode.hasFocus) return;
    if (controller.text == next) return;
    controller.text = next;
  }

  void _selectAll(TextEditingController controller) {
    Future.delayed(Duration.zero, () {
      if (controller.text.isNotEmpty) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_titleController);
          },
          child: TextFormField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            decoration: const InputDecoration(
              labelText: 'Form Title',
              border: OutlineInputBorder(),
            ),
            onTap: () => _selectAll(_titleController),
            onChanged: (value) => widget.onChanged({...widget.form, 'title': value}),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_descriptionController);
          },
          child: TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onTap: () => _selectAll(_descriptionController),
            onChanged: (value) => widget.onChanged({...widget.form, 'description': value}),
          ),
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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _helpTextController;
  late TextEditingController _orderController;
  late TextEditingController _idController;
  late TextEditingController _shortLabelController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _helpTextFocusNode = FocusNode();
  final FocusNode _orderFocusNode = FocusNode();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _shortLabelFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tags = _readTags(widget.section['tags']);
    _tagController = TextEditingController();
    _titleController = TextEditingController(
      text: widget.section['title']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.section['description']?.toString() ?? '',
    );
    _helpTextController = TextEditingController(
      text: widget.section['help_text']?.toString() ?? '',
    );
    _orderController = TextEditingController(
      text: widget.section['order']?.toString() ?? '',
    );
    _idController = TextEditingController(
      text: widget.section['id']?.toString() ?? '',
    );
    _shortLabelController = TextEditingController(
      text: widget.section['short_label']?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant SectionGeneralSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section['id'] != widget.section['id']) {
      _tags = _readTags(widget.section['tags']);
      _tagController.clear();
    }
    _syncController(
      _titleController,
      widget.section['title']?.toString() ?? '',
      _titleFocusNode,
    );
    _syncController(
      _descriptionController,
      widget.section['description']?.toString() ?? '',
      _descriptionFocusNode,
    );
    _syncController(
      _helpTextController,
      widget.section['help_text']?.toString() ?? '',
      _helpTextFocusNode,
    );
    _syncController(
      _orderController,
      widget.section['order']?.toString() ?? '',
      _orderFocusNode,
    );
    _syncController(
      _idController,
      widget.section['id']?.toString() ?? '',
      _idFocusNode,
    );
    _syncController(
      _shortLabelController,
      widget.section['short_label']?.toString() ?? '',
      _shortLabelFocusNode,
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _helpTextController.dispose();
    _orderController.dispose();
    _idController.dispose();
    _shortLabelController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _helpTextFocusNode.dispose();
    _orderFocusNode.dispose();
    _idFocusNode.dispose();
    _shortLabelFocusNode.dispose();
    super.dispose();
  }

  void _syncController(
    TextEditingController controller,
    String next,
    FocusNode focusNode,
  ) {
    if (focusNode.hasFocus) return;
    if (controller.text == next) return;
    controller.text = next;
  }

  void _selectAll(TextEditingController controller) {
    Future.delayed(Duration.zero, () {
      if (controller.text.isNotEmpty) {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
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
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_titleController);
          },
          child: TextFormField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            decoration: const InputDecoration(
              labelText: 'Section Title',
              border: OutlineInputBorder(),
            ),
            onTap: () => _selectAll(_titleController),
            onChanged: (value) =>
                widget.onChanged({...widget.section, 'title': value}),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_descriptionController);
          },
          child: TextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onTap: () => _selectAll(_descriptionController),
            onChanged: (value) =>
                widget.onChanged({...widget.section, 'description': value}),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_helpTextController);
          },
          child: TextFormField(
            controller: _helpTextController,
            focusNode: _helpTextFocusNode,
            decoration: const InputDecoration(
              labelText: 'Help text',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            onTap: () => _selectAll(_helpTextController),
            onChanged: (value) =>
                widget.onChanged({...widget.section, 'help_text': value}),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_orderController);
          },
          child: TextFormField(
            controller: _orderController,
            focusNode: _orderFocusNode,
            decoration: const InputDecoration(
              labelText: 'Order',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onTap: () => _selectAll(_orderController),
            onChanged: (value) => widget.onChanged({
              ...widget.section,
              'order': int.tryParse(value),
            }),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_idController);
          },
          child: TextFormField(
            controller: _idController,
            focusNode: _idFocusNode,
            decoration: const InputDecoration(
              labelText: 'Internal key / slug',
              helperText: 'Unique identifier used for logic and API references.',
              border: OutlineInputBorder(),
            ),
            onTap: () => _selectAll(_idController),
            onChanged: (value) =>
                widget.onChanged({...widget.section, 'id': value}),
          ),
        ),
        const SizedBox(height: 16),
        Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) _selectAll(_shortLabelController);
          },
          child: TextFormField(
            controller: _shortLabelController,
            focusNode: _shortLabelFocusNode,
            decoration: const InputDecoration(
              labelText: 'Short label',
              helperText: 'Shown in stepper indicators and breadcrumbs.',
              border: OutlineInputBorder(),
            ),
            onTap: () => _selectAll(_shortLabelController),
            onChanged: (value) =>
                widget.onChanged({...widget.section, 'short_label': value}),
          ),
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
          children:
              const [
                    'personal',
                    'billing',
                    'contact',
                    'survey',
                    'feedback',
                    'security',
                  ]
                  .where((t) => !_tags.contains(t))
                  .map(
                    (tag) => ActionChip(
                      label: Text(tag, style: const TextStyle(fontSize: 12)),
                      onPressed: () => _commitTag(tag),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
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
          subtitle: const Text(
            'Allow users to expand or collapse this section.',
          ),
          value: widget.section['metadata']?['allowCollapsing'] ?? true,
          onChanged: (val) {
            final metadata = Map<String, dynamic>.from(
              widget.section['metadata'] ?? const {},
            );
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
              final metadata = Map<String, dynamic>.from(
                widget.section['metadata'] ?? const {},
              );
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
    final metadata = Map<String, dynamic>.from(
      widget.section['metadata'] ?? const {},
    );
    final currentIcon = metadata['icon'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Section Icon',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                      final metadata = Map<String, dynamic>.from(
                        widget.section['metadata'] ?? const {},
                      );
                      metadata['icon'] = e.key;
                      widget.onChanged({
                        ...widget.section,
                        'metadata': metadata,
                      });
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
