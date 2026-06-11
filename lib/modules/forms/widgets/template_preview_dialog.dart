import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/modules/forms/models/form_template.dart';

class TemplatePreviewDialog extends StatelessWidget {
  final FormTemplate template;
  final VoidCallback onUse;

  const TemplatePreviewDialog({
    super.key,
    required this.template,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spaceL),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: GoogleFonts.inter(
                            fontSize: DesignTokens.fontL,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spaceXS),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _getCategoryColor().withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                              ),
                              child: Text(
                                template.category.displayName,
                                style: GoogleFonts.inter(
                                  fontSize: DesignTokens.fontS,
                                  fontWeight: FontWeight.w500,
                                  color: _getCategoryColor(),
                                ),
                              ),
                            ),
                            const SizedBox(width: DesignTokens.spaceS),
                            Icon(
                              Icons.trending_up,
                              size: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                            ),
                            const SizedBox(width: DesignTokens.spaceXS),
                            Text(
                              '${template.usageCount} uses',
                              style: GoogleFonts.inter(
                                fontSize: DesignTokens.fontS,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(DesignTokens.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDescription(),
                      const SizedBox(height: DesignTokens.spaceL),
                      _buildTags(),
                      const SizedBox(height: DesignTokens.spaceL),
                      _buildFormPreview(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spaceL),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: theme.colorScheme.outline)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(color: theme.colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceL,
                        vertical: DesignTokens.spaceS + 4,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontM,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spaceS + 4),
                  ElevatedButton.icon(
                    onPressed: onUse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceL,
                        vertical: DesignTokens.spaceS + 4,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Use This Template',
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontM,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.inter(
            fontSize: DesignTokens.fontM,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Text(
          template.description,
          style: GoogleFonts.inter(
            fontSize: DesignTokens.fontM,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    if (template.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: GoogleFonts.inter(
            fontSize: DesignTokens.fontM,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceS),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: template.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                style: GoogleFonts.inter(
                  fontSize: DesignTokens.fontS,
                  color: const Color(0xFF6B7280),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFormPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Form Structure',
          style: GoogleFonts.inter(
            fontSize: DesignTokens.fontM,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: DesignTokens.spaceM),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: template.form.sections.map((section) {
              return _buildSectionPreview(section);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionPreview(dynamic section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                size: DesignTokens.fontM,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: DesignTokens.spaceS),
              Expanded(
                child: Text(
                  section.title is Map
                      ? section.title['en'] ?? 'Untitled Section'
                      : section.title?.toString() ?? 'Untitled Section',
                  style: GoogleFonts.inter(
                    fontSize: DesignTokens.fontS,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...section.questions.map<Widget>((question) {
          return Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: Row(
              children: [
                FaIcon(
                  switch (question.type.toString()) {
                    'QuestionType.shortText' => FontAwesomeIcons.textWidth,
                    'QuestionType.paragraph' => FontAwesomeIcons.alignLeft,
                    'QuestionType.number' => FontAwesomeIcons.hashtag,
                    'QuestionType.email' => FontAwesomeIcons.envelope,
                    'QuestionType.mobile' => FontAwesomeIcons.phone,
                    'QuestionType.date' => FontAwesomeIcons.calendar,
                    'QuestionType.time' => FontAwesomeIcons.clock,
                    'QuestionType.dropdown' => FontAwesomeIcons.caretDown,
                    'QuestionType.multipleChoice' => FontAwesomeIcons.circle,
                    'QuestionType.checkboxes' => FontAwesomeIcons.squareCheck,
                    'QuestionType.rating' => FontAwesomeIcons.star,
                    'QuestionType.fileUpload' => FontAwesomeIcons.upload,
                    'QuestionType.signature' => FontAwesomeIcons.signature,
                    'QuestionType.url' => FontAwesomeIcons.link,
                    _ => FontAwesomeIcons.circleQuestion,
                  },
                  size: 14,
                  color: AppColors.textGrey,
                ),
                const SizedBox(width: DesignTokens.spaceS),
                Expanded(
                  child: Text(
                    question.label is Map
                        ? question.label['en'] ?? 'Untitled Question'
                        : question.label?.toString() ?? 'Untitled Question',
                    style: GoogleFonts.inter(
                      fontSize: DesignTokens.fontS,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                if (question.isRequired)
                  const Icon(Icons.star, size: 12, color: Colors.orange),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: DesignTokens.spaceM),
      ],
    );
  }

  Color _getCategoryColor() {
    switch (template.category) {
      case FormTemplateCategory.contact:
        return const Color(0xFF3B82F6);
      case FormTemplateCategory.survey:
        return const Color(0xFF10B981);
      case FormTemplateCategory.registration:
        return const Color(0xFFF59E0B);
      case FormTemplateCategory.event:
        return const Color(0xFF8B5CF6);
      case FormTemplateCategory.assessment:
        return const Color(0xFFEF4444);
      case FormTemplateCategory.feedback:
        return const Color(0xFFEC4899);
      case FormTemplateCategory.order:
        return const Color(0xFF6366F1);
      case FormTemplateCategory.application:
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFF6B7280);
    }
  }

}
