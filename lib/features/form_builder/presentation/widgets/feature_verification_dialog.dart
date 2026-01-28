import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FeatureVerificationDialog extends StatelessWidget {
  const FeatureVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 900,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Feature Status & Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Feature Implementation Status'),
                    const SizedBox(height: 16),
                    _buildFeatureTable(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Verification Instructions'),
                    const SizedBox(height: 16),
                    _buildVerificationSteps(),
                  ],
                ),
              ),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFeatureTable() {
    return Table(
      border: TableBorder.all(color: AppColors.borderLight),
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      children: [
        _buildTableHeader(),
        _buildTableRow(
          'Section Layouts',
          'Supported Grid Columns (1-4), distinct section styling',
          'Basic vertical list of questions',
        ),
        _buildTableRow(
          'Question Styling',
          'Typography control (Label, Hint, Input), Input Decorations (Border, Radius, Fill), State Colors',
          'Default material styling only',
        ),
        _buildTableRow(
          'Question Layout',
          'Label Positioning (Top, Left, Floating, Hidden), Field Widths, Spanning',
          'Fixed vertical layout',
        ),
        _buildTableRow(
          'Drag & Drop',
          'Reorder Sections, Reorder Questions within/between Sections',
          'Static list order',
        ),
        _buildTableRow(
          'Conditional Logic',
          'Video-style rule builder (Show/Hide based on value)',
          'No logic support',
        ),
        _buildTableRow(
          'Input Masks',
          'Custom masks for text/mobile fields',
          'Plain text input only',
        ),
        _buildTableRow(
          'Visual Aesthetics',
          'Glassmorphism, Outlined, Filled, Minimalist styles',
          'Standard Material Design',
        ),
      ],
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF9FAFB)),
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Recently Implemented Changes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Previously Existing / Default',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String feature, String implemented, String existing) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                implemented,
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            existing,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationSteps() {
    return Column(
      children: [
        _buildStep(
          1,
          'Test Drag & Drop',
          'Click and hold the drag handle (::) on any section or question. Move it to a new position and release. Verify the order updates.',
        ),
        _buildStep(
          2,
          'Check Section Layouts',
          'Select a Section. In the Right Panel, change "Columns" to 2 or 3. Add multiple questions and observe them arranging in a grid.',
        ),
        _buildStep(
          3,
          'Verify Question Styling',
          'Select a Question. Go to the "Style" tab (if available) or scroll down in properties. Change Label Color, Font Size, and Border Radius. Verify changes reflect on the canvas.',
        ),
        _buildStep(
          4,
          'Test Conditional Logic',
          'Select a Question. Click "Add Logic Rule". Set a condition (e.g., "If Question A Equals Yes"). Preview the form options (if preview is available) or verify the rule passes validation.',
        ),
      ],
    );
  }

  Widget _buildStep(int index, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              index.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
