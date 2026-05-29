import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/tokens.dart';
import '../theme/theme_controller.dart';
import '../layout/responsive.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Navigation item definition for the app sidebar.
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

const _navItems = [
  _NavItem(
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view_rounded,
    label: 'Dashboard',
    route: '/',
  ),
  _NavItem(
    icon: Icons.folder_outlined,
    activeIcon: Icons.folder_rounded,
    label: 'Projects',
    route: '/',
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart_rounded,
    label: 'Analytics',
    route: '/',
  ),
];

/// Authenticated app shell.
/// Wraps every authenticated page with a shared [AppTopBar] + sidebar
/// (desktop/laptop) or bottom navigation bar (mobile).
///
/// Usage in router:
/// ```dart
/// ShellRoute(
///   builder: (context, state, child) => AppShell(child: child),
///   routes: [ ... ],
/// )
/// ```
class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = Responsive.of(context);
    final currentLocation = GoRouterState.of(context).uri.toString();

    return switch (screen) {
      ScreenSize.mobile => _MobileShell(
        currentLocation: currentLocation,
        child: child,
      ),
      ScreenSize.tablet => _TabletShell(
        currentLocation: currentLocation,
        child: child,
      ),
      ScreenSize.laptop || ScreenSize.desktop => _DesktopShell(
        currentLocation: currentLocation,
        child: child,
      ),
    };
  }
}

// ─── Desktop / Laptop Shell ───────────────────────────────────────────────────

class _DesktopShell extends ConsumerWidget {
  final Widget child;
  final String currentLocation;
  const _DesktopShell({required this.child, required this.currentLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          AppTopBar(showMenuButton: false),
          Expanded(
            child: Row(
              children: [
                AppSidebar(collapsed: false, currentLocation: currentLocation),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tablet Shell ─────────────────────────────────────────────────────────────

class _TabletShell extends ConsumerStatefulWidget {
  final Widget child;
  final String currentLocation;
  const _TabletShell({required this.child, required this.currentLocation});

  @override
  ConsumerState<_TabletShell> createState() => _TabletShellState();
}

class _TabletShellState extends ConsumerState<_TabletShell> {
  bool _drawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopBar(
            showMenuButton: true,
            onMenuTap: () => setState(() => _drawerOpen = !_drawerOpen),
          ),
          Expanded(
            child: Stack(
              children: [
                Row(
                  children: [
                    AppSidebar(
                      collapsed: true,
                      currentLocation: widget.currentLocation,
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: widget.child),
                  ],
                ),
                // Slide-in full sidebar drawer on top
                if (_drawerOpen)
                  GestureDetector(
                    onTap: () => setState(() => _drawerOpen = false),
                    child: Container(color: Colors.black45),
                  ),
                if (_drawerOpen)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: AppSidebar(
                      collapsed: false,
                      currentLocation: widget.currentLocation,
                      onNavTap: () => setState(() => _drawerOpen = false),
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

// ─── Mobile Shell ─────────────────────────────────────────────────────────────

class _MobileShell extends ConsumerWidget {
  final Widget child;
  final String currentLocation;
  const _MobileShell({required this.child, required this.currentLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    int selectedIndex = 0;
    if (currentLocation.startsWith('/projects')) selectedIndex = 1;
    if (currentLocation.contains('/analytics')) selectedIndex = 2;

    return Scaffold(
      body: Column(
        children: [
          AppTopBar(showMenuButton: false),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: DesignTokens.primary.withValues(alpha: 0.12),
        onDestinationSelected: (i) {
          final routes = ['/', '/', '/'];
          context.go(routes[i]);
        },
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(
                  item.activeIcon,
                  color: DesignTokens.primary,
                ),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─── Shared Top Bar ───────────────────────────────────────────────────────────

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showMenuButton;
  final VoidCallback? onMenuTap;

  const AppTopBar({super.key, this.showMenuButton = false, this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(DesignTokens.navbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = ref.watch(themeControllerProvider) == ThemeMode.dark;

    return Container(
      height: DesignTokens.navbarHeight,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          // Menu / hamburger (tablet only)
          if (showMenuButton)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Toggle menu',
            )
          else
            const SizedBox(width: 16),

          // Logo / App name
          Text(
            'MahaSangrah Setu',
            style: GoogleFonts.inter(
              fontSize: DesignTokens.fontBase,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),

          const Spacer(),

          // Theme toggle
          IconButton(
            onPressed: () =>
                ref.read(themeControllerProvider.notifier).toggle(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                color: cs.onSurface,
              ),
            ),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          ),

          // User avatar / menu
          _UserAvatar(ref: ref),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _UserAvatar extends ConsumerWidget {
  final WidgetRef ref;
  const _UserAvatar({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef r) {
    final authState = r.watch(authControllerProvider);
    final user = authState.asData?.value;
    final initials = user == null
        ? '?'
        : (user.username.isNotEmpty ? user.username[0].toUpperCase() : '?');

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 48),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 18),
              const SizedBox(width: 10),
              Text(
                'Sign out',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
      onSelected: (val) {
        if (val == 'logout') {
          r.read(authControllerProvider.notifier).logout();
        }
      },
      child: CircleAvatar(
        radius: 18,
        backgroundColor: DesignTokens.primary.withValues(alpha: 0.15),
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: DesignTokens.primary,
          ),
        ),
      ),
    );
  }
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────

class AppSidebar extends ConsumerWidget {
  final bool collapsed;
  final String currentLocation;
  final VoidCallback? onNavTap;

  const AppSidebar({
    super.key,
    required this.collapsed,
    required this.currentLocation,
    this.onNavTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final width = collapsed
        ? DesignTokens.sidebarCollapsed
        : DesignTokens.sidebarExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: width,
      color: cs.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ..._navItems.map((item) {
            final active =
                currentLocation == item.route ||
                (item.route != '/' && currentLocation.startsWith(item.route));
            return _SidebarItem(
              item: item,
              active: active,
              collapsed: collapsed,
              onTap: () {
                context.go(item.route);
                onNavTap?.call();
              },
            );
          }),
          const Spacer(),
          const Divider(),
          _SidebarItem(
            item: const _NavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings_rounded,
              label: 'Settings',
              route: '/',
            ),
            active: false,
            collapsed: collapsed,
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final _NavItem item;
  final bool active;
  final bool collapsed;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.item,
    required this.active,
    required this.collapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Tooltip(
        message: collapsed ? item.label : '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: active
                  ? DesignTokens.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  active ? item.activeIcon : item.icon,
                  size: 20,
                  color: active
                      ? DesignTokens.primary
                      : cs.onSurface.withValues(alpha: 0.6),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: GoogleFonts.inter(
                        fontSize: DesignTokens.fontM,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: active
                            ? DesignTokens.primary
                            : cs.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
