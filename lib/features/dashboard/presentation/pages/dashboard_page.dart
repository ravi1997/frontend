import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/entities/dashboard_data.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/recent_forms_list.dart';
import '../../../responses/data/services/sync_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../widgets/stats_card_skeleton.dart';
import '../widgets/form_card_skeleton.dart';
import '../../../../core/widgets/app_shimmer.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Redirecting...'));
          }
          final dashboardState = ref.watch(dashboardControllerProvider);

          return Column(
            children: [
              _TopBar(user: user),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(dashboardControllerProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 32,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GreetingSection(user: user),
                            const SizedBox(height: 32),
                            _ActionButtons(user: user),
                            const SizedBox(height: 32),
                            dashboardState.when(
                              data: (data) => _DashboardContent(data: data),
                              loading: () => const _DashboardSkeleton(),
                              error: (e, st) => Center(
                                child: Padding(
                                  padding: EdgeInsets.all(48.0),
                                  child: Column(
                                    children: [
                                      Text('Error loading dashboard: $e'),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => ref
                                            .read(
                                              dashboardControllerProvider
                                                  .notifier,
                                            )
                                            .refresh(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const _GettingStartedSection(),
                          ],
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
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  final dynamic user;
  const _TopBar({required this.user});

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
          Expanded(
            child: Text(
              'MahaSamgrah Setu',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.username,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                user.email ?? 'admin1@example.com',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          const _SyncIndicator(),
          const SizedBox(width: 16),
          _LogoutButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF374151),
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: const Icon(Icons.logout, size: 16),
      label: Text(
        'Logout',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _SyncIndicator extends ConsumerWidget {
  const _SyncIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);
    final connectivity = ref.watch(connectivityServiceProvider);

    return syncState.when(
      data: (_) {
        final count = ref.read(syncServiceProvider.notifier).pendingCount;
        if (count == 0) return const SizedBox.shrink();

        final isOffline = connectivity == ConnectivityStatus.offline;

        return Tooltip(
          message: isOffline
              ? 'You are offline. $count submissions will sync when connected.'
              : 'Synchronizing $count submissions...',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOffline
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOffline
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.blue.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOffline ? Icons.cloud_off : Icons.sync,
                  size: 16,
                  color: isOffline ? Colors.orange : Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  '$count Pending',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOffline ? Colors.orange[800] : Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final dynamic user;
  const _GreetingSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, ${user.username}!',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s what\'s happening with your forms today.',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardData data;
  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatsGrid(data: data),
        const SizedBox(height: 48),
        const _DashboardFilterBar(),
        const SizedBox(height: 24),
        const RecentFormsList(),
      ],
    );
  }
}

class _DashboardFilterBar extends ConsumerWidget {
  const _DashboardFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortBy = ref.watch(dashboardSortByProvider);

    return Row(
      children: [
        Expanded(
          child: TextField(
            key: const Key('dashboard_search_field'),
            onChanged: (value) =>
                ref.read(dashboardSearchQueryProvider.notifier).setQuery(value),
            decoration: InputDecoration(
              hintText: 'Search forms by name...',
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
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              key: const Key('dashboard_sort_dropdown'),
              value: sortBy,
              icon: const Icon(Icons.sort, size: 20, color: Color(0xFF6B7280)),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref.read(dashboardSortByProvider.notifier).setSort(newValue);
                }
              },
              items: <String>['Newest First', 'Oldest First', 'A-Z']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardData data;
  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 24;
        int columns = constraints.maxWidth < 600 ? 1 : 3;
        final double cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            DashboardStatsCard(
              title: 'Total Forms',
              value: data.stats.totalForms.toString(),
              subtitle: 'Forms created',
              icon: Icons.description_outlined,
              width: cardWidth,
            ),
            DashboardStatsCard(
              title: 'Responses',
              value: data.stats.totalResponses.toString(),
              subtitle: 'Total submissions',
              icon: Icons.people_outline,
              width: cardWidth,
            ),
            DashboardStatsCard(
              title: 'Active Forms',
              value: data.stats.activeForms.toString(),
              subtitle: 'Published forms',
              icon: Icons.check_circle_outline,
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final dynamic user;
  const _ActionButtons({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await context.push('/builder/new');
            ref.read(dashboardControllerProvider.notifier).refresh();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 20),
          label: Text(
            'Create New Form',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        if (user.isAdmin)
          ElevatedButton.icon(
            onPressed: () => context.push('/templates/create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF10B981,
              ), // Green for admin action
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.post_add, size: 20),
            label: Text(
              'Create Template',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6), // Purple for AI
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(FontAwesomeIcons.wandMagicSparkles, size: 16),
          label: Text(
            'Generate with AI',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),

        if (user.isAdmin)
          OutlinedButton.icon(
            onPressed: () => context.go('/user-management'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              backgroundColor: const Color(0xFFEFF6FF),
              side: const BorderSide(color: Color(0xFFBFDBFE)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.people_alt_outlined, size: 20),
            label: Text(
              'User Management',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (user.roles.contains('superadmin'))
          ElevatedButton.icon(
            onPressed: () => context.go('/backend-settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.tune, size: 20),
            label: Text(
              'Backend Settings',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.folder_outlined, size: 20),
          label: Text(
            'View All Forms',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _GettingStartedSection extends StatelessWidget {
  const _GettingStartedSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFF5F3FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Getting Started',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Learn how to make the most of MahaSamgrah Setu',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 24;
        int columns = constraints.maxWidth < 600 ? 1 : 3;
        double childWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(
                3,
                (_) => SizedBox(
                  width: childWidth,
                  child: const StatsCardSkeleton(),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Fake Filter Bar
            Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
            ),
            const SizedBox(height: 24),
            // Fake List
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonBox(width: 150, height: 20),
                  const SizedBox(height: 24),
                  ...List.generate(5, (_) => const FormCardSkeleton()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
