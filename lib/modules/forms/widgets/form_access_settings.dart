import 'package:flutter/material.dart';
import 'package:frontend/modules/forms/models/access_policy.dart';
import 'package:frontend/modules/forms/widgets/property_builder_utils.dart';

class FormAccessSettings extends StatefulWidget {
  final Map<String, dynamic> form;
  final ValueChanged<AccessPolicy> onChanged;

  const FormAccessSettings({
    super.key,
    required this.form,
    required this.onChanged,
  });

  @override
  State<FormAccessSettings> createState() => _FormAccessSettingsState();
}

class _FormAccessSettingsState extends State<FormAccessSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _privateMessageController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;
  late TextEditingController _passwordHintController;
  late TextEditingController _inviteController;
  late TextEditingController _limitMessageController;
  late TextEditingController _allowedUsersController;
  late TextEditingController _allowedRolesController;
  late TextEditingController _allowedGroupsController;
  late TextEditingController _inviteExpiryController;
  late TextEditingController _limitCountController;

  AccessPolicy get _policy => AccessPolicy.fromJson(
    Map<String, dynamic>.from(
      widget.form['accessPolicy'] ?? widget.form['access_policy'] ?? const {},
    ),
  );

  @override
  void initState() {
    super.initState();
    final policy = _policy;
    _privateMessageController = TextEditingController(
      text: policy.privateAccessMessage ?? '',
    );
    _passwordController = TextEditingController(
      text: policy.passwordHash ?? '',
    );
    _passwordConfirmationController = TextEditingController();
    _passwordHintController = TextEditingController(
      text: policy.passwordHint ?? '',
    );
    final invite = _primaryInvite(policy);
    _inviteController = TextEditingController(text: _inviteValue(invite));
    _limitMessageController = TextEditingController(
      text: policy.limitReachedMessage ?? '',
    );
    _allowedUsersController = TextEditingController(
      text: policy.allowedUserIds.join(', '),
    );
    _allowedRolesController = TextEditingController(
      text: policy.allowedRoles.join(', '),
    );
    _allowedGroupsController = TextEditingController(
      text: policy.allowedGroupIds.join(', '),
    );
    _inviteExpiryController = TextEditingController(
      text: _inviteExpiryValue(invite),
    );
    _limitCountController = TextEditingController(
      text: policy.submissionLimitCount?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant FormAccessSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    final policy = _policy;
    final invite = _primaryInvite(policy);
    _sync(_passwordController, policy.passwordHash ?? '');
    _sync(_privateMessageController, policy.privateAccessMessage ?? '');
    _sync(_passwordHintController, policy.passwordHint ?? '');
    _sync(_limitMessageController, policy.limitReachedMessage ?? '');
    _sync(_allowedUsersController, policy.allowedUserIds.join(', '));
    _sync(_allowedRolesController, policy.allowedRoles.join(', '));
    _sync(_allowedGroupsController, policy.allowedGroupIds.join(', '));
    _sync(_inviteController, _inviteValue(invite));
    _sync(_inviteExpiryController, _inviteExpiryValue(invite));
    _sync(_limitCountController, policy.submissionLimitCount?.toString() ?? '');
  }

  void _sync(TextEditingController controller, String value) {
    if (controller.text == value) return;
    if (FocusScope.of(context).hasFocus) return;
    controller.text = value;
  }

  @override
  void dispose() {
    _privateMessageController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _passwordHintController.dispose();
    _inviteController.dispose();
    _limitMessageController.dispose();
    _allowedUsersController.dispose();
    _allowedRolesController.dispose();
    _allowedGroupsController.dispose();
    _inviteExpiryController.dispose();
    _limitCountController.dispose();
    super.dispose();
  }

  void _emit(AccessPolicy policy) {
    widget.onChanged(policy);
    _formKey.currentState?.validate();
  }

  List<String> _splitCsv(String value) =>
      value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  Map<String, dynamic>? _primaryInvite(AccessPolicy policy) {
    if (policy.invites.isEmpty) return null;
    return Map<String, dynamic>.from(policy.invites.first);
  }

  String _inviteValue(Map<String, dynamic>? invite) {
    final value =
        invite?['invitee'] ??
        invite?['email'] ??
        invite?['recipient'] ??
        invite?['id'] ??
        invite?['value'];
    return value?.toString() ?? '';
  }

  String _inviteExpiryValue(Map<String, dynamic>? invite) {
    final value =
        invite?['expiresAt'] ?? invite?['expires_at'] ?? invite?['expiry'];
    if (value is DateTime) return value.toIso8601String();
    return value?.toString() ?? '';
  }

  void _updateInvite(
    AccessPolicy policy, {
    String? invitee,
    String? expiresAt,
  }) {
    final invites = policy.invites
        .map((invite) => Map<String, dynamic>.from(invite))
        .toList();
    final updated = invites.isNotEmpty ? invites.first : <String, dynamic>{};

    if (invitee != null) {
      updated['invitee'] = invitee;
    }
    if (expiresAt != null) {
      updated['expiresAt'] = expiresAt;
    }

    if (invites.isEmpty) {
      invites.add(updated);
    } else {
      invites[0] = updated;
    }

    _emit(policy.copyWith(invites: invites));
  }

  void _validate() => _formKey.currentState?.validate();

  @override
  Widget build(BuildContext context) {
    final policy = _policy;
    final isPrivate = policy.accessMode == 'private';
    final isPassword = policy.passwordProtected;
    final isInviteOnly = policy.inviteOnly;
    final isLimit = policy.submissionLimitEnabled;
    final identityMode = policy.responseIdentityMode;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access / Privacy',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Control who can open the form, how they submit, and whether responses are anonymous or identified.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          const Text(
            'Access mode',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          RadioGroup<String>(
            groupValue: policy.accessMode,
            onChanged: (val) {
              if (val == null) return;
              _emit(policy.copyWith(accessMode: val));
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Public'),
                  subtitle: const Text(
                    'Anyone with the link can open the form.',
                  ),
                  value: 'public',
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Private'),
                  subtitle: const Text(
                    'Only approved users can open the form.',
                  ),
                  value: 'private',
                ),
              ],
            ),
          ),
          if (isPrivate) ...[
            const SizedBox(height: 8),
            PropertyBuilderUtils.buildSwitch(
              label: 'Require login',
              value: policy.requireLogin,
              onChanged: (val) => _emit(policy.copyWith(requireLogin: val)),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Allowed users (comma-separated ids/emails)',
              controller: _allowedUsersController,
              onChanged: (val) =>
                  _emit(policy.copyWith(allowedUserIds: _splitCsv(val))),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Allowed roles (comma-separated)',
              controller: _allowedRolesController,
              onChanged: (val) =>
                  _emit(policy.copyWith(allowedRoles: _splitCsv(val))),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Allowed groups (comma-separated)',
              controller: _allowedGroupsController,
              onChanged: (val) =>
                  _emit(policy.copyWith(allowedGroupIds: _splitCsv(val))),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Access message',
              placeholder: 'You need permission to open this form.',
              controller: _privateMessageController,
              onChanged: (val) =>
                  _emit(policy.copyWith(privateAccessMessage: val)),
            ),
          ],
          const Divider(height: 32),
          PropertyBuilderUtils.buildSwitch(
            label: 'Password protected',
            value: isPassword,
            onChanged: (val) {
              _passwordConfirmationController.clear();
              _emit(
                policy.copyWith(
                  passwordProtected: val,
                  passwordHash: val ? policy.passwordHash : null,
                  passwordPromptEnabled: val,
                ),
              );
            },
          ),
          if (isPassword) ...[
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Password',
              controller: _passwordController,
              validator: (val) {
                if ((val ?? '').trim().isEmpty) {
                  return 'Enter a password.';
                }
                return null;
              },
              onChanged: (val) => _emit(
                policy.copyWith(passwordHash: val.isEmpty ? null : val),
              ),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Confirm password',
              controller: _passwordConfirmationController,
              validator: (val) {
                if ((val ?? '').trim().isEmpty) {
                  return 'Confirm the password.';
                }
                if (val != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
              onChanged: (_) => _validate(),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Password hint',
              controller: _passwordHintController,
              onChanged: (val) => _emit(policy.copyWith(passwordHint: val)),
            ),
          ],
          const Divider(height: 32),
          PropertyBuilderUtils.buildSwitch(
            label: 'Invite only',
            value: isInviteOnly,
            onChanged: (val) => _emit(policy.copyWith(inviteOnly: val)),
          ),
          if (isInviteOnly) ...[
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Invitee email / id',
              controller: _inviteController,
              validator: (val) {
                if ((val ?? '').trim().isEmpty) {
                  return 'Enter an invitee email or id.';
                }
                return null;
              },
              onChanged: (val) => _updateInvite(policy, invitee: val),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Invite expiry (ISO date)',
              controller: _inviteExpiryController,
              validator: (val) {
                final trimmed = (val ?? '').trim();
                if (trimmed.isEmpty) {
                  return null;
                }
                if (DateTime.tryParse(trimmed) == null) {
                  return 'Use an ISO-8601 date.';
                }
                return null;
              },
              onChanged: (val) => _updateInvite(policy, expiresAt: val),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Require invite to submit',
              value: policy.inviteRequiredForSubmission,
              onChanged: (val) =>
                  _emit(policy.copyWith(inviteRequiredForSubmission: val)),
            ),
          ],
          const Divider(height: 32),
          PropertyBuilderUtils.buildSwitch(
            label: 'Submission limit',
            value: isLimit,
            onChanged: (val) =>
                _emit(policy.copyWith(submissionLimitEnabled: val)),
          ),
          if (isLimit) ...[
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Limit count',
              controller: _limitCountController,
              keyboardType: TextInputType.number,
              onChanged: (val) => _emit(
                policy.copyWith(submissionLimitCount: int.tryParse(val)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: policy.submissionLimitScope,
              decoration: const InputDecoration(
                labelText: 'Limit scope',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'total', child: Text('Per form total')),
                DropdownMenuItem(value: 'user', child: Text('Per user')),
                DropdownMenuItem(value: 'email', child: Text('Per email')),
                DropdownMenuItem(value: 'ip', child: Text('Per IP')),
              ],
              onChanged: (val) {
                if (val == null) return;
                _emit(policy.copyWith(submissionLimitScope: val));
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: policy.submissionLimitAction,
              decoration: const InputDecoration(
                labelText: 'When limit is reached',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'close', child: Text('Close form')),
                DropdownMenuItem(value: 'soft_warn', child: Text('Soft warn')),
                DropdownMenuItem(
                  value: 'block_submit',
                  child: Text('Block submission'),
                ),
              ],
              onChanged: (val) {
                if (val == null) return;
                _emit(policy.copyWith(submissionLimitAction: val));
              },
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildTextField(
              label: 'Limit reached message',
              controller: _limitMessageController,
              onChanged: (val) =>
                  _emit(policy.copyWith(limitReachedMessage: val)),
            ),
          ],
          const Divider(height: 32),
          const Text(
            'Response identity',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          RadioGroup<String>(
            groupValue: identityMode,
            onChanged: (val) {
              if (val == null) return;
              _emit(policy.copyWith(responseIdentityMode: val));
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Anonymous'),
                  subtitle: const Text(
                    'Do not attach user identity to the response.',
                  ),
                  value: 'anonymous',
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Identified'),
                  subtitle: const Text(
                    'Attach identity and optionally require login.',
                  ),
                  value: 'identified',
                ),
              ],
            ),
          ),
          if (identityMode == 'identified') ...[
            PropertyBuilderUtils.buildSwitch(
              label: 'Require login for response',
              value: policy.requireLoginForResponse,
              onChanged: (val) =>
                  _emit(policy.copyWith(requireLoginForResponse: val)),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Collect name',
              value: policy.collectName,
              onChanged: (val) => _emit(policy.copyWith(collectName: val)),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Collect email',
              value: policy.collectEmail,
              onChanged: (val) => _emit(policy.copyWith(collectEmail: val)),
            ),
            const SizedBox(height: 12),
            PropertyBuilderUtils.buildSwitch(
              label: 'Store user id on response',
              value: policy.storeUserIdOnResponse,
              onChanged: (val) =>
                  _emit(policy.copyWith(storeUserIdOnResponse: val)),
            ),
          ],
        ],
      ),
    );
  }
}
