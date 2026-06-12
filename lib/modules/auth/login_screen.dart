import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;
import 'package:frontend/core/networking/dio_provider.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/responsive.dart';
import 'auth_widgets.dart';
import 'package:frontend/core/networking/token_service.dart';

// ─── Login Screen ─────────────────────────────────────────────────────────────
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEmailTab = true;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  late AnimationController _tabAnimController;
  late Animation<double> _tabAnimation;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _tabAnimation = CurvedAnimation(
      parent: _tabAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _tabAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    // Check and clear tokens if expired
    await ref.read(tokenServiceProvider.notifier).checkAndClearIfExpired();

    final box = await Hive.openBox('credentials_box');
    final rememberMe = box.get('remember_me', defaultValue: false);
    if (rememberMe) {
      if (mounted) {
        setState(() {
          _emailController.text = box.get('email', defaultValue: '');
          _rememberMe = rememberMe;
        });
      }
    }
  }

  void _switchTab(bool toEmail) {
    if (_isEmailTab == toEmail) return;
    setState(() => _isEmailTab = toEmail);
    if (toEmail) {
      _tabAnimController.reverse();
    } else {
      _tabAnimController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final screenSize = Responsive.of(context);
    final isDesktop =
        screenSize == ScreenSize.laptop ||
        screenSize == ScreenSize.desktop ||
        screenSize == ScreenSize.wide;
    final isMobile = screenSize == ScreenSize.mobile;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider).showError(next.error.toString());
      }
      if (next is AsyncData && next.value != null && previous is AsyncLoading) {
        if (context.mounted) {
          _formKey.currentState?.reset();
          context.go('/');
        }
      }
    });

    return AuthBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1280 : 560),
            child: isDesktop
                ? _buildDesktopLayout(authState)
                : _buildStackedLayout(authState, isMobile),
          ),
        ),
      ),
    );
  }

  // ─── Desktop: Two-column ──────────────────────────────────────────────────
  Widget _buildDesktopLayout(AsyncValue authState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1280),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: _HeroPanel()),
            const SizedBox(width: 56),
            SizedBox(
              width: 480,
              child: _LoginCard(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                phoneController: _phoneController,
                isEmailTab: _isEmailTab,
                obscurePassword: _obscurePassword,
                rememberMe: _rememberMe,
                authState: authState,
                tabAnimation: _tabAnimation,
                onSwitchTab: _switchTab,
                onTogglePassword: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                onRememberMe: (v) => setState(() => _rememberMe = v ?? false),
                onLogin: _handleLogin,
                onForgotPassword: () => context.push('/forgot-password'),
                onSignUp: () => context.push('/register'),
                onSsoLogin: _handleSsoLogin,
                showBrand: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tablet / Mobile: Stacked ─────────────────────────────────────────────
  Widget _buildStackedLayout(AsyncValue authState, bool isMobile) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          _CompactHero(isMobile: isMobile),
          SizedBox(height: isMobile ? 24 : 32),
          _LoginCard(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            phoneController: _phoneController,
            isEmailTab: _isEmailTab,
            obscurePassword: _obscurePassword,
            rememberMe: _rememberMe,
            authState: authState,
            tabAnimation: _tabAnimation,
            onSwitchTab: _switchTab,
            onTogglePassword: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            onRememberMe: (v) => setState(() => _rememberMe = v ?? false),
            onLogin: _handleLogin,
            onForgotPassword: () => context.push('/forgot-password'),
            onSignUp: () => context.push('/register'),
            onSsoLogin: _handleSsoLogin,
            showBrand: true,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSsoLogin() async {
    try {
      final apiClient = ref.read(dioProvider);
      final response = await apiClient.get('/auth/oidc/login?organization_id=default');
      final authUrl = response.data['data']['auth_url'] as String;
      if (kIsWeb) {
        web.window.location.href = authUrl;
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Failed to initiate SSO: $e');
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final box = await Hive.openBox('credentials_box');
      if (_rememberMe) {
        await box.put('email', _emailController.text);
        await box.put('remember_me', true);
      } else {
        await box.delete('email');
        await box.put('remember_me', false);
      }

      final notifier = ref.read(authControllerProvider.notifier);
      if (_isEmailTab) {
        await notifier.login(_emailController.text, _passwordController.text);
      } else {
        final mobile = _phoneController.text.trim();
        await notifier.requestOtp(mobile);
        if (!mounted) return;
        if (ref.read(authControllerProvider) is AsyncError) return;
        context.push('/verify-otp?mobile=$mobile');
      }
    }
  }
}

// ─── Hero Panel (Desktop Left) ────────────────────────────────────────────────
class _HeroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceXXL,
        vertical: 56,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              border: Border.all(color: onPrimary.withValues(alpha: 0.25)),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spaceS + 4),
          Text(
            'MahaSamgrah Setu',
            style: textTheme.labelLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: onPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          Text(
            'The most\nintelligent way\nto manage\nyour forms.',
            style: textTheme.displayLarge?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: onPrimary,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Streamline data collection, automate workflows, '
            'and gain real-time insights — all from one platform.',
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: onPrimary.withValues(alpha: 0.95),
              height: 1.6,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceXXL),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _TrustBadge('Enterprise Ready'),
              _TrustBadge('SOC 2 Compliant'),
              _TrustBadge('99.9% Uptime'),
            ],
          ),
          const Spacer(),
          _HeroDecorativeStats(),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String label;
  const _TrustBadge(this.label);

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        border: Border.all(color: onPrimary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: DesignTokens.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDecorativeStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(color: onPrimary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          _StatChip(label: 'Forms Created', value: '2.4M+'),
          _VerticalDivider(),
          _StatChip(label: 'Responses Daily', value: '180K'),
          _VerticalDivider(),
          _StatChip(label: 'Organizations', value: '3,800+'),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      width: 1,
      height: 32,
      color: onPrimary.withValues(alpha: 0.15),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: onPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 11,
              color: onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Compact Hero (Tablet/Mobile) ────────────────────────────────────────────
class _CompactHero extends StatelessWidget {
  final bool isMobile;
  const _CompactHero({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.spaceL : DesignTokens.spaceXL,
        vertical: isMobile ? 28 : 36,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  border: Border.all(color: onPrimary.withValues(alpha: 0.25)),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'MahaSamgrah Setu',
                style: textTheme.labelLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: onPrimary,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            'Intelligent form\nmanagement, simplified.',
            style: textTheme.displaySmall?.copyWith(
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w800,
              color: onPrimary,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Automate data collection and gain real-time insights.',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color: onPrimary.withValues(alpha: 0.75),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Login Card ───────────────────────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final bool isEmailTab;
  final bool obscurePassword;
  final bool rememberMe;
  final AsyncValue authState;
  final Animation<double> tabAnimation;
  final void Function(bool) onSwitchTab;
  final VoidCallback onTogglePassword;
  final void Function(bool?) onRememberMe;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onSsoLogin;
  final bool showBrand;

  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.isEmailTab,
    required this.obscurePassword,
    required this.rememberMe,
    required this.authState,
    required this.tabAnimation,
    required this.onSwitchTab,
    required this.onTogglePassword,
    required this.onRememberMe,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onSsoLogin,
    required this.showBrand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenSize = Responsive.of(context);
    final cardPadding = screenSize == ScreenSize.mobile
        ? DesignTokens.spaceL
        : DesignTokens.spaceXXL;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand (mobile/tablet only)
                if (showBrand) ...[
                  _BrandRow(small: true),
                  const SizedBox(height: 28),
                ],

                // Header
                Text(
                  'Welcome back',
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue to your workspace.',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                // Segmented toggle
                _AnimatedSegmentedToggle(
                  isEmailTab: isEmailTab,
                  onSwitch: onSwitchTab,
                ),

                const SizedBox(height: 24),

                // Fields
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: isEmailTab
                      ? _EmailFields(
                          key: const ValueKey('email'),
                          emailController: emailController,
                          passwordController: passwordController,
                          obscurePassword: obscurePassword,
                          onTogglePassword: onTogglePassword,
                        )
                      : _PhoneField(
                          key: const ValueKey('phone'),
                          phoneController: phoneController,
                        ),
                ),

                const SizedBox(height: 16),

                // Remember + Forgot
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Semantics(
                      label: 'Remember me checkbox',
                      child: InkWell(
                        onTap: () => onRememberMe(!rememberMe),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusS,
                        ),
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: rememberMe
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusS - 2,
                                  ),
                                  border: Border.all(
                                    color: rememberMe
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.45),
                                    width: 1.5,
                                  ),
                                ),
                                child: rememberMe
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.72,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onForgotPassword,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // CTA Button
                _PrimaryButton(
                  isLoading: authState.isLoading,
                  label: isEmailTab ? 'Sign in' : 'Send OTP',
                  onPressed: onLogin,
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          letterSpacing: 0.8,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.55,
                          ),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline,
                        height: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Social buttons
                Row(
                  children: [
                    Expanded(
                      child: _SocialButton(
                        icon: FontAwesomeIcons.building,
                        label: 'Login with AIIMS SSO',
                        onTap: onSsoLogin,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Sign up link
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13.5,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onSignUp,
                        child: Semantics(
                          label: 'Create account',
                          button: true,
                          child: Text(
                            'Create account',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 13.5,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Brand Row ─────────────────────────────────────────────────────────────────
class _BrandRow extends StatelessWidget {
  final bool small;
  const _BrandRow({this.small = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Container(
          width: small ? 36 : 44,
          height: small ? 36 : 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          child: Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: small ? 18 : 22,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MahaSamgrah Setu',
              style: textTheme.titleMedium?.copyWith(
                fontSize: small ? 15 : 18,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
            if (!small)
              Text(
                'Enterprise Form Intelligence',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Animated Segmented Toggle ────────────────────────────────────────────────
class _AnimatedSegmentedToggle extends StatefulWidget {
  final bool isEmailTab;
  final void Function(bool) onSwitch;

  const _AnimatedSegmentedToggle({
    required this.isEmailTab,
    required this.onSwitch,
  });

  @override
  State<_AnimatedSegmentedToggle> createState() =>
      _AnimatedSegmentedToggleState();
}

class _AnimatedSegmentedToggleState extends State<_AnimatedSegmentedToggle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              // Animated pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                left: widget.isEmailTab ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // Tabs row
              Row(
                children: [
                  _ToggleTab(
                    label: 'Email / Username',
                    icon: Icons.alternate_email_rounded,
                    isSelected: widget.isEmailTab,
                    onTap: () => widget.onSwitch(true),
                  ),
                  _ToggleTab(
                    label: 'Phone (OTP)',
                    icon: Icons.phone_android_rounded,
                    isSelected: !widget.isEmailTab,
                    onTap: () => widget.onSwitch(false),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Semantics(
        label: label,
        selected: isSelected,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 12.5,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Email Fields ─────────────────────────────────────────────────────────────
class _EmailFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const _EmailFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AuthTextFormField(
          controller: emailController,
          label: 'Email address',
          placeholder: 'name@company.com',
          prefixIcon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextFormField(
          controller: passwordController,
          label: 'Password',
          placeholder: 'Enter your password',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password is required';
            return null;
          },
          suffixIcon: IconButton(
            tooltip: obscurePassword ? 'Show password' : 'Hide password',
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              size: 18,
            ),
            onPressed: onTogglePassword,
            splashRadius: 18,
          ),
        ),
      ],
    );
  }
}

// ─── Phone Field ──────────────────────────────────────────────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController phoneController;

  const _PhoneField({super.key, required this.phoneController});

  @override
  Widget build(BuildContext context) {
    return AuthTextFormField(
      controller: phoneController,
      label: 'Mobile number',
      placeholder: '9876543210',
      prefixIcon: Icons.phone_android_rounded,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Mobile number is required';
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Enter a valid 10-digit mobile number';
        }
        return null;
      },
      helperText: 'We\'ll send a one-time password to this number.',
    );
  }
}

// ─── Primary Button ───────────────────────────────────────────────────────────
class _PrimaryButton extends StatefulWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isHovered = false;

  void _setHovered(bool hovered) {
    if (!mounted || _isHovered == hovered) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isHovered != hovered) {
        setState(() => _isHovered = hovered);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: widget.label,
      button: true,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered && !widget.isLoading
                  ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                  : [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            boxShadow: widget.isLoading
                ? []
                : [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Social Button ────────────────────────────────────────────────────────────
class _SocialButton extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  void _setHovered(bool hovered) {
    if (!mounted || _isHovered == hovered) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isHovered != hovered) {
        setState(() => _isHovered = hovered);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Sign in with ${widget.label}',
      button: true,
      child: MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 46,
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.surfaceContainerHighest
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.outline
                  : theme.colorScheme.outline,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    widget.icon,
                    size: 15,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
