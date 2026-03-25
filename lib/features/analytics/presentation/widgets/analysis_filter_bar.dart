import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/analysis_builder_controller.dart';

class AnalysisFilterBar extends ConsumerWidget {
  final String? dashboardId;

  const AnalysisFilterBar({super.key, this.dashboardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(
      analysisBuilderControllerProvider(
        dashboardId,
      ).select((s) => s.dashboard.globalFilters),
    );

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 20, color: Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Text(
            'Filters',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 24),
          if (filters.isEmpty)
            Text(
              'No global filters active',
              style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            )
          else
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Chip(
                    label: Text('${filter.label}: ${filter.value ?? "All"}'),
                    onDeleted: () {
                      // Logic to remove filter
                    },
                  );
                },
              ),
            ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _showAddFilterDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Global Filter'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddFilterDialog(BuildContext context) {
    // Dialog to add filter
  }
}
