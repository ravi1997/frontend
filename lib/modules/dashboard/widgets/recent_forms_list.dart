import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/modules/dashboard/dashboard_controller.dart';
import 'package:frontend/modules/dashboard/dashboard_models.dart';
import 'package:frontend/modules/form_builder/widgets/publish_success_dialog.dart';

class RecentFormsList extends ConsumerWidget {
  const RecentFormsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredForms = ref.watch(filteredRecentFormsProvider);
    final searchQuery = ref.watch(dashboardSearchQueryProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Forms',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your recently created or modified forms',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          if (filteredForms.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 48,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? 'No forms yet. Create your first form!'
                          : 'No forms found matching "$searchQuery"',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...filteredForms.map(
              (form) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecentFormItem(form: form),
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View all activity',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _RecentFormItem extends ConsumerWidget {
  final RecentForm form;
  const _RecentFormItem({required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      form.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '${form.status} • ${DateFormat.yMMMd().format(form.updatedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton.icon(
          onPressed: () => context.push('/f/${form.id}'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF10B981), // Green for Submit
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          icon: const Icon(Icons.send_outlined, size: 14),
          label: Text(
            'Send Response',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton.icon(
          onPressed: () => context.push('/forms/${form.id}/responses'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2563EB),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          icon: const Icon(Icons.analytics_outlined, size: 14),
          label: Text(
            'Responses',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        TextButton.icon(
          onPressed: () => context.push('/forms/${form.id}/analytics'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8B5CF6), // Purple for Analytics
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          icon: const Icon(Icons.show_chart, size: 14),
          label: Text(
            'Analytics',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        PopupMenuButton<String>(
          key: Key('form_menu_btn_${form.id}'),
          tooltip: 'More actions',
          icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF6B7280)),
          onSelected: (value) async {
            if (value == 'edit') {
              await context.push('/builder/${form.id}');
              ref.read(dashboardControllerProvider.notifier).refresh();
            } else if (value == 'delete') {
              _showDeleteDialog(context, ref);
            } else if (value == 'duplicate') {
              await ref
                  .read(dashboardControllerProvider.notifier)
                  .duplicateForm(form.id, form.title);
            } else if (value == 'share') {
              showDialog(
                context: context,
                builder: (context) => PublishSuccessDialog(formId: form.id),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              key: Key('form_edit_opt_${form.id}'),
              value: 'edit',
              child: const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              key: Key('form_duplicate_opt_${form.id}'),
              value: 'duplicate',
              child: const Row(
                children: [
                  Icon(Icons.copy, size: 16),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            PopupMenuItem(
              key: Key('form_share_opt_${form.id}'),
              value: 'share',
              child: const Row(
                children: [
                  Icon(Icons.qr_code_2, size: 16),
                  SizedBox(width: 8),
                  Text('Share & QR'),
                ],
              ),
            ),
            PopupMenuItem(
              key: Key('form_delete_opt_${form.id}'),
              value: 'delete',
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Form'),
        content: Text(
          'Are you sure you want to delete "${form.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(dashboardControllerProvider.notifier)
                  .deleteForm(form.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
