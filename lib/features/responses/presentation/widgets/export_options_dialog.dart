import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../form_builder/domain/entities/builder_form.dart';
import '../../../form_builder/domain/entities/form_question.dart';

class ExportOptionsDialog extends StatefulWidget {
  final BuilderForm form;

  const ExportOptionsDialog({super.key, required this.form});

  @override
  State<ExportOptionsDialog> createState() => _ExportOptionsDialogState();
}

class _ExportOptionsDialogState extends State<ExportOptionsDialog> {
  String _selectedFormat = 'CSV';
  DateTimeRange? _selectedDateRange;
  final Set<String> _selectedFields = {};
  bool _includeMetadata = true;

  @override
  void initState() {
    super.initState();
    // Select all fields by default
    for (var section in widget.form.sections) {
      for (var question in section.questions) {
        _selectedFields.add(question.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.file_download_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Export Data',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 32),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('File Format'),
                    const SizedBox(height: 12),
                    _buildFormatSelector(),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Date Range (Optional)'),
                    const SizedBox(height: 12),
                    _buildDateRangePicker(),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Select Fields'),
                    const SizedBox(height: 12),
                    _buildFieldSelector(),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Additional Options'),
                    SwitchListTile(
                      title: const Text(
                        'Include Metadata (Timestamp, User, etc.)',
                      ),
                      value: _includeMetadata,
                      onChanged: (val) =>
                          setState(() => _includeMetadata = val),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'format': _selectedFormat,
                      'dateRange': _selectedDateRange,
                      'fields': _selectedFields.toList(),
                      'includeMetadata': _includeMetadata,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Export Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textGrey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFormatSelector() {
    final formats = ['CSV', 'Excel', 'JSON', 'PDF'];
    return Wrap(
      spacing: 12,
      children: formats.map((format) {
        final isSelected = _selectedFormat == format;
        return ChoiceChip(
          label: Text(format),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) setState(() => _selectedFormat = format);
          },
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangePicker() {
    return OutlinedButton.icon(
      onPressed: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: _selectedDateRange,
        );
        if (range != null) setState(() => _selectedDateRange = range);
      },
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Text(
        _selectedDateRange == null
            ? 'All Time'
            : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildFieldSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            title: const Text(
              'Select All Fields',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            value: _getAllQuestions().every(
              (q) => _selectedFields.contains(q.id),
            ),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  for (var q in _getAllQuestions()) {
                    _selectedFields.add(q.id);
                  }
                } else {
                  _selectedFields.clear();
                }
              });
            },
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getAllQuestions().length,
            itemBuilder: (context, index) {
              final question = _getAllQuestions()[index];
              return CheckboxListTile(
                title: Text(question.label?.toString() ?? 'Untitled Field'),
                subtitle: Text(
                  question.type.toString().split('.').last,
                  style: const TextStyle(fontSize: 12),
                ),
                value: _selectedFields.contains(question.id),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedFields.add(question.id);
                    } else {
                      _selectedFields.remove(question.id);
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<FormQuestion> _getAllQuestions() {
    final List<FormQuestion> all = [];
    for (var section in widget.form.sections) {
      all.addAll(section.questions);
    }
    return all;
  }
}
