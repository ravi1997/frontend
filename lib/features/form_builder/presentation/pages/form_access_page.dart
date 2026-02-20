import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/form_builder_controller.dart';
import '../../domain/entities/access_policy.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class FormAccessPage extends ConsumerStatefulWidget {
  final String formId;

  const FormAccessPage({super.key, required this.formId});

  @override
  ConsumerState<FormAccessPage> createState() => _FormAccessPageState();
}

class _FormAccessPageState extends ConsumerState<FormAccessPage> {
  AccessPolicy? _editedPolicy;
  bool _isSaving = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final formStateAsync = ref.watch(
      formBuilderControllerProvider(widget.formId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Access Management',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_editedPolicy != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : () => _savePolicy(context),
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check, size: 16),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderLight, height: 1),
        ),
      ),
      body: formStateAsync.when(
        data: (state) {
          final form = state.form;
          _editedPolicy ??= form.accessPolicy;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Container(
                width: 260,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(color: AppColors.borderLight),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    _buildNavItem(0, 'General Access', FontAwesomeIcons.globe),
                    _buildNavItem(
                      1,
                      'Response Management',
                      FontAwesomeIcons.replyAll,
                    ),
                    _buildNavItem(
                      2,
                      'Builder & Admin',
                      FontAwesomeIcons.userTie,
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildCurrentSection(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            right: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textGrey,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSection() {
    switch (_selectedIndex) {
      case 0:
        return _buildGeneralAccessSection();
      case 1:
        return _buildResponseAccessSection();
      case 2:
        return _buildBuilderAccessSection();
      default:
        return const SizedBox.shrink();
    }
  }

  void _updatePolicy(AccessPolicy newPolicy) {
    setState(() {
      _editedPolicy = newPolicy;
    });
  }

  Future<void> _savePolicy(BuildContext context) async {
    if (_editedPolicy == null) return;
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        formBuilderControllerProvider(widget.formId).notifier,
      );
      final currentForm = ref
          .read(formBuilderControllerProvider(widget.formId))
          .value
          ?.form;
      if (currentForm != null) {
        notifier.updateAccessPolicy(_editedPolicy!);
        final success = await notifier.saveForm(versionType: 'patch');
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Policy saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save Access Policy'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildGeneralAccessSection() {
    final policy = _editedPolicy!;
    return Column(
      key: const ValueKey('section_0'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General Access',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Configure who can see and submit responses to this form.',
          style: TextStyle(color: AppColors.textGrey, fontSize: 16),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
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
              const SizedBox(height: 8),
              const Text(
                'Determine the public availability of the form link.',
                style: TextStyle(color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: policy.formVisibility,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'public',
                    child: Text(
                      '🌍 Public - Anyone with link can view and submit',
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'private',
                    child: Text('🔒 Private - Only explicitly added users'),
                  ),
                  DropdownMenuItem(
                    value: 'restricted',
                    child: Text('🏢 Restricted - Specific departments only'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    _updatePolicy(policy.copyWith(formVisibility: val));
                  }
                },
              ),
              if (policy.formVisibility == 'restricted') ...[
                const SizedBox(height: 32),
                const Divider(color: AppColors.borderLight),
                const SizedBox(height: 24),
                const Text(
                  'Allowed Departments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Users belonging to these departments will be granted access.',
                  style: TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 16),
                _ChipsInputWidget(
                  initialValues: policy.allowedDepartments,
                  onChanged: (vals) =>
                      _updatePolicy(policy.copyWith(allowedDepartments: vals)),
                  hintText: 'Type department name and press enter...',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseAccessSection() {
    final policy = _editedPolicy!;
    return Column(
      key: const ValueKey('section_1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Response Management',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage who can view, analyze, and modify submitted responses.',
          style: TextStyle(color: AppColors.textGrey, fontSize: 16),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Response Visibility Scope',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set the default scope of responses visible to users with view access.',
                style: TextStyle(color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: policy.responseVisibility,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Responses')),
                  DropdownMenuItem(
                    value: 'own_only',
                    child: Text("User's Own Responses"),
                  ),
                  DropdownMenuItem(
                    value: 'department_only',
                    child: Text('Department Responses'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    _updatePolicy(policy.copyWith(responseVisibility: val));
                  }
                },
              ),
              const SizedBox(height: 32),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 24),
              _buildPermissionSection(
                title: 'Response Viewers',
                description:
                    'Users listed here can view responses within the scope defined above.',
                values: policy.canViewResponses,
                roleId: 'canViewResponses', // for QR
                onChanged: (vals) =>
                    _updatePolicy(policy.copyWith(canViewResponses: vals)),
                icon: FontAwesomeIcons.eye,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 24),
              _buildPermissionSection(
                title: 'Response Editors',
                description: 'Users who can edit existing responses.',
                values: policy.canEditResponses,
                roleId: 'canEditResponses',
                onChanged: (vals) =>
                    _updatePolicy(policy.copyWith(canEditResponses: vals)),
                icon: FontAwesomeIcons.penToSquare,
                iconColor: Colors.orange,
              ),
              const SizedBox(height: 24),
              _buildPermissionSection(
                title: 'Response Deleters',
                description:
                    'Users with the authority to permanently delete responses.',
                values: policy.canDeleteResponses,
                roleId: 'canDeleteResponses',
                onChanged: (vals) =>
                    _updatePolicy(policy.copyWith(canDeleteResponses: vals)),
                icon: FontAwesomeIcons.trash,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBuilderAccessSection() {
    final policy = _editedPolicy!;
    return Column(
      key: const ValueKey('section_2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Builder & Admin Access',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Delegate access for form co-authoring, versioning, and administrative controls.',
          style: TextStyle(color: AppColors.textGrey, fontSize: 16),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPermissionSection(
                title: 'Form Co-authors',
                description:
                    'Users who can access the form builder and edit the design structure.',
                values: policy.canEditDesign,
                roleId: 'canEditDesign',
                onChanged: (vals) =>
                    _updatePolicy(policy.copyWith(canEditDesign: vals)),
                icon: FontAwesomeIcons.hammer,
                iconColor: Colors.purple,
              ),
              const SizedBox(height: 24),
              _buildPermissionSection(
                title: 'Version Publishers',
                description:
                    'Users who are allowed to save and activate new versions of the form.',
                values: policy.canCreateVersions,
                roleId: 'canCreateVersions',
                onChanged: (vals) =>
                    _updatePolicy(policy.copyWith(canCreateVersions: vals)),
                icon: FontAwesomeIcons.codeBranch,
                iconColor: Colors.teal,
              ),
              const SizedBox(height: 24),
              _buildPermissionSection(
                title: 'Form Administrators',
                description:
                    'Highest level access. Can manage this access policy, view audit logs, and delete the form.',
                values: policy.canManageAccess,
                roleId: 'canManageAccess',
                onChanged: (vals) {
                  _updatePolicy(
                    policy.copyWith(
                      canManageAccess: vals,
                      canDeleteForm: vals,
                      canViewAuditLogs: vals,
                    ),
                  );
                },
                icon: FontAwesomeIcons.shieldHalved,
                iconColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionSection({
    required String title,
    required String description,
    required List<String> values,
    required String roleId,
    required ValueChanged<List<String>> onChanged,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
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
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _showQrDialog(context, title, roleId),
                icon: const Icon(Icons.qr_code, size: 16),
                label: const Text('QR Invite'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ChipsInputWidget(
            initialValues: values,
            onChanged: onChanged,
            hintText: 'Add user email or UUID...',
          ),
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context, String title, String roleId) {
    // Generate an expiring payload, though in demo just base64 json
    final payload = {
      'type': 'form_role_invite',
      'formId': widget.formId,
      'role': roleId,
      'iat': DateTime.now().millisecondsSinceEpoch,
    };
    final qrData = base64Encode(utf8.encode(jsonEncode(payload)));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Invite for $title'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Have the user scan this QR code from their mobile app or scanning portal to instantly grant them access to this role.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ChipsInputWidget extends StatefulWidget {
  final List<String> initialValues;
  final ValueChanged<List<String>> onChanged;
  final String hintText;

  const _ChipsInputWidget({
    required this.initialValues,
    required this.onChanged,
    this.hintText = 'Add user...',
  });

  @override
  State<_ChipsInputWidget> createState() => _ChipsInputWidgetState();
}

class _ChipsInputWidgetState extends State<_ChipsInputWidget> {
  late List<String> _values;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _values = List.from(widget.initialValues);
  }

  @override
  void didUpdateWidget(covariant _ChipsInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != _values) {
      _values = List.from(widget.initialValues);
    }
  }

  void _addValue(String val) {
    if (val.trim().isEmpty) return;
    setState(() {
      if (!_values.contains(val.trim())) {
        _values.add(val.trim());
        widget.onChanged(_values);
      }
      _controller.clear();
    });
  }

  void _removeValue(String val) {
    setState(() {
      _values.remove(val);
      widget.onChanged(_values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ..._values.map(
            (v) => Chip(
              label: Text(
                v,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onDeleted: () => _removeValue(v),
              deleteIcon: const Icon(Icons.close, size: 14),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              side: BorderSide.none,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.only(left: 12, right: 4),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
              ),
              style: const TextStyle(fontSize: 14),
              onSubmitted: _addValue,
            ),
          ),
        ],
      ),
    );
  }
}
