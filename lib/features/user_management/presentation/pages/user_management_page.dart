import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controllers/user_management_controller.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../widgets/user_detail_panel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  String _searchQuery = '';
  String _roleFilter = 'All';
  String _statusFilter = 'All';

  static const _roleOptions = [
    'All',
    'admin',
    'superadmin',
    'creator',
    'editor',
    'publisher',
    'deo',
    'manager',
    'user',
  ];
  static const _statusOptions = ['All', 'Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final usersAsync = ref.watch(userManagementControllerProvider);
    final departmentsAsync = ref.watch(departmentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: authState.when(
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              _TopBar(currentUser: currentUser),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(userManagementControllerProvider.notifier)
                      .refreshUsers(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 32,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: usersAsync.when(
                          data: (users) => _buildContent(
                            context,
                            users,
                            departmentsAsync.value ?? [],
                          ),
                          loading: () => const _PageSkeleton(),
                          error: (err, _) => _ErrorState(
                            error: err.toString(),
                            onRetry: () => ref
                                .read(userManagementControllerProvider.notifier)
                                .refreshUsers(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<User> users,
    List<String> departments,
  ) {
    // Apply local filters
    final filtered = users.where((u) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          u.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (u.department ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesRole = _roleFilter == 'All' || u.roles.contains(_roleFilter);

      final matchesStatus =
          _statusFilter == 'All' ||
          (_statusFilter == 'Active' && u.isActive) ||
          (_statusFilter == 'Inactive' && !u.isActive);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    // Stats
    final totalUsers = users.length;
    final activeUsers = users.where((u) => u.isActive).length;
    final adminCount = users.where((u) => u.isAdmin).length;
    final deptCount = users
        .map((u) => u.department ?? '')
        .where((d) => d.isNotEmpty)
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ─────────────────────────────────────────────────────────
        _HeaderSection(totalUsers: totalUsers, context: context),
        const SizedBox(height: 32),

        // ── Stats Cards ──────────────────────────────────────────────────
        _StatsRow(
          totalUsers: totalUsers,
          activeUsers: activeUsers,
          adminCount: adminCount,
          deptCount: deptCount,
        ),
        const SizedBox(height: 32),

        // ── Users Table Card ────────────────────────────────────────────
        _UsersCard(
          users: filtered,
          allUsers: users,
          departments: departments,
          searchQuery: _searchQuery,
          roleFilter: _roleFilter,
          statusFilter: _statusFilter,
          roleOptions: _roleOptions,
          statusOptions: _statusOptions,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          onRoleChanged: (v) => setState(() => _roleFilter = v ?? 'All'),
          onStatusChanged: (v) => setState(() => _statusFilter = v ?? 'All'),
          onUpdateDepartment: (userId, dept) => ref
              .read(userManagementControllerProvider.notifier)
              .updateDepartment(userId, dept),
          onToggleStatus: (userId, current) => ref
              .read(userManagementControllerProvider.notifier)
              .toggleUserStatus(userId, current),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar — identical pattern to DashboardPage._TopBar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final User currentUser;
  const _TopBar({required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.go('/'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _Chevron(),
          const SizedBox(width: 12),
          Text(
            'User Management',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentUser.username,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                currentUser.email,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          OutlinedButton.icon(
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.logout, size: 16),
            label: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();
  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF9CA3AF));
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Section
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final int totalUsers;
  final BuildContext context;
  const _HeaderSection({required this.totalUsers, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Management',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage user accounts, roles, departments, and access control.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row — same card pattern as DashboardStatsCard
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int totalUsers;
  final int activeUsers;
  final int adminCount;
  final int deptCount;

  const _StatsRow({
    required this.totalUsers,
    required this.activeUsers,
    required this.adminCount,
    required this.deptCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 24;
        final int cols = constraints.maxWidth < 600 ? 1 : 4;
        final double w = (constraints.maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _StatCard(
              title: 'Total Users',
              value: '$totalUsers',
              subtitle: 'Registered accounts',
              icon: Icons.people_outline,
              width: w,
            ),
            _StatCard(
              title: 'Active Users',
              value: '$activeUsers',
              subtitle: 'Currently active',
              icon: Icons.check_circle_outline,
              width: w,
            ),
            _StatCard(
              title: 'Admins',
              value: '$adminCount',
              subtitle: 'Admin & superadmin',
              icon: Icons.admin_panel_settings_outlined,
              width: w,
            ),
            _StatCard(
              title: 'Departments',
              value: '$deptCount',
              subtitle: 'Unique departments',
              icon: Icons.business_outlined,
              width: w,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final double? width;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Users Card — white container with filter bar + user rows
// ─────────────────────────────────────────────────────────────────────────────

class _UsersCard extends StatelessWidget {
  final List<User> users;
  final List<User> allUsers;
  final List<String> departments;
  final String searchQuery;
  final String roleFilter;
  final String statusFilter;
  final List<String> roleOptions;
  final List<String> statusOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<String?> onStatusChanged;
  final void Function(String userId, String dept) onUpdateDepartment;
  final void Function(String userId, bool current) onToggleStatus;

  const _UsersCard({
    required this.users,
    required this.allUsers,
    required this.departments,
    required this.searchQuery,
    required this.roleFilter,
    required this.statusFilter,
    required this.roleOptions,
    required this.statusOptions,
    required this.onSearchChanged,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onUpdateDepartment,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Text(
                  'All Users',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${allUsers.length}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Filter Bar ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: _FilterBar(
              searchQuery: searchQuery,
              roleFilter: roleFilter,
              statusFilter: statusFilter,
              roleOptions: roleOptions,
              statusOptions: statusOptions,
              onSearchChanged: onSearchChanged,
              onRoleChanged: onRoleChanged,
              onStatusChanged: onStatusChanged,
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // ── Table Header ─────────────────────────────────────────────
          const _TableHeader(),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // ── User Rows ────────────────────────────────────────────────
          if (users.isEmpty)
            _EmptyState(searchQuery: searchQuery)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, _) =>
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                return _UserRow(
                  user: users[index],
                  departments: departments,
                  onUpdateDepartment: onUpdateDepartment,
                  onToggleStatus: onToggleStatus,
                  context: context,
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Bar — same style as _DashboardFilterBar
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final String searchQuery;
  final String roleFilter;
  final String statusFilter;
  final List<String> roleOptions;
  final List<String> statusOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onRoleChanged;
  final ValueChanged<String?> onStatusChanged;

  const _FilterBar({
    required this.searchQuery,
    required this.roleFilter,
    required this.statusFilter,
    required this.roleOptions,
    required this.statusOptions,
    required this.onSearchChanged,
    required this.onRoleChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search
        Expanded(
          child: TextField(
            key: const Key('user_search_field'),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search by name, email or department…',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF9CA3AF),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: Color(0xFF6B7280),
              ),
              filled: true,
              fillColor: Colors.white,
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
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Role dropdown
        _DropdownFilter<String>(
          value: roleFilter,
          items: roleOptions,
          hint: 'Role',
          onChanged: onRoleChanged,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(width: 12),
        // Status dropdown
        _DropdownFilter<String>(
          value: statusFilter,
          items: statusOptions,
          hint: 'Status',
          onChanged: onStatusChanged,
          icon: Icons.toggle_on_outlined,
        ),
      ],
    );
  }
}

class _DropdownFilter<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const _DropdownFilter({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          onChanged: onChanged,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Table Header
// ─────────────────────────────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'USER',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'DEPARTMENT',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ROLES',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'STATUS',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(width: 120), // Actions column
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User Row
// ─────────────────────────────────────────────────────────────────────────────

class _UserRow extends StatelessWidget {
  final User user;
  final List<String> departments;
  final void Function(String, String) onUpdateDepartment;
  final void Function(String, bool) onToggleStatus;
  final BuildContext context;

  const _UserRow({
    required this.user,
    required this.departments,
    required this.onUpdateDepartment,
    required this.onToggleStatus,
    required this.context,
  });

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          // ── Avatar + Name + Email ──────────────────────────────────
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _avatarColor.withValues(alpha: 0.12),
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
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
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 12,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Department ───────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: Text(
              user.department?.isNotEmpty == true ? user.department! : '—',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: user.department?.isNotEmpty == true
                    ? const Color(0xFF374151)
                    : const Color(0xFF9CA3AF),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── Roles ────────────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: user.roles.take(2).map((role) {
                final isHighRole = role == 'admin' || role == 'superadmin';
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isHighRole
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isHighRole
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF374151),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Status Badge ─────────────────────────────────────────────
          SizedBox(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: user.isActive
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: user.isActive
                          ? const Color(0xFF059669)
                          : const Color(0xFFDC2626),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.isActive ? 'Active' : 'Inactive',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: user.isActive
                          ? const Color(0xFF065F46)
                          : const Color(0xFF991B1B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Action Buttons ───────────────────────────────────────────
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Department
                Tooltip(
                  message: 'Update Department',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showDepartmentDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(
                        Icons.business_outlined,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Toggle Status
                Tooltip(
                  message: user.isActive ? 'Deactivate User' : 'Activate User',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => onToggleStatus(user.id, user.isActive),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: user.isActive
                              ? const Color(0xFFFECACA)
                              : const Color(0xFFBBF7D0),
                        ),
                      ),
                      child: Icon(
                        user.isActive
                            ? Icons.block
                            : Icons.check_circle_outline,
                        size: 16,
                        color: user.isActive
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF059669),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDepartmentDialog(BuildContext context) {
    final controller = TextEditingController(text: user.department);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Department',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user.username,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Department',
                  hintText: 'e.g. Cardiology, Radiology…',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF374151)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                ),
              ),
              if (departments.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Quick select',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: departments
                      .map(
                        (dept) => ActionChip(
                          label: Text(
                            dept,
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          backgroundColor: const Color(0xFFEFF6FF),
                          side: const BorderSide(color: Color(0xFFBFDBFE)),
                          labelStyle: const TextStyle(color: Color(0xFF2563EB)),
                          onPressed: () => controller.text = dept,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF374151),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final dept = controller.text.trim();
              if (dept.isNotEmpty) {
                onUpdateDepartment(user.id, dept);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: Column(
          children: [
            Icon(
              searchQuery.isNotEmpty
                  ? Icons.search_off_outlined
                  : Icons.people_outline,
              size: 48,
              color: const Color(0xFFD1D5DB),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty
                  ? 'No users match your search'
                  : 'No users found',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try adjusting your filters or search query.'
                  : 'Users will appear here once registered.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error State
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              'Failed to load users',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Skeleton — same style as _DashboardSkeleton
// ─────────────────────────────────────────────────────────────────────────────

class _PageSkeleton extends StatelessWidget {
  const _PageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Container(
          height: 32,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 16,
          width: 340,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 32),
        // Stats row skeleton
        LayoutBuilder(
          builder: (ctx, constraints) {
            const spacing = 24.0;
            final w = (constraints.maxWidth - spacing * 3) / 4;
            return Wrap(
              spacing: spacing,
              children: List.generate(4, (_) => _SkeletonCard(width: w)),
            );
          },
        ),
        const SizedBox(height: 32),
        // Table skeleton
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              ...List.generate(
                6,
                (i) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 48,
                  decoration: BoxDecoration(
                    color: i == 0
                        ? const Color(0xFFF3F4F6)
                        : const Color(0xFFF9FAFB),
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
}

class _SkeletonCard extends StatelessWidget {
  final double width;
  const _SkeletonCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 14, width: 80, color: const Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Container(height: 28, width: 48, color: const Color(0xFFD1D5DB)),
          const SizedBox(height: 4),
          Container(height: 12, width: 100, color: const Color(0xFFE5E7EB)),
        ],
      ),
    );
  }
}
