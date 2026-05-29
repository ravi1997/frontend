import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/form_models.dart';
import '../../domain/entities/form_template.dart';

class TemplateCard extends StatelessWidget {
  final FormTemplate template;
  final VoidCallback onTap;
  final VoidCallback onUse;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 4),
                  _buildDescription(),
                  const SizedBox(height: 8),
                  _buildTags(),
                  const SizedBox(height: 12),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getCategoryColors(),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                template.category.displayName,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              _getCategoryIcon(),
              size: 48,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      template.name,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF111827),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      template.description,
      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    if (template.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: template.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF6B7280),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(Icons.description_outlined, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '${_getFieldCount()} fields',
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
        ),
        const Spacer(),
        Icon(Icons.trending_up, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '${template.usageCount} uses',
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onUse,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.add, size: 12),
          label: Text(
            'Use',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  int _getFieldCount() {
    int count = 0;
    for (final section in template.form.sections) {
      count += section.questions.length;
    }
    return count;
  }

  List<Color> _getCategoryColors() {
    switch (template.category) {
      case FormTemplateCategory.contact:
        return [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
      case FormTemplateCategory.survey:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case FormTemplateCategory.registration:
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      case FormTemplateCategory.event:
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
      case FormTemplateCategory.assessment:
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
      case FormTemplateCategory.feedback:
        return [const Color(0xFFEC4899), const Color(0xFFDB2777)];
      case FormTemplateCategory.order:
        return [const Color(0xFF6366F1), const Color(0xFF4B5563)];
      case FormTemplateCategory.application:
        return [const Color(0xFF14B8A6), const Color(0xFF0D9488)];
      case FormTemplateCategory.other:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
    }
  }

  IconData _getCategoryIcon() {
    switch (template.category) {
      case FormTemplateCategory.contact:
        return FontAwesomeIcons.addressCard;
      case FormTemplateCategory.survey:
        return FontAwesomeIcons.clipboardList;
      case FormTemplateCategory.registration:
        return FontAwesomeIcons.userPlus;
      case FormTemplateCategory.event:
        return FontAwesomeIcons.calendarDays;
      case FormTemplateCategory.assessment:
        return FontAwesomeIcons.graduationCap;
      case FormTemplateCategory.feedback:
        return FontAwesomeIcons.commentDots;
      case FormTemplateCategory.order:
        return FontAwesomeIcons.cartShopping;
      case FormTemplateCategory.application:
        return FontAwesomeIcons.fileSignature;
      case FormTemplateCategory.other:
        return FontAwesomeIcons.file;
    }
  }
}
