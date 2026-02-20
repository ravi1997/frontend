import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final systemSettingsProvider =
    AsyncNotifierProvider<SystemSettingsNotifier, Map<String, dynamic>>(
      SystemSettingsNotifier.new,
    );

class SystemSettingsNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() => _fetch();

  Future<Map<String, dynamic>> _fetch() async {
    final client = ref.read(apiClientProvider);
    // Full URL — pass empty-string path with baseUrl override
    final resp = await client.get<dynamic>(
      ApiEndpoints.systemSettingsGet,
      options: Options(extra: {'baseUrlOverride': true}),
    );
    return Map<String, dynamic>.from(resp.data as Map);
  }

  Future<void> updateSettings(Map<String, dynamic> patch) async {
    final client = ref.read(apiClientProvider);
    final resp = await client.patch<dynamic>(
      ApiEndpoints.systemSettingsPatch,
      data: patch,
      options: Options(extra: {'baseUrlOverride': true}),
    );
    final updated = Map<String, dynamic>.from(resp.data['settings'] as Map);
    state = AsyncData(updated);
  }

  Future<void> resetToDefaults() async {
    state = const AsyncLoading();
    final client = ref.read(apiClientProvider);
    final resp = await client.post<dynamic>(
      ApiEndpoints.systemSettingsReset,
      options: Options(extra: {'baseUrlOverride': true}),
    );
    final fresh = Map<String, dynamic>.from(resp.data['settings'] as Map);
    state = AsyncData(fresh);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class BackendSettingsPage extends ConsumerWidget {
  const BackendSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final settingsAsync = ref.watch(systemSettingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          // Guard: superadmin only
          if (!user.roles.contains('superadmin')) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Access Restricted',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This page is accessible to superadmins only.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Return to Dashboard'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _TopBar(username: user.username, email: user.email),
              Expanded(
                child: settingsAsync.when(
                  data: (settings) => _SettingsBody(settings: settings),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                  ),
                  error: (e, _) => _ErrorState(
                    error: e.toString(),
                    onRetry: () => ref.invalidate(systemSettingsProvider),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Auth error: $e')),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top Bar
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final String username;
  final String email;
  const _TopBar({required this.username, required this.email});

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
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tune, size: 14, color: Color(0xFF7C3AED)),
                const SizedBox(width: 6),
                Text(
                  'Backend Settings',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                username,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                email,
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

// ─────────────────────────────────────────────────────────────────────────────
// Settings Body (tabbed layout)
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsBody extends ConsumerStatefulWidget {
  final Map<String, dynamic> settings;
  const _SettingsBody({required this.settings});

  @override
  ConsumerState<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends ConsumerState<_SettingsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _draft;
  bool _saving = false;
  String? _successMsg;
  String? _errorMsg;

  static const _tabs = [
    (label: 'Auth & JWT', icon: Icons.key_outlined),
    (label: 'Cache', icon: Icons.memory_outlined),
    (label: 'AI & LLM', icon: Icons.auto_awesome_outlined),
    (label: 'Redis', icon: Icons.storage_outlined),
    (label: 'Upload', icon: Icons.upload_file_outlined),
    (label: 'Security', icon: Icons.security_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _draft = Map<String, dynamic>.from(widget.settings);
  }

  @override
  void didUpdateWidget(covariant _SettingsBody old) {
    super.didUpdateWidget(old);
    _draft = Map<String, dynamic>.from(widget.settings);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _set(String key, dynamic value) {
    setState(() {
      _draft[key] = value;
      _successMsg = null;
      _errorMsg = null;
    });
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _successMsg = null;
      _errorMsg = null;
    });
    try {
      await ref.read(systemSettingsProvider.notifier).updateSettings(_draft);
      setState(() => _successMsg = 'Settings saved successfully!');
    } on DioException catch (e) {
      final msg =
          e.response?.data?['error'] ??
          e.response?.data?['message'] ??
          e.message;
      setState(() => _errorMsg = 'Save failed: $msg');
    } catch (e) {
      setState(() => _errorMsg = 'Save failed: $e');
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Reset to Factory Defaults?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'All settings will be reverted to their original defaults. '
          'This cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() {
        _saving = true;
        _successMsg = null;
        _errorMsg = null;
      });
      try {
        await ref.read(systemSettingsProvider.notifier).resetToDefaults();
        setState(() => _successMsg = 'Settings reset to factory defaults.');
      } catch (e) {
        setState(() => _errorMsg = 'Reset failed: $e');
      } finally {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────
              _PageHeader(onReset: _confirmReset, saving: _saving),
              const SizedBox(height: 8),

              // ── Last updated ──────────────────────────────────────────
              if (_draft['updated_at'] != null)
                Text(
                  'Last updated: ${_draft['updated_at']} by ${_draft['updated_by'] ?? 'system'}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              const SizedBox(height: 24),

              // ── Feedback banners ─────────────────────────────────────
              if (_successMsg != null)
                _Banner(
                  message: _successMsg!,
                  isError: false,
                  onDismiss: () => setState(() => _successMsg = null),
                ),
              if (_errorMsg != null)
                _Banner(
                  message: _errorMsg!,
                  isError: true,
                  onDismiss: () => setState(() => _errorMsg = null),
                ),

              // ── Tab bar + panels ──────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: const Color(0xFF7C3AED),
                        unselectedLabelColor: const Color(0xFF6B7280),
                        indicatorColor: const Color(0xFF7C3AED),
                        indicatorWeight: 2,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
                        tabs: _tabs
                            .map(
                              (t) => Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(t.icon, size: 16),
                                    const SizedBox(width: 6),
                                    Text(t.label),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    // Tab Panels
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _AuthJwtPanel(draft: _draft, onSet: _set),
                          _CachePanel(draft: _draft, onSet: _set),
                          _LlmPanel(draft: _draft, onSet: _set),
                          _RedisPanel(draft: _draft, onSet: _set),
                          _UploadPanel(draft: _draft, onSet: _set),
                          _SecurityPanel(draft: _draft, onSet: _set),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Save button ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _confirmReset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.restore, size: 18),
                    label: Text(
                      'Reset to Defaults',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      _saving ? 'Saving…' : 'Save All Changes',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page header
// ─────────────────────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final VoidCallback onReset;
  final bool saving;
  const _PageHeader({required this.onReset, required this.saving});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backend Settings',
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure server-side behaviour: token expiry, cache, AI/LLM, Redis, uploads, and security. Changes take effect immediately.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner (success / error)
// ─────────────────────────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;
  const _Banner({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isError ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5);
    final fg = isError ? const Color(0xFF991B1B) : const Color(0xFF065F46);
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? const Color(0xFFFCA5A5) : const Color(0xFF6EE7B7),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            color: fg,
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared field widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsPanel extends StatelessWidget {
  final List<Widget> children;
  const _SettingsPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Integer field row
class _IntField extends StatefulWidget {
  final String label;
  final String hint;
  final String fieldKey;
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  final String? suffix;

  const _IntField({
    required this.label,
    required this.hint,
    required this.fieldKey,
    required this.draft,
    required this.onSet,
    this.suffix,
  });

  @override
  State<_IntField> createState() => _IntFieldState();
}

class _IntFieldState extends State<_IntField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: (widget.draft[widget.fieldKey] ?? '').toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _IntField old) {
    super.didUpdateWidget(old);
    if (old.draft[old.fieldKey] != widget.draft[widget.fieldKey]) {
      _ctrl.text = (widget.draft[widget.fieldKey] ?? '').toString();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  widget.hint,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) widget.onSet(widget.fieldKey, parsed);
              },
              decoration: InputDecoration(
                suffixText: widget.suffix,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
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
                    color: Color(0xFF7C3AED),
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// String field row
class _StrField extends StatefulWidget {
  final String label;
  final String hint;
  final String fieldKey;
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;

  const _StrField({
    required this.label,
    required this.hint,
    required this.fieldKey,
    required this.draft,
    required this.onSet,
  });

  @override
  State<_StrField> createState() => _StrFieldState();
}

class _StrFieldState extends State<_StrField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: (widget.draft[widget.fieldKey] ?? '').toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _StrField old) {
    super.didUpdateWidget(old);
    if (old.draft[old.fieldKey] != widget.draft[widget.fieldKey]) {
      _ctrl.text = (widget.draft[widget.fieldKey] ?? '').toString();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  widget.hint,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => widget.onSet(widget.fieldKey, v),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
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
                    color: Color(0xFF7C3AED),
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle (bool) row
class _BoolField extends StatelessWidget {
  final String label;
  final String hint;
  final String fieldKey;
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;

  const _BoolField({
    required this.label,
    required this.hint,
    required this.fieldKey,
    required this.draft,
    required this.onSet,
  });

  @override
  Widget build(BuildContext context) {
    final value = draft[fieldKey] as bool? ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  hint,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) => onSet(fieldKey, v),
            activeThumbColor: const Color(0xFF7C3AED),
            activeTrackColor: const Color(0xFFEDE9FE),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab Panels
// ─────────────────────────────────────────────────────────────────────────────

class _AuthJwtPanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _AuthJwtPanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'Authentication & JWT Settings',
          subtitle:
              'Control token lifetimes, password policy, and account lockout.',
        ),
        _IntField(
          label: 'Access Token Expiry',
          hint: 'Time before JWT access tokens expire',
          fieldKey: 'jwt_access_token_expires_minutes',
          draft: draft,
          onSet: onSet,
          suffix: 'min',
        ),
        _IntField(
          label: 'Refresh Token Expiry',
          hint: 'Time before JWT refresh tokens expire',
          fieldKey: 'jwt_refresh_token_expires_days',
          draft: draft,
          onSet: onSet,
          suffix: 'days',
        ),
        _IntField(
          label: 'Max Failed Login Attempts',
          hint: 'Account locks after this many failures',
          fieldKey: 'max_failed_login_attempts',
          draft: draft,
          onSet: onSet,
          suffix: 'attempts',
        ),
        _IntField(
          label: 'Account Lock Duration',
          hint: 'How long an account remains locked after max failures',
          fieldKey: 'account_lock_duration_hours',
          draft: draft,
          onSet: onSet,
          suffix: 'hrs',
        ),
        _IntField(
          label: 'Password Expiration',
          hint: 'Force password change after this many days (0 = never)',
          fieldKey: 'password_expiration_days',
          draft: draft,
          onSet: onSet,
          suffix: 'days',
        ),
        _IntField(
          label: 'OTP Expiration',
          hint: 'OTP codes expire after this many minutes',
          fieldKey: 'otp_expiration_minutes',
          draft: draft,
          onSet: onSet,
          suffix: 'min',
        ),
        _IntField(
          label: 'Max OTP Resends',
          hint: 'Account locked after this many OTP resend requests',
          fieldKey: 'max_otp_resends',
          draft: draft,
          onSet: onSet,
          suffix: 'times',
        ),
      ],
    );
  }
}

class _CachePanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _CachePanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'Cache Settings',
          subtitle:
              'Control Redis cache behaviour and TTLs for different data types.',
        ),
        _BoolField(
          label: 'Cache Enabled',
          hint: 'Master toggle for the Redis cache layer',
          fieldKey: 'cache_enabled',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Default TTL',
          hint: 'Default cache time-to-live for uncategorised keys',
          fieldKey: 'cache_default_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'Form Schema TTL',
          hint: 'How long form schema definitions are cached',
          fieldKey: 'cache_form_schema_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'User Session TTL',
          hint: 'How long user session data is cached',
          fieldKey: 'cache_user_session_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'Query Result TTL',
          hint: 'How long database query results are cached',
          fieldKey: 'cache_query_result_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'Dashboard Widget TTL',
          hint: 'How long dashboard aggregations are cached',
          fieldKey: 'cache_dashboard_widget_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'API Response TTL',
          hint: 'How long generic API responses are cached',
          fieldKey: 'cache_api_response_ttl_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
      ],
    );
  }
}

class _LlmPanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _LlmPanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'AI / LLM Settings',
          subtitle:
              'Configure the language model provider and Ollama connection pool.',
        ),
        _StrField(
          label: 'LLM Provider',
          hint: 'e.g. ollama, openai',
          fieldKey: 'llm_provider',
          draft: draft,
          onSet: onSet,
        ),
        _StrField(
          label: 'LLM API URL',
          hint: 'Base URL for the LLM API endpoint',
          fieldKey: 'llm_api_url',
          draft: draft,
          onSet: onSet,
        ),
        _StrField(
          label: 'LLM Model',
          hint: 'Model name to use for generation (e.g. llama3)',
          fieldKey: 'llm_model',
          draft: draft,
          onSet: onSet,
        ),
        _StrField(
          label: 'Ollama API URL',
          hint: 'Direct connection URL for Ollama',
          fieldKey: 'ollama_api_url',
          draft: draft,
          onSet: onSet,
        ),
        _StrField(
          label: 'Ollama Embedding Model',
          hint: 'Embedding model for vector search (e.g. nomic-embed-text)',
          fieldKey: 'ollama_embedding_model',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Ollama Pool Size',
          hint: 'Max concurrent Ollama connections',
          fieldKey: 'ollama_pool_size',
          draft: draft,
          onSet: onSet,
          suffix: 'conns',
        ),
        _IntField(
          label: 'Ollama Pool Timeout',
          hint: 'Seconds to wait for a pool connection',
          fieldKey: 'ollama_pool_timeout_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
        _IntField(
          label: 'Ollama Connection Timeout',
          hint: 'TCP connection timeout to Ollama',
          fieldKey: 'ollama_connection_timeout_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
      ],
    );
  }
}

class _RedisPanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _RedisPanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'Redis Configuration',
          subtitle:
              'Connection settings for the Redis server used for caching.',
        ),
        _StrField(
          label: 'Redis Host',
          hint: 'Redis server hostname or IP',
          fieldKey: 'redis_host',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Redis Port',
          hint: 'Redis server port (default 6379)',
          fieldKey: 'redis_port',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Redis DB Index',
          hint: 'Redis logical database number (0-15)',
          fieldKey: 'redis_db',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Max Connections',
          hint: 'Maximum Redis connection pool size',
          fieldKey: 'redis_max_connections',
          draft: draft,
          onSet: onSet,
          suffix: 'conns',
        ),
        _IntField(
          label: 'Socket Timeout',
          hint: 'Seconds before a Redis socket operation times out',
          fieldKey: 'redis_socket_timeout_seconds',
          draft: draft,
          onSet: onSet,
          suffix: 'sec',
        ),
      ],
    );
  }
}

class _UploadPanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _UploadPanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'File Upload Settings',
          subtitle: 'Control maximum upload sizes and permitted file types.',
        ),
        _IntField(
          label: 'Max Upload Size',
          hint: 'Maximum single-file upload size',
          fieldKey: 'max_upload_size_mb',
          draft: draft,
          onSet: onSet,
          suffix: 'MB',
        ),
        _StrField(
          label: 'Allowed Extensions',
          hint: 'Comma-separated list: pdf,docx,jpg,png,mp4 …',
          fieldKey: 'allowed_upload_extensions',
          draft: draft,
          onSet: onSet,
        ),
      ],
    );
  }
}

class _SecurityPanel extends StatelessWidget {
  final Map<String, dynamic> draft;
  final void Function(String, dynamic) onSet;
  const _SecurityPanel({required this.draft, required this.onSet});

  @override
  Widget build(BuildContext context) {
    return _SettingsPanel(
      children: [
        const _SectionTitle(
          title: 'Security & CORS',
          subtitle: 'Application-level security switches and rate limiting.',
        ),
        _BoolField(
          label: 'CORS Enabled',
          hint: 'Allow cross-origin requests from configured origins',
          fieldKey: 'cors_enabled',
          draft: draft,
          onSet: onSet,
        ),
        _BoolField(
          label: 'Debug Mode',
          hint: 'Enable verbose logging and debug endpoints (disable in prod!)',
          fieldKey: 'debug_mode',
          draft: draft,
          onSet: onSet,
        ),
        _BoolField(
          label: 'Rate Limiting',
          hint: 'Protect API endpoints from brute-force and abuse',
          fieldKey: 'rate_limit_enabled',
          draft: draft,
          onSet: onSet,
        ),
        _IntField(
          label: 'Rate Limit (per minute)',
          hint: 'Max requests per IP per minute when rate limiting is on',
          fieldKey: 'rate_limit_requests_per_minute',
          draft: draft,
          onSet: onSet,
          suffix: 'req/min',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              'Failed to load settings',
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
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
