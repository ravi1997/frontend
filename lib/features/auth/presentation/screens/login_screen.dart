import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widgets/snackbar_service.dart';
import '../widgets/auth_background.dart';

// ─── Auth Design Tokens ───────────────────────────────────────────────────────
abstract class _AuthTokens {
  // Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFFEEF2FF); // Indigo 50

  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF4F46E5);
  static const Color borderError = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textLink = Color(0xFF4F46E5);

  static const Color divider = Color(0xFFE2E8F0);

  // Gradients
  static const Gradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  // Spacing
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.06),
      blurRadius: 40,
      spreadRadius: 0,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}

// ─── Breakpoints ─────────────────────────────────────────────────────────────
abstract class _BP {
  static const double mobile = 480;
  static const double tablet = 1024;
}

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
    final box = await Hive.openBox('credentials_box');
    final rememberMe = box.get('remember_me', defaultValue: false);
    if (rememberMe) {
      if (mounted) {
        setState(() {
          _emailController.text = box.get('email', defaultValue: '');
          _passwordController.text = box.get('password', defaultValue: '');
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > _BP.tablet;
    final isMobile = width <= _BP.mobile;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref
            .read(snackbarServiceProvider.notifier)
            .showError(next.error.toString());
      }
      if (next is AsyncData && next.value != null && previous is AsyncLoading) {
        if (context.mounted) {
          _formKey.currentState?.reset();
        }
      }
    });

    return AuthBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 32,
          ),
          child: isDesktop
              ? _buildDesktopLayout(authState)
              : _buildStackedLayout(authState, isMobile),
        ),
      ),
    );
  }

  // ─── Desktop: Two-column ──────────────────────────────────────────────────
  Widget _buildDesktopLayout(AsyncValue authState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1140),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: _HeroPanel()),
            const SizedBox(width: 56),
            SizedBox(
              width: 460,
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
            showBrand: true,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final box = await Hive.openBox('credentials_box');
      if (_rememberMe) {
        await box.put('email', _emailController.text);
        await box.put('password', _passwordController.text);
        await box.put('remember_me', true);
      } else {
        await box.delete('email');
        await box.delete('password');
        await box.put('remember_me', false);
      }

      final notifier = ref.read(authControllerProvider.notifier);
      if (_isEmailTab) {
        notifier.login(_emailController.text, _passwordController.text);
      } else {
        final mobile = _phoneController.text;
        await notifier.generateOtp(mobile);
        if (!mounted) return;
        context.push('/verify-otp?mobile=$mobile');
      }
    }
  }
}

// ─── Hero Panel (Desktop Left) ────────────────────────────────────────────────
class _HeroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      decoration: BoxDecoration(
        gradient: _AuthTokens.heroGradient,
        borderRadius: BorderRadius.circular(_AuthTokens.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo mark
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(_AuthTokens.radiusMd),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'MahaSamgrah Setu',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 0.2,
            ),
          ),

          const Spacer(),

          // Main headline
          Text(
            'The most\nintelligent way\nto manage\nyour forms.',
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Streamline data collection, automate workflows, '
            'and gain real-time insights — all from one platform.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // Trust badges
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

          // Decorative bottom element
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(_AuthTokens.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF34D399),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(_AuthTokens.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
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
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.15),
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: isMobile ? 28 : 36,
      ),
      decoration: BoxDecoration(
        gradient: _AuthTokens.heroGradient,
        borderRadius: BorderRadius.circular(_AuthTokens.radiusLg),
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
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
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
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            'Intelligent form\nmanagement, simplified.',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Automate data collection and gain real-time insights.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.75),
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
    required this.showBrand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AuthTokens.surface,
        borderRadius: BorderRadius.circular(_AuthTokens.radiusXl),
        border: Border.all(color: _AuthTokens.border),
        boxShadow: _AuthTokens.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_AuthTokens.radiusXl),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(40),
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
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: _AuthTokens.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue to your workspace.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: _AuthTokens.textSecondary,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      label: 'Remember me checkbox',
                      child: InkWell(
                        onTap: () => onRememberMe(!rememberMe),
                        borderRadius: BorderRadius.circular(
                          _AuthTokens.radiusSm,
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
                                      ? _AuthTokens.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    _AuthTokens.radiusSm - 2,
                                  ),
                                  border: Border.all(
                                    color: rememberMe
                                        ? _AuthTokens.primary
                                        : _AuthTokens.textMuted,
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
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: _AuthTokens.textSecondary,
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
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _AuthTokens.textLink,
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
                    const Expanded(
                      child: Divider(color: _AuthTokens.divider, height: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          letterSpacing: 0.8,
                          color: _AuthTokens.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: _AuthTokens.divider, height: 1),
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
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Sign up link
                Center(
                  child: Semantics(
                    label: 'Navigate to registration page',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: _AuthTokens.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: onSignUp,
                          child: Text(
                            'Create account',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: _AuthTokens.textLink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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

// ─── Brand Row ─────────────────────────────────────────────────────────────────
class _BrandRow extends StatelessWidget {
  final bool small;
  const _BrandRow({this.small = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: small ? 36 : 44,
          height: small ? 36 : 44,
          decoration: BoxDecoration(
            gradient: _AuthTokens.heroGradient,
            borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
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
              style: GoogleFonts.inter(
                fontSize: small ? 15 : 18,
                fontWeight: FontWeight.w800,
                color: _AuthTokens.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            if (!small)
              Text(
                'Enterprise Form Intelligence',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: _AuthTokens.textMuted,
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
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(_AuthTokens.radiusMd),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 8) / 2;
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
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
                      ? _AuthTokens.primary
                      : _AuthTokens.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? _AuthTokens.textPrimary
                        : _AuthTokens.textMuted,
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
    return Column(
      children: [
        _PremiumField(
          controller: emailController,
          label: 'Email address',
          placeholder: 'name@company.com',
          icon: Icons.alternate_email_rounded,
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
        _PremiumField(
          controller: passwordController,
          label: 'Password',
          placeholder: 'Enter your password',
          icon: Icons.lock_outline_rounded,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password is required';
            return null;
          },
          suffixIcon: Semantics(
            label: obscurePassword ? 'Show password' : 'Hide password',
            button: true,
            child: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: _AuthTokens.textMuted,
                size: 18,
              ),
              onPressed: onTogglePassword,
              splashRadius: 18,
            ),
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
    return _PremiumField(
      controller: phoneController,
      label: 'Mobile number',
      placeholder: '9876543210',
      icon: Icons.phone_android_rounded,
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

// ─── Premium Text Field ───────────────────────────────────────────────────────
class _PremiumField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? helperText;

  const _PremiumField({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.helperText,
  });

  @override
  State<_PremiumField> createState() => _PremiumFieldState();
}

class _PremiumFieldState extends State<_PremiumField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _AuthTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            style: GoogleFonts.inter(
              color: _AuthTokens.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  widget.icon,
                  color: _isFocused
                      ? _AuthTokens.primary
                      : _AuthTokens.textMuted,
                  size: 18,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: widget.suffixIcon,
              hintText: widget.placeholder,
              hintStyle: GoogleFonts.inter(
                color: _AuthTokens.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: _isFocused
                  ? _AuthTokens.primaryLight.withValues(alpha: 0.5)
                  : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                borderSide: const BorderSide(color: _AuthTokens.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                borderSide: BorderSide(color: _AuthTokens.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                borderSide: const BorderSide(
                  color: _AuthTokens.borderFocus,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                borderSide: const BorderSide(
                  color: _AuthTokens.borderError,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
                borderSide: const BorderSide(
                  color: _AuthTokens.borderError,
                  width: 2,
                ),
              ),
              errorStyle: GoogleFonts.inter(
                fontSize: 12,
                color: _AuthTokens.borderError,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _AuthTokens.textMuted,
            ),
          ),
        ],
      ],
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

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered && !widget.isLoading
                  ? [const Color(0xFF4338CA), const Color(0xFF6D28D9)]
                  : [_AuthTokens.primary, const Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
            boxShadow: widget.isLoading ? [] : _AuthTokens.buttonShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
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
                            style: GoogleFonts.inter(
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
  final IconData icon;
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

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Sign in with ${widget.label}',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 46,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
            borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
            border: Border.all(
              color: _isHovered ? const Color(0xFFCBD5E1) : _AuthTokens.border,
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
              borderRadius: BorderRadius.circular(_AuthTokens.radiusSm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(widget.icon, size: 15, color: _AuthTokens.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: _AuthTokens.textPrimary,
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
