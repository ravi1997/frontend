import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/form_template.dart';
import '../controllers/template_library_controller.dart';
import '../widgets/template_card.dart';
import '../widgets/template_preview_dialog.dart';

class TemplateLibraryPage extends ConsumerStatefulWidget {
  const TemplateLibraryPage({super.key});

  @override
  ConsumerState<TemplateLibraryPage> createState() =>
      _TemplateLibraryPageState();
}

class _TemplateLibraryPageState extends ConsumerState<TemplateLibraryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(templateLibraryControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF374151)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Template Library',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF6B7280)),
            onPressed: () {
              ref.read(templateLibraryControllerProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: controller.when(
        data: (state) => _buildContent(state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading templates',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(templateLibraryControllerProvider.notifier)
                        .refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TemplateLibraryState state) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryFilter(state),
        Expanded(
          child: state.filteredTemplates.isEmpty
              ? _buildEmptyState()
              : _buildTemplateGrid(state),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref
              .read(templateLibraryControllerProvider.notifier)
              .searchTemplates(value);
        },
        decoration: InputDecoration(
          hintText: 'Search templates...',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF6B7280),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
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
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(TemplateLibraryState state) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FormTemplateCategory.values.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip(null, 'All', state);
          }
          final category = FormTemplateCategory.values[index - 1];
          return _buildCategoryChip(category, category.displayName, state);
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    FormTemplateCategory? category,
    String label,
    TemplateLibraryState state,
  ) {
    final isSelected = state.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF374151),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            ref
                .read(templateLibraryControllerProvider.notifier)
                .filterByCategory(category);
          } else {
            ref
                .read(templateLibraryControllerProvider.notifier)
                .filterByCategory(null);
          }
        },
        backgroundColor: const Color(0xFFF3F4F6),
        selectedColor: const Color(0xFF2563EB),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildTemplateGrid(TemplateLibraryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(templateLibraryControllerProvider.notifier).refresh();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: state.filteredTemplates.length,
        itemBuilder: (context, index) {
          final template = state.filteredTemplates[index];
          return TemplateCard(
            template: template,
            onTap: () => _showTemplatePreview(template),
            onUse: () => _useTemplate(template),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No templates found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
                ref
                    .read(templateLibraryControllerProvider.notifier)
                    .filterByCategory(null);
                ref
                    .read(templateLibraryControllerProvider.notifier)
                    .searchTemplates('');
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplatePreview(FormTemplate template) {
    showDialog(
      context: context,
      builder: (context) => TemplatePreviewDialog(
        template: template,
        onUse: () {
          Navigator.of(context).pop();
          _useTemplate(template);
        },
      ),
    );
  }

  Future<void> _useTemplate(FormTemplate template) async {
    final formName = await showDialog<String>(
      context: context,
      builder: (context) => _TemplateNameDialog(template: template),
    );

    if (formName == null) return;

    try {
      final formId = await ref
          .read(templateLibraryControllerProvider.notifier)
          .createFormFromTemplate(template.id, formName);

      if (mounted) {
        context.push('/builder/$formId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create form: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _TemplateNameDialog extends StatefulWidget {
  final FormTemplate template;

  const _TemplateNameDialog({required this.template});

  @override
  State<_TemplateNameDialog> createState() => _TemplateNameDialogState();
}

class _TemplateNameDialogState extends State<_TemplateNameDialog> {
  final _formNameController = TextEditingController(
    text: 'Copy of ${DateTime.now().millisecondsSinceEpoch}',
  );

  @override
  void dispose() {
    _formNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Use Template',
        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template: ${widget.template.name}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _formNameController,
            decoration: InputDecoration(
              labelText: 'Form Name',
              hintText: 'Enter a name for your new form',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final formName = _formNameController.text.trim();
            if (formName.isEmpty) return;
            Navigator.of(context).pop(formName);
          },
          child: const Text('Create Form'),
        ),
      ],
    );
  }
}
