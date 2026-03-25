import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/analysis_dashboard.dart';
import '../controllers/analysis_builder_controller.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';

class AnalysisPropertiesPanel extends ConsumerWidget {
  final String? dashboardId;

  const AnalysisPropertiesPanel({super.key, this.dashboardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(
      analysisBuilderControllerProvider(dashboardId),
    );
    final selectedWidgetId = builderState.selectedWidgetId;

    if (selectedWidgetId == null) {
      return _buildEmptyState();
    }

    final widget = builderState.dashboard.widgets.firstWhere(
      (w) => w.id == selectedWidgetId,
    );

    // Fetch forms
    final formsAsync = ref.watch(dashboardControllerProvider);
    final formItems = formsAsync.maybeWhen(
      data: (data) => data.recentForms.map((f) => f.id).toList(),
      orElse: () => <String>[],
    );
    final formLabels = formsAsync.maybeWhen(
      data: (data) =>
          Map.fromEntries(data.recentForms.map((f) => MapEntry(f.id, f.title))),
      orElse: () => <String, String>{},
    );

    // Fetch fields if form selected
    final fields = widget.formId != null
        ? ref
              .watch(formFieldsProvider(widget.formId!))
              .maybeWhen(data: (data) => data, orElse: () => <String>[])
        : <String>[];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref, widget),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('General Settings'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Widget Title',
                    value: widget.title,
                    onChanged: (val) =>
                        _updateWidget(ref, widget.copyWith(title: val)),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Data & Source'),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Source Form',
                    value: widget.formId,
                    items: formItems,
                    itemLabel: (id) => formLabels[id] ?? id,
                    onChanged: (val) =>
                        _updateWidget(ref, widget.copyWith(formId: val)),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Configuration'),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Group By Field',
                    value: widget.groupByField,
                    items: ['Submission Date', 'Completion Status', ...fields],
                    onChanged: (val) =>
                        _updateWidget(ref, widget.copyWith(groupByField: val)),
                  ),
                  const SizedBox(height: 16),
                  if (widget.type != 'kpi') ...[
                    _buildDropdown(
                      label: 'Aggregate Field',
                      value: widget.aggregateField,
                      items: ['Response Count', ...fields],
                      onChanged: (val) => _updateWidget(
                        ref,
                        widget.copyWith(aggregateField: val),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildDropdown(
                    label: 'Calculation Method',
                    value: widget.calculationType,
                    items: ['count', 'sum', 'average', 'min', 'max'],
                    onChanged: (val) => _updateWidget(
                      ref,
                      widget.copyWith(calculationType: val ?? 'count'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(
                      'Enable Cross-filtering',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      'Interacting with this widget filters others',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: true,
                    onChanged: (val) {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Layout & Style'),
                  const SizedBox(height: 16),
                  _buildSizeAdjuster(ref, widget),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Color Palette',
                    value: widget.colorScheme,
                    items: ['ocean', 'sunset', 'monochrome', 'vibrant'],
                    onChanged: (val) => _updateWidget(
                      ref,
                      widget.copyWith(colorScheme: val ?? 'ocean'),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 48,
            color: AppColors.borderLight,
          ),
          SizedBox(height: 16),
          Text(
            'Select a component on the canvas to configure its properties',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AnalysisWidget widget,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.settings,
              size: 16,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Widget Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFFEF4444),
              size: 20,
            ),
            tooltip: 'Remove Widget',
            onPressed: () => ref
                .read(analysisBuilderControllerProvider(dashboardId).notifier)
                .removeWidget(widget.id),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: Color(0xFF6B7280),
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String Function(String)? itemLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    itemLabel?.call(i) ?? i,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          isDense: true,
          icon: const Icon(
            Icons.expand_more,
            color: Color(0xFF6B7280),
            size: 18,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeAdjuster(WidgetRef ref, AnalysisWidget widget) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            label: 'Grid Width',
            value: widget.width.toString(),
            onChanged: (val) {
              final valInt = int.tryParse(val) ?? 2;
              _updateWidget(ref, widget.copyWith(width: valInt));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            label: 'Grid Height',
            value: widget.height.toString(),
            onChanged: (val) {
              final valInt = int.tryParse(val) ?? 2;
              _updateWidget(ref, widget.copyWith(height: valInt));
            },
          ),
        ),
      ],
    );
  }

  void _updateWidget(WidgetRef ref, AnalysisWidget updatedWidget) {
    ref
        .read(analysisBuilderControllerProvider(dashboardId).notifier)
        .updateWidget(updatedWidget);
  }
}
