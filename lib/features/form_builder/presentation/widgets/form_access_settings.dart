import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/form_builder/domain/entities/access_policy.dart';
import 'package:frontend/features/form_builder/presentation/controllers/form_builder_controller.dart';
import 'property_builder_utils.dart';

class FormAccessSettings extends ConsumerWidget {
  final String projectId;
  final String formId;
  final BuilderForm form;

  const FormAccessSettings({
    super.key,
    required this.projectId,
    required this.formId,
    required this.form,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AccessPolicy policy = AccessPolicy.fromJson(form.accessPolicy);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Form Visibility',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Visibility Mode',
          value: policy.formVisibility,
          items: const [
            DropdownMenuItem(value: 'public', child: Text('Public (Anyone)')),
            DropdownMenuItem(
              value: 'private',
              child: Text('Private (Specific Users)'),
            ),
            DropdownMenuItem(
              value: 'restricted',
              child: Text('Restricted (Departments)'),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateAccessPolicy(policy.copyWith(formVisibility: val));
            }
          },
        ),
        if (policy.formVisibility == 'restricted') ...[
          const SizedBox(height: 16),
          _buildChipList(
            context: context,
            label: 'Allowed Departments',
            values: policy.allowedDepartments,
            onAdd: (val) {
              final newList = [...policy.allowedDepartments, val];
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateAccessPolicy(
                    policy.copyWith(allowedDepartments: newList),
                  );
            },
            onDelete: (val) {
              final newList = policy.allowedDepartments
                  .where((e) => e != val)
                  .toList();
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateAccessPolicy(
                    policy.copyWith(allowedDepartments: newList),
                  );
            },
          ),
        ],
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
        const Text(
          'Response Permissions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        PropertyBuilderUtils.buildDropdown<String>(
          label: 'Response Visibility Scope',
          value: policy.responseVisibility,
          items: const [
            DropdownMenuItem(
              value: 'all',
              child: Text('Everyone can see all responses'),
            ),
            DropdownMenuItem(
              value: 'own_only',
              child: Text('Users see only their own'),
            ),
            DropdownMenuItem(
              value: 'department_only',
              child: Text('Users see department responses'),
            ),
          ],
          onChanged: (val) {
            if (val != null) {
              ref
                  .read(
                    formBuilderControllerProvider(
                      '$projectId::$formId',
                    ).notifier,
                  )
                  .updateAccessPolicy(policy.copyWith(responseVisibility: val));
            }
          },
        ),
        const SizedBox(height: 24),
        _buildChipList(
          context: context,
          label: 'Can View Responses (User IDs / Roles)',
          values: policy.canViewResponses,
          onAdd: (val) {
            final newList = [...policy.canViewResponses, val];
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateAccessPolicy(policy.copyWith(canViewResponses: newList));
          },
          onDelete: (val) {
            final newList = policy.canViewResponses
                .where((e) => e != val)
                .toList();
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateAccessPolicy(policy.copyWith(canViewResponses: newList));
          },
        ),
        const SizedBox(height: 16),
        _buildChipList(
          context: context,
          label: 'Can Manage Permissions',
          values: policy.canManageAccess,
          onAdd: (val) {
            final newList = [...policy.canManageAccess, val];
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateAccessPolicy(policy.copyWith(canManageAccess: newList));
          },
          onDelete: (val) {
            final newList = policy.canManageAccess
                .where((e) => e != val)
                .toList();
            ref
                .read(
                  formBuilderControllerProvider('$projectId::$formId').notifier,
                )
                .updateAccessPolicy(policy.copyWith(canManageAccess: newList));
          },
        ),
      ],
    );
  }

  Widget _buildChipList({
    required BuildContext context,
    required String label,
    required List<String> values,
    required Function(String) onAdd,
    required Function(String) onDelete,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...values.map(
              (v) => Chip(
                label: Text(v, style: const TextStyle(fontSize: 12)),
                onDeleted: () => onDelete(v),
                deleteIconColor: Colors.red,
                backgroundColor: AppColors.builderElement,
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Add', style: TextStyle(fontSize: 12)),
              onPressed: () async {
                final controller = TextEditingController();
                final val = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add $label'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter value',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, controller.text),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
                if (val != null && val.isNotEmpty) {
                  onAdd(val);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
