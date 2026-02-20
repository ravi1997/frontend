import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import '../controllers/user_management_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public helper to open the panel
// ─────────────────────────────────────────────────────────────────────────────

void showUserDetailPanel(BuildContext context, User user) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'User Detail',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _UserDetailPanel(user: user),
    transitionBuilder: (ctx, anim, _, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: anim.drive(tween), child: child);
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Panel root — aligns to right edge
// ─────────────────────────────────────────────────────────────────────────────

class _UserDetailPanel extends ConsumerStatefulWidget {
  final User user;
  const _UserDetailPanel({required this.user});

  @override
  ConsumerState<_UserDetailPanel> createState() => _UserDetailPanelState();
}

class _UserDetailPanelState extends ConsumerState<_UserDetailPanel> {
  late User _user;
  int _tab = 0; // 0 = Profile, 1 = Roles, 2 = Activity, 3 = Security

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  // Refresh the local copy after a mutation
  void _reload() {
    ref.invalidate(userManagementControllerProvider);
    // Re-fetch the single user from the list after the list refreshes
    ref.read(userManagementControllerProvider.notifier).refreshUsers();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 24,
        color: Colors.transparent,
        child: Container(
          width: 520,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _PanelHeader(
                user: _user,
                onClose: () => Navigator.of(context).pop(),
              ),
              _TabBar(
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: [
                    _ProfileTab(user: _user),
                    _RolesTab(user: _user, onRolesUpdated: _reload),
                    _ActivityTab(userId: _user.id),
                    _SecurityTab(user: _user, onAction: _reload),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Panel Header
// ─────────────────────────────────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final User user;
  final VoidCallback onClose;
  const _PanelHeader({required this.user, required this.onClose});

  Color get _avatarColor {
    if (user.isAdmin) return const Color(0xFF2563EB);
    final colors = [
      const Color(0xFF7C3AED),
      const Color(0xFF059669),
      const Color(0xFFD97706),
      const Color(0xFFDC2626),
      const Color(0xFF0891B2),
    ];
    return colors[user.username.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: _avatarColor.withValues(alpha: 0.12),
                child: Text(
                  user.username[0].toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _avatarColor,
                  ),
                ),
              ),
              if (user.isAdmin)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Name, email, badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Badge(
                      label: user.isActive ? 'Active' : 'Inactive',
                      color: user.isActive
                          ? const Color(0xFF059669)
                          : const Color(0xFFDC2626),
                      bg: user.isActive
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFFEE2E2),
                    ),
                    if (user.isLocked)
                      const _Badge(
                        label: 'Locked',
                        color: Color(0xFFDC2626),
                        bg: Color(0xFFFEE2E2),
                        icon: Icons.lock,
                      ),
                    if (user.isPasswordExpired)
                      const _Badge(
                        label: 'Pw Expired',
                        color: Color(0xFFD97706),
                        bg: Color(0xFFFEF3C7),
                        icon: Icons.key_off,
                      ),
                    _Badge(
                      label: user.userType,
                      color: const Color(0xFF374151),
                      bg: const Color(0xFFF3F4F6),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const _TabBar({required this.selectedIndex, required this.onChanged});

  static const _tabs = ['Profile', 'Roles', 'Activity', 'Security'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _tabs[i],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Tab
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  final User user;
  const _ProfileTab({required this.user});

  String _fmt(String? iso) {
    if (iso == null) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _SectionLabel('Account Details'),
        _Row('User ID', user.id, selectable: true),
        _Row('Username', user.username),
        _Row('Email Address', user.email),
        _Row('Mobile', user.mobile ?? '—'),
        _Row('Employee ID', user.employeeId ?? '—'),
        const SizedBox(height: 24),
        _SectionLabel('Organisation'),
        _Row('Department', user.department ?? '—'),
        _Row('User Type', user.userType),
        const SizedBox(height: 24),
        _SectionLabel('Timestamps'),
        _Row('Registered On', _fmt(user.createdAt)),
        _Row('Last Updated', _fmt(user.updatedAt)),
        _Row('Last Login', _fmt(user.lastLogin)),
        _Row('Password Expires', _fmt(user.passwordExpiration)),
        const SizedBox(height: 24),
        _SectionLabel('Status Flags'),
        _Row('Account Active', user.isActive ? 'Yes' : 'No'),
        _Row(
          'Account Locked',
          user.isLocked ? 'Yes (until ${_fmt(user.lockUntil)})' : 'No',
          valueColor: user.isLocked ? const Color(0xFFDC2626) : null,
        ),
        _Row('Email Verified', user.isEmailVerified ? 'Yes' : 'No'),
        _Row(
          'Password Expired',
          user.isPasswordExpired ? 'Yes' : 'No',
          valueColor: user.isPasswordExpired ? const Color(0xFFD97706) : null,
        ),
        _Row(
          'Failed Login Attempts',
          '${user.failedLoginAttempts}',
          valueColor: user.failedLoginAttempts > 0
              ? const Color(0xFFDC2626)
              : null,
        ),
        _Row('OTP Resend Count', '${user.otpResendCount}'),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Roles Tab
// ─────────────────────────────────────────────────────────────────────────────

class _RolesTab extends ConsumerStatefulWidget {
  final User user;
  final VoidCallback onRolesUpdated;
  const _RolesTab({required this.user, required this.onRolesUpdated});

  @override
  ConsumerState<_RolesTab> createState() => _RolesTabState();
}

class _RolesTabState extends ConsumerState<_RolesTab> {
  static const _allRoles = [
    'superadmin',
    'admin',
    'creator',
    'editor',
    'publisher',
    'deo',
    'manager',
    'user',
    'general',
  ];

  late Set<String> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.user.roles);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(userManagementControllerProvider.notifier)
          .updateRoles(widget.user.id, _selected.toList());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_snack('Roles updated successfully ✓', success: true));
        widget.onRolesUpdated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_snack('Error: $e', success: false));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Assign Roles'),
          const SizedBox(height: 4),
          Text(
            'Select one or more roles. Changes take effect on save.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: _allRoles.map((role) {
                final isSelected = _selected.contains(role);
                final isHighRole = role == 'admin' || role == 'superadmin';
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selected.remove(role);
                    } else {
                      _selected.add(role);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isHighRole
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF0FDF4))
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? (isHighRole
                                  ? const Color(0xFF93C5FD)
                                  : const Color(0xFF86EFAC))
                            : const Color(0xFFE5E7EB),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _roleIcon(role),
                          size: 20,
                          color: isSelected
                              ? (isHighRole
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF059669))
                              : const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                role,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFF111827)
                                      : const Color(0xFF374151),
                                ),
                              ),
                              Text(
                                _roleDesc(role),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: isHighRole
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF059669),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Save Roles',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'superadmin':
        return Icons.admin_panel_settings;
      case 'admin':
        return Icons.manage_accounts;
      case 'creator':
        return Icons.add_circle_outline;
      case 'editor':
        return Icons.edit_outlined;
      case 'publisher':
        return Icons.publish_outlined;
      case 'deo':
        return Icons.input_outlined;
      case 'manager':
        return Icons.supervisor_account_outlined;
      default:
        return Icons.person_outline;
    }
  }

  String _roleDesc(String role) {
    switch (role) {
      case 'superadmin':
        return 'Full system access, can manage admins';
      case 'admin':
        return 'Can manage users and forms';
      case 'creator':
        return 'Can create new forms';
      case 'editor':
        return 'Can edit existing forms';
      case 'publisher':
        return 'Can publish forms';
      case 'deo':
        return 'Data entry operator';
      case 'manager':
        return 'Can view reports and manage teams';
      case 'user':
        return 'Standard user access';
      default:
        return 'General access';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity Tab
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityTab extends ConsumerWidget {
  final String userId;
  const _ActivityTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(userActivityProvider(userId));

    return activityAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load activity',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (activity) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Summary chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryChip(
                label: 'Failed Logins',
                value: '${activity.failedLoginAttempts}',
                color: activity.failedLoginAttempts > 0
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF059669),
              ),
              _SummaryChip(
                label: 'OTP Resends',
                value: '${activity.otpResendCount}',
                color: activity.otpResendCount > 3
                    ? const Color(0xFFD97706)
                    : const Color(0xFF374151),
              ),
              _SummaryChip(
                label: 'Account Status',
                value: activity.isLocked ? 'Locked' : 'Unlocked',
                color: activity.isLocked
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF059669),
              ),
              _SummaryChip(
                label: 'Password',
                value: activity.isPasswordExpired ? 'Expired' : 'Valid',
                color: activity.isPasswordExpired
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionLabel('Event Timeline'),
          const SizedBox(height: 8),
          if (activity.events.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No events recorded yet.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            )
          else
            ...activity.events.asMap().entries.map((entry) {
              final i = entry.key;
              final event = entry.value;
              final isLast = i == activity.events.length - 1;
              return _TimelineEvent(event: event, isLast: isLast);
            }),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  final UserActivityEvent event;
  final bool isLast;
  const _TimelineEvent({required this.event, required this.isLast});

  Color get _dotColor {
    switch (event.color) {
      case 'green':
        return const Color(0xFF059669);
      case 'red':
        return const Color(0xFFDC2626);
      case 'orange':
        return const Color(0xFFD97706);
      case 'blue':
        return const Color(0xFF2563EB);
      case 'purple':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _fmt(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: _dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE5E7EB)),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  if (event.timestamp != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _fmt(event.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                  if (event.detail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.detail!,
                      style: GoogleFonts.inter(fontSize: 12, color: _dotColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Security Tab
// ─────────────────────────────────────────────────────────────────────────────

class _SecurityTab extends ConsumerStatefulWidget {
  final User user;
  final VoidCallback onAction;
  const _SecurityTab({required this.user, required this.onAction});

  @override
  ConsumerState<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends ConsumerState<_SecurityTab> {
  final _pwController = TextEditingController();
  bool _showPw = false;
  bool _loading = false;

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _doAction(
    Future<void> Function() action,
    String successMsg,
  ) async {
    setState(() => _loading = true);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_snack(successMsg, success: true));
        widget.onAction();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_snack('Error: $e', success: false));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(userManagementControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // ── Lock / Unlock ────────────────────────────────────────────
        _SectionLabel('Account Lock'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Lock Account',
                icon: Icons.lock_outline,
                color: const Color(0xFFDC2626),
                enabled: !widget.user.isLocked && !_loading,
                onTap: () => _doAction(
                  () => controller.lockUser(widget.user.id),
                  'Account locked',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'Unlock Account',
                icon: Icons.lock_open_outlined,
                color: const Color(0xFF059669),
                enabled: widget.user.isLocked && !_loading,
                onTap: () => _doAction(
                  () => controller.unlockUser(widget.user.id),
                  'Account unlocked',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),
        // ── Activate / Deactivate ────────────────────────────────────
        _SectionLabel('Account Status'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Activate',
                icon: Icons.check_circle_outline,
                color: const Color(0xFF059669),
                enabled: !widget.user.isActive && !_loading,
                onTap: () => _doAction(
                  () async => ref
                      .read(userManagementControllerProvider.notifier)
                      .toggleUserStatus(widget.user.id, false),
                  'User activated',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'Deactivate',
                icon: Icons.block_outlined,
                color: const Color(0xFFD97706),
                enabled: widget.user.isActive && !_loading,
                onTap: () => _doAction(
                  () async => ref
                      .read(userManagementControllerProvider.notifier)
                      .toggleUserStatus(widget.user.id, true),
                  'User deactivated',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),
        // ── Reset Password ───────────────────────────────────────────
        _SectionLabel('Admin Reset Password'),
        const SizedBox(height: 12),
        TextField(
          controller: _pwController,
          obscureText: !_showPw,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'New password (min 6 chars)',
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPw ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: const Color(0xFF6B7280),
              ),
              onPressed: () => setState(() => _showPw = !_showPw),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _loading
                ? null
                : () async {
                    final pw = _pwController.text.trim();
                    if (pw.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _snack(
                          'Password must be at least 6 characters',
                          success: false,
                        ),
                      );
                      return;
                    }
                    await _doAction(
                      () => controller.resetPassword(widget.user.id, pw),
                      'Password reset successfully',
                    );
                    _pwController.clear();
                  },
            icon: const Icon(Icons.key, size: 18),
            label: Text(
              'Reset Password',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),
        // ── Delete User ──────────────────────────────────────────────
        _SectionLabel('Danger Zone'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFECACA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete User Account',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'This will permanently delete the user and all associated data. This action cannot be undone.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _loading
                    ? null
                    : () => _showDeleteConfirmation(context, controller),
                icon: const Icon(Icons.delete_forever, size: 18),
                label: Text(
                  'Delete User',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Delete "${widget.user.username}"?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        content: Text(
          'This will permanently delete the account and cannot be undone. Are you sure?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _doAction(
                () => controller.deleteUser(widget.user.id),
                'User deleted',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: ElevatedButton.icon(
        onPressed: enabled ? onTap : null,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: const Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool selectable;
  const _Row(
    this.label,
    this.value, {
    this.valueColor,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: selectable
                ? SelectableText(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? const Color(0xFF111827),
                      fontFamily: 'monospace',
                    ),
                  )
                : Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: valueColor ?? const Color(0xFF111827),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData? icon;
  const _Badge({
    required this.label,
    required this.color,
    required this.bg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

SnackBar _snack(String msg, {required bool success}) {
  return SnackBar(
    content: Text(msg),
    backgroundColor: success
        ? const Color(0xFF059669)
        : const Color(0xFFDC2626),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
