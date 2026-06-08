import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Expanded(child: SingleChildScrollView(child: _buildContent())),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        template.category.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getCategoryColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.trending_up, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${template.usageCount} uses',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
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
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescription(),
          const SizedBox(height: 24),
          _buildTags(),
          const SizedBox(height: 24),
          _buildFormPreview(),
        ],
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          template.description,
          style: GoogleFonts.inter(
            fontSize: 14,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
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
                  fontSize: 12,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
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
              Icon(Icons.folder_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title is Map
                      ? section.title['en'] ?? 'Untitled Section'
                      : section.title?.toString() ?? 'Untitled Section',
                  style: GoogleFonts.inter(
                    fontSize: 13,
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
                  _getQuestionIcon(question.type),
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.label is Map
                        ? question.label['en'] ?? 'Untitled Question'
                        : question.label?.toString() ?? 'Untitled Question',
                    style: GoogleFonts.inter(
                      fontSize: 12,
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onUse,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'Use This Template',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

  FaIconData _getQuestionIcon(dynamic type) {
    switch (type.toString()) {
      case 'QuestionType.shortText':
        return FontAwesomeIcons.textWidth;
      case 'QuestionType.paragraph':
        return FontAwesomeIcons.alignLeft;
      case 'QuestionType.number':
        return FontAwesomeIcons.hashtag;
      case 'QuestionType.email':
        return FontAwesomeIcons.envelope;
      case 'QuestionType.mobile':
        return FontAwesomeIcons.phone;
      case 'QuestionType.date':
        return FontAwesomeIcons.calendar;
      case 'QuestionType.time':
        return FontAwesomeIcons.clock;
      case 'QuestionType.dropdown':
        return FontAwesomeIcons.caretDown;
      case 'QuestionType.multipleChoice':
        return FontAwesomeIcons.circle;
      case 'QuestionType.checkboxes':
        return FontAwesomeIcons.squareCheck;
      case 'QuestionType.rating':
        return FontAwesomeIcons.star;
      case 'QuestionType.fileUpload':
        return FontAwesomeIcons.upload;
      case 'QuestionType.signature':
        return FontAwesomeIcons.signature;
      case 'QuestionType.url':
        return FontAwesomeIcons.link;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }
}
