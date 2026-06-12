import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/app_states.dart';
import 'package:frontend/core/widgets/error_state_widget.dart';
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
          return AppStates.empty(
            title: 'Bulk edit selection changed',
            subtitle:
                'The selected questions are no longer available. Clear the selection and choose another set of questions.',
            icon: Icons.layers_outlined,
            actionLabel: 'Clear selection',
            onAction: () => ref
                .read(
                  formBuilderControllerProvider(controllerKey).notifier,
                )
                .clearQuestionSelections(),
          );
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
            color: AppColors.builderBackground,
            border: Border(
              left: BorderSide(color: AppColors.borderLight, width: 1),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceL),
                child: Row(
                  children: [
                    const Icon(
                      Icons.layers_outlined,
                      color: AppColors.textGrey,
                    ),
                    const SizedBox(width: DesignTokens.spaceS),
                    Expanded(
                      child: Text(
                        'Bulk Edit (${questions.length} Questions)',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: DesignTokens.fontM,
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
                  padding: const EdgeInsets.all(DesignTokens.spaceL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COMMON CHANGES',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: DesignTokens.fontS,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spaceM),
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
                          dropdownColor: Theme.of(context).colorScheme.surface,
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
                        const SizedBox(height: DesignTokens.spaceM),
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
                      const SizedBox(height: DesignTokens.spaceM),
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
                      const SizedBox(height: DesignTokens.spaceM),
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
                      const SizedBox(height: DesignTokens.spaceM),
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
                        const SizedBox(height: DesignTokens.spaceM),
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
                      const SizedBox(height: DesignTokens.spaceL - 4),
                      const Text(
                        'Tip: click a field to edit one item, or long-press fields to build a bulk selection.',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: DesignTokens.fontS,
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
      error: (error, stack) => ErrorStateWidget(
        title: 'Failed to load bulk edit',
        message:
            'We could not load the bulk edit panel. Try selecting the questions again or reloading the builder.',
        error: error.toString(),
        onRetry: () => ref.refresh(
          formBuilderControllerProvider(controllerKey),
        ),
      ),
    );
  }
}
