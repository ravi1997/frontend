import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/modules/forms/models/form_template.dart';
import 'package:frontend/app/theme/tokens.dart';

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
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: DesignTokens.spaceXS),
                  _buildDescription(context),
                  const SizedBox(height: DesignTokens.spaceS),
                  _buildTags(context),
                  const SizedBox(height: DesignTokens.spaceM),
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
                      ),
                      const SizedBox(width: DesignTokens.spaceXS),
                      Text(
                        '${template.form.sections.fold<int>(0, (count, section) => count + section.questions.length)} fields',
                        style: GoogleFonts.inter(
                          fontSize: DesignTokens.fontXS,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
                      ),
                      const SizedBox(width: DesignTokens.spaceXS),
                      Text(
                        '${template.usageCount} uses',
                        style: GoogleFonts.inter(
                          fontSize: DesignTokens.fontXS,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spaceS),
                      ElevatedButton.icon(
                        onPressed: onUse,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spaceM,
                            vertical: DesignTokens.spaceXS + 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.add, size: 12),
                        label: Text(
                          'Use',
                          style: GoogleFonts.inter(
                            fontSize: DesignTokens.fontS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
          colors: switch (template.category) {
            FormTemplateCategory.contact => [
              const Color(0xFF3B82F6),
              const Color(0xFF2563EB),
            ],
            FormTemplateCategory.survey => [
              const Color(0xFF10B981),
              const Color(0xFF059669),
            ],
            FormTemplateCategory.registration => [
              const Color(0xFFF59E0B),
              const Color(0xFFD97706),
            ],
            FormTemplateCategory.event => [
              const Color(0xFF8B5CF6),
              const Color(0xFF7C3AED),
            ],
            FormTemplateCategory.assessment => [
              const Color(0xFFEF4444),
              const Color(0xFFDC2626),
            ],
            FormTemplateCategory.feedback => [
              const Color(0xFFEC4899),
              const Color(0xFFDB2777),
            ],
            FormTemplateCategory.order => [
              const Color(0xFF6366F1),
              const Color(0xFF4B5563),
            ],
            FormTemplateCategory.application => [
              const Color(0xFF14B8A6),
              const Color(0xFF0D9488),
            ],
            _ => [const Color(0xFF6B7280), const Color(0xFF4B5563)],
          },
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(DesignTokens.radiusM)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceS,
                vertical: DesignTokens.spaceXS + 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: Text(
                template.category.displayName,
                style: GoogleFonts.inter(
                  fontSize: DesignTokens.fontXS,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: FaIcon(
              switch (template.category) {
                FormTemplateCategory.contact => FontAwesomeIcons.addressCard,
                FormTemplateCategory.survey => FontAwesomeIcons.clipboardList,
                FormTemplateCategory.registration => FontAwesomeIcons.userPlus,
                FormTemplateCategory.event => FontAwesomeIcons.calendarDays,
                FormTemplateCategory.assessment =>
                  FontAwesomeIcons.graduationCap,
                FormTemplateCategory.feedback => FontAwesomeIcons.commentDots,
                FormTemplateCategory.order => FontAwesomeIcons.cartShopping,
                FormTemplateCategory.application =>
                  FontAwesomeIcons.fileSignature,
                _ => FontAwesomeIcons.file,
              },
              size: 48,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      template.name,
      style: GoogleFonts.inter(
        fontSize: DesignTokens.fontM,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      template.description,
      style: GoogleFonts.inter(
        fontSize: DesignTokens.fontS,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags(BuildContext context) {
    if (template.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: template.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceS,
            vertical: DesignTokens.spaceXS,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: DesignTokens.fontXS,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
            ),
          ),
        );
      }).toList(),
    );
  }

}
