import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';

import '../../domain/entities/question_type.dart';

class FieldLibraryWidget extends ConsumerStatefulWidget {
  const FieldLibraryWidget({super.key});

  @override
  ConsumerState<FieldLibraryWidget> createState() => _FieldLibraryWidgetState();
}

class _FieldLibraryWidgetState extends ConsumerState<FieldLibraryWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTypes = QuestionType.values.where((type) {
      return type.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.builderSidebar,
        border: Border(
          right: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Field Library',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Click or drag to add fields',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search fields...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    filled: true,
                    fillColor: AppColors.builderElement,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 16),
                // AI Assistant Button
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Assistant',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: filteredTypes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: AppColors.textGrey.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No fields match your search',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    )
                  : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: filteredTypes.map((type) {
                        return _buildFieldButton(context, type);
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldButton(BuildContext context, QuestionType type) {
    return Draggable<QuestionType>(
      data: type,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _FieldButtonCard(type: type, width: 120),
        ),
      ),
      child: _FieldButtonCard(
        type: type,
        width: 120, // Strict sizing
      ),
    );
  }
}

class _FieldButtonCard extends StatelessWidget {
  final QuestionType type;
  final double width;

  const _FieldButtonCard({required this.type, required this.width});

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(type);

    return Container(
      width: width,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIconForType(type), color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            type.label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getColorForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
      case QuestionType.paragraph:
      case QuestionType.number:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
        return AppColors.fieldText;
      case QuestionType.dropdown:
      case QuestionType.checkboxes:
      case QuestionType.multipleChoice:
        return AppColors.fieldChoice;
      case QuestionType.date:
      case QuestionType.time:
        return AppColors.fieldDate;
      case QuestionType.fileUpload:
        return AppColors.fieldMedia;
    }
  }

  IconData _getIconForType(QuestionType type) {
    switch (type) {
      case QuestionType.shortText:
        return FontAwesomeIcons.textWidth;
      case QuestionType.paragraph:
        return FontAwesomeIcons.alignLeft;
      case QuestionType.number:
        return FontAwesomeIcons.hashtag;
      case QuestionType.date:
        return FontAwesomeIcons.calendar;
      case QuestionType.time:
        return FontAwesomeIcons.clock;
      case QuestionType.dropdown:
        return FontAwesomeIcons.caretDown;
      case QuestionType.checkboxes:
        return FontAwesomeIcons.squareCheck;
      case QuestionType.multipleChoice:
        return FontAwesomeIcons.circleDot;
      case QuestionType.fileUpload:
        return FontAwesomeIcons.fileArrowUp;
      case QuestionType.email:
        return FontAwesomeIcons.envelope;
      case QuestionType.mobile:
        return FontAwesomeIcons.phone;
      case QuestionType.url:
        return FontAwesomeIcons.link;
    }
  }
}
