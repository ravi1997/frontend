import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/form_template.dart';
import '../controllers/template_library_controller.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import '../providers/template_library_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class FormOption {
  final String id;
  final String title;

  FormOption({required this.id, required this.title});
}

enum TemplateType {
  form(
    'Flow / Complete Form',
    Icons.account_tree,
    'Build a complete multi-step journey or form.',
  ),
  section(
    'Form Section',
    Icons.view_quilt,
    'Create a reusable group of questions/fields.',
  ),
  question(
    'Custom Question',
    Icons.short_text,
    'Design a single specialized input or field.',
  ),
  workflow(
    'Workflow Component',
    Icons.hub,
    'Define reusable logic or automated flow steps.',
  );

  final String label;
  final IconData icon;
  final String description;
  const TemplateType(this.label, this.icon, this.description);
}

class CreateTemplatePage extends ConsumerStatefulWidget {
  const CreateTemplatePage({super.key});

  @override
  ConsumerState<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends ConsumerState<CreateTemplatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  FormTemplateCategory? _selectedCategory;
  FormOption? _selectedForm;
  List<FormOption> _availableForms = [];
  bool _isLoadingForms = true;
  bool _isSaving = false;
  bool _buildFromScratch = false;
  TemplateType _selectedType = TemplateType.form;

  @override
  void initState() {
    super.initState();
    _fetchForms();
  }

  Future<void> _fetchForms() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(ApiEndpoints.listForms);
      final List<dynamic> formsJson = response.data as List<dynamic>;

      setState(() {
        _availableForms = formsJson.map((json) {
          return FormOption(
            id: json['id'] ?? json['_id'] ?? '',
            title: json['title'] ?? 'Untitled Form',
          );
        }).toList();
        _isLoadingForms = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingForms = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load forms: $e')));
      }
    }
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_buildFromScratch && _selectedForm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a form to use as template.'),
        ),
      );
      return;
    }
    if (!_buildFromScratch && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = ref.read(templateLibraryRepositoryProvider);
      final apiClient = ref.read(apiClientProvider);
      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      String targetFormId;

      if (_buildFromScratch) {
        final newFormResponse = await apiClient.post(
          ApiEndpoints.createForm,
          data: {
            'title': _nameController.text,
            'slug': _nameController.text.toLowerCase().replaceAll(
              RegExp(r'[^a-z0-9]'),
              '-',
            ),
            'status': 'draft',
            'is_template': true,
            'metadata': {'template_type': _selectedType.name},
            'versions': [
              {
                'version': '1.0.0',
                'sections': [],
                'created_at': DateTime.now().toIso8601String(),
              },
            ],
            'active_version': '1.0.0',
          },
        );
        final formData = newFormResponse.data['form'] ?? newFormResponse.data;
        final extractedId = formData['id'] ?? formData['_id'];

        if (extractedId == null) {
          throw Exception('Failed to retrieve form ID from server response');
        }
        targetFormId = extractedId;
      } else {
        targetFormId = _selectedForm!.id;
      }

      await repository.createCustomTemplate(
        targetFormId,
        _nameController.text,
        _descriptionController.text,
        _buildFromScratch ? FormTemplateCategory.other : _selectedCategory!,
        tags,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Template created successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        ref.read(templateLibraryControllerProvider.notifier).refresh();
        if (_buildFromScratch) {
          context.pushReplacement(
            '/builder/$targetFormId?mode=${_selectedType.name}',
          );
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create template: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    if (user == null || !user.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Access Denied',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: Text(
            'Only administrators can access this page.',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      );
    }

    const labelStyle = TextStyle(
      color: Color(0xFF374151),
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(
          'Template Management',
          style: GoogleFonts.inter(
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        actions: [
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
            label: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(48, 0, 48, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Template',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Standardize your forms by creating reusable templates for your organization.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CREATION METHOD', style: labelStyle),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: RadioGroup<bool>(
                            groupValue: _buildFromScratch,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _buildFromScratch = val);
                              }
                            },
                            child: Column(
                              children: [
                                RadioListTile<bool>(
                                  title: const Text(
                                    'Convert from Existing Form',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Clone an existing form structure into a new template',
                                  ),
                                  value: false,
                                  activeColor: const Color(0xFF2563EB),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                RadioListTile<bool>(
                                  title: const Text(
                                    'Build Template from Scratch',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Start with a blank canvas and create a new master template',
                                  ),
                                  value: true,
                                  activeColor: const Color(0xFF2563EB),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text('TEMPLATE TYPE', style: labelStyle),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.2,
                              ),
                          itemCount: TemplateType.values.length,
                          itemBuilder: (context, index) {
                            final type = TemplateType.values[index];
                            final isSelected = _selectedType == type;
                            return InkWell(
                              onTap: () => setState(() => _selectedType = type),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFF2563EB,
                                        ).withValues(alpha: 0.05)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFFE5E7EB),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      type.icon,
                                      color: isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF6B7280),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            type.label,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: isSelected
                                                  ? const Color(0xFF2563EB)
                                                  : const Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            type.description,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF6B7280),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        if (!_buildFromScratch) ...[
                          const Text('SOURCE FORM', style: labelStyle),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<FormOption>(
                            decoration: inputDecoration.copyWith(
                              hintText: 'Select a form to clone',
                              prefixIcon: const Icon(
                                Icons.copy_rounded,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6B7280),
                            ),
                            dropdownColor: Colors.white,
                            items: _availableForms.map((form) {
                              return DropdownMenuItem<FormOption>(
                                value: form,
                                child: Text(
                                  form.title,
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedForm = value),
                            validator: (value) => value == null
                                ? 'Please select a source form'
                                : null,
                          ),
                          if (_isLoadingForms)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: LinearProgressIndicator(
                                backgroundColor: Color(0xFFF3F4F6),
                              ),
                            ),
                          const SizedBox(height: 24),
                        ],
                        const Text('TEMPLATE NAME', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Color(0xFF111827)),
                          decoration: inputDecoration.copyWith(
                            hintText: 'e.g., Annual Performance Review',
                            prefixIcon: const Icon(
                              Icons.title_rounded,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Please enter a name'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        const Text('DESCRIPTION', style: labelStyle),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          style: const TextStyle(color: Color(0xFF111827)),
                          decoration: inputDecoration.copyWith(
                            hintText:
                                'Briefly describe the purpose of this template...',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: const Icon(
                                Icons.description_rounded,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Please enter a description'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_buildFromScratch) ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CATEGORY', style: labelStyle),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<
                                      FormTemplateCategory
                                    >(
                                      decoration: inputDecoration.copyWith(
                                        prefixIcon: const Icon(
                                          Icons.category_rounded,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF6B7280),
                                      ),
                                      dropdownColor: Colors.white,
                                      items: FormTemplateCategory.values.map((
                                        category,
                                      ) {
                                        return DropdownMenuItem<
                                          FormTemplateCategory
                                        >(
                                          value: category,
                                          child: Text(
                                            category.displayName,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(
                                        () => _selectedCategory = value,
                                      ),
                                      validator: (value) =>
                                          value == null ? 'Required' : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TAGS', style: labelStyle),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _tagsController,
                                    style: const TextStyle(
                                      color: Color(0xFF111827),
                                    ),
                                    decoration: inputDecoration.copyWith(
                                      hintText: 'internal, hr, feedback',
                                      prefixIcon: const Icon(
                                        Icons.local_offer_rounded,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveTemplate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    _buildFromScratch
                                        ? 'CONTINUE TO BUILDER'
                                        : 'CREATE TEMPLATE',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
