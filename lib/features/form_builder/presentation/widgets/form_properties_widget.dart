import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/form_layout_type.dart';
import '../controllers/form_builder_controller.dart';

class FormPropertiesWidget extends ConsumerStatefulWidget {
  final String formId;

  const FormPropertiesWidget({super.key, required this.formId});

  @override
  ConsumerState<FormPropertiesWidget> createState() =>
      _FormPropertiesWidgetState();
}

class _FormPropertiesWidgetState extends ConsumerState<FormPropertiesWidget> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builderState = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return builderState.when(
      data: (state) {
        final form = state.form;

        // Sync main controllers
        if (_titleController.text != form.title) {
          _titleController.value = _titleController.value.copyWith(
            text: form.title,
            selection: TextSelection.collapsed(offset: form.title.length),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.borderLight, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.fileLines,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Form Properties',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        onPressed: () => ref
                            .read(
                              formBuilderControllerProvider(
                                widget.formId,
                              ).notifier,
                            )
                            .selectQuestion(null, null),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Tab Bar
                Material(
                  color: Colors.white,
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'General'),
                      Tab(text: 'Style'),
                    ],
                    labelColor: AppColors.brandBlue,
                    unselectedLabelColor: AppColors.textGrey,
                    indicatorColor: AppColors.brandBlue,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Divider(color: AppColors.borderLight, height: 1),

                // Properties Content
                Expanded(
                  child: TabBarView(
                    children: [
                      // General Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            _buildTextField(
                              label: 'Form Title',
                              controller: _titleController,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(form.copyWith(title: val));
                              },
                            ),
                            const SizedBox(height: 24),

                            // Global Layout
                            _buildLayoutDropdown(form.layout, (val) {
                              if (val != null) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(form.copyWith(layout: val));
                              }
                            }),
                          ],
                        ),
                      ),

                      // Style Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GLOBAL THEME',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildColorPicker(
                              label: 'Page Background',
                              value: form.style.backgroundColor,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(
                                      form.copyWith(
                                        style: form.style.copyWith(
                                          backgroundColor: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildColorPicker(
                              label: 'Primary Color',
                              value: form.style.primaryColor,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(
                                      form.copyWith(
                                        style: form.style.copyWith(
                                          primaryColor: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'TYPOGRAPHY',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDropdown<String>(
                              label: 'Font Family',
                              value: form.style.fontFamily,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Inter',
                                  child: Text('Inter'),
                                ),
                                DropdownMenuItem(
                                  value: 'Roboto',
                                  child: Text('Roboto'),
                                ),
                                DropdownMenuItem(
                                  value: 'Poppins',
                                  child: Text('Poppins'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  ref
                                      .read(
                                        formBuilderControllerProvider(
                                          widget.formId,
                                        ).notifier,
                                      )
                                      .updateForm(
                                        form.copyWith(
                                          style: form.style.copyWith(
                                            fontFamily: val,
                                          ),
                                        ),
                                      );
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'LAYOUT',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildNumberSlider(
                              label: 'Max Width',
                              value: form.style.maxWidth,
                              min: 400,
                              max: 1200,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(
                                      form.copyWith(
                                        style: form.style.copyWith(
                                          maxWidth: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildNumberSlider(
                              label: 'Question Spacing',
                              value: form.style.questionSpacing,
                              min: 0,
                              max: 48,
                              onChanged: (val) {
                                ref
                                    .read(
                                      formBuilderControllerProvider(
                                        widget.formId,
                                      ).notifier,
                                    )
                                    .updateForm(
                                      form.copyWith(
                                        style: form.style.copyWith(
                                          questionSpacing: val,
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const SizedBox(),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.builderElement,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(color: AppColors.textDark),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLayoutDropdown(
    FormLayoutType currentLayout,
    Function(FormLayoutType?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Form Layout',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.builderElement,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FormLayoutType>(
              value: currentLayout,
              isExpanded: true,
              items: FormLayoutType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.label));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    Color displayColor;
    try {
      displayColor = Color(int.parse(value.replaceAll('#', '0xFF')));
    } catch (_) {
      displayColor = Colors.transparent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderLight),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  fillColor: AppColors.builderElement,
                  filled: true,
                  hintText: '#HEXCODE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppColors.brandBlue,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.builderElement,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
