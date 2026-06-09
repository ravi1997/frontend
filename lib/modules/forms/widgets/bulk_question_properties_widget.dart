import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/modules/forms/models/form_builder_state.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import 'package:frontend/modules/forms/services/field_registry.dart';
import 'package:frontend/modules/forms/services/form_builder_controller.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class BulkQuestionPropertiesWidget extends ConsumerWidget {
  final String controllerKey;
  final List<String> selectedQuestionIds;

  const BulkQuestionPropertiesWidget({
    super.key,
    required this.controllerKey,
    required this.selectedQuestionIds,
  });

  List<FormQuestion> _selectedQuestions(FormBuilderState state) {
    final ids = selectedQuestionIds.toSet();
    return state.form.sections
        .expand<FormQuestion>((section) => section.questions)
        .where((question) => ids.contains(question.id))
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builderState = ref.watch(
      formBuilderControllerProvider(controllerKey),
    );

    return builderState.when(
      data: (state) {
        final questions = _selectedQuestions(state);
        if (questions.isEmpty) {
          return const SizedBox();
        }

        final compatibleTypes = questions.isEmpty
            ? const <QuestionType>[]
            : (() {
                var allowed = FieldRegistry.getCompatibleTypes(
                  questions.first.type,
                ).toSet();
                for (final question in questions.skip(1)) {
                  allowed = allowed.intersection(
                    FieldRegistry.getCompatibleTypes(question.type).toSet(),
                  );
                }
                return QuestionType.values
                    .where((type) => allowed.contains(type))
                    .toList();
              })();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: AppColors.borderLight, width: 1),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.layers_outlined,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bulk Edit (${questions.length} Questions)',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textGrey),
                      onPressed: () => ref
                          .read(
                            formBuilderControllerProvider(
                              controllerKey,
                            ).notifier,
                          )
                          .clearQuestionSelections(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COMMON CHANGES',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (compatibleTypes.length > 1) ...[
                        DropdownButtonFormField<QuestionType>(
                          decoration: const InputDecoration(
                            labelText: 'Change Type',
                            labelStyle: TextStyle(color: AppColors.textDark),
                            filled: true,
                            fillColor: AppColors.builderElement,
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          style: const TextStyle(color: AppColors.textDark),
                          dropdownColor: Colors.white,
                          items: compatibleTypes
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.label,
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    controllerKey,
                                  ).notifier,
                                )
                                .convertQuestionsBulk(
                                  selectedQuestionIds,
                                  value,
                                );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                      PropertyBuilderUtils.buildSwitch(
                        label: 'Required',
                        description:
                            'Apply required validation to all selected questions.',
                        value: questions.every((q) => q.isRequired),
                        onChanged: (val) => ref
                            .read(
                              formBuilderControllerProvider(
                                controllerKey,
                              ).notifier,
                            )
                            .updateQuestionsBulk(
                              selectedQuestionIds,
                              (q) => q.copyWith(
                                validation: {
                                  ...q.validation,
                                  'is_required': val,
                                },
                              ),
                            ),
                      ),
                      const SizedBox(height: 12),
                      PropertyBuilderUtils.buildSwitch(
                        label: 'Hidden',
                        value: questions.every((q) => q.isHidden),
                        onChanged: (val) => ref
                            .read(
                              formBuilderControllerProvider(
                                controllerKey,
                              ).notifier,
                            )
                            .updateQuestionsBulk(
                              selectedQuestionIds,
                              (q) => q.copyWith(isHidden: val),
                            ),
                      ),
                      const SizedBox(height: 12),
                      PropertyBuilderUtils.buildSwitch(
                        label: 'Read Only',
                        value: questions.every((q) => q.isReadOnly),
                        onChanged: (val) => ref
                            .read(
                              formBuilderControllerProvider(
                                controllerKey,
                              ).notifier,
                            )
                            .updateQuestionsBulk(
                              selectedQuestionIds,
                              (q) => q.copyWith(isReadOnly: val),
                            ),
                      ),
                      const SizedBox(height: 12),
                      PropertyBuilderUtils.buildSwitch(
                        label: 'Repeatable',
                        value: questions.every((q) => q.isRepeatable),
                        onChanged: (val) => ref
                            .read(
                              formBuilderControllerProvider(
                                controllerKey,
                              ).notifier,
                            )
                            .updateQuestionsBulk(
                              selectedQuestionIds,
                              (q) => q.copyWith(
                                isRepeatable: val,
                                repeatMin: val ? (q.repeatMin ?? 1) : null,
                                repeatMax: val ? q.repeatMax : null,
                              ),
                            ),
                      ),
                      if (questions.every((q) => q.isRepeatable)) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minimum repeats',
                            labelStyle: TextStyle(color: AppColors.textDark),
                            filled: true,
                            fillColor: AppColors.builderElement,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val) ?? 1;
                            ref
                                .read(
                                  formBuilderControllerProvider(
                                    controllerKey,
                                  ).notifier,
                                )
                                .updateQuestionsBulk(
                                  selectedQuestionIds,
                                  (q) => q.copyWith(repeatMin: parsed),
                                );
                          },
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'Tip: click a field to edit one item, or long-press fields to build a bulk selection.',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox(),
    );
  }
}
