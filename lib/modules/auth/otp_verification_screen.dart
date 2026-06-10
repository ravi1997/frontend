import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'auth_controller.dart';
import 'auth_widgets.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String mobile;

  const OtpVerificationScreen({super.key, required this.mobile});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final otpNotifier = ref.read(otpControllerProvider.notifier);
      if (ref.read(otpControllerProvider) == 0) {
        otpNotifier.startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final resendTimer = ref.watch(otpControllerProvider);
    final otpNotifier = ref.read(otpControllerProvider.notifier);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider).showError(next.error.toString());
      }
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(color: theme.colorScheme.outline, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: theme.colorScheme.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: theme.colorScheme.surface,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: AuthCardScaffold(
        headerIcon: Icons.phonelink_lock,
        title: 'Verify Mobile',
        subtitle: 'We have sent a 6-digit code to +91 ${widget.mobile}',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              onCompleted: (pin) {
                ref
                    .read(authControllerProvider.notifier)
                    .loginWithOtp(widget.mobile, pin);
              },
            ),
            const SizedBox(height: 48),
            if (authState.isLoading)
              CircularProgressIndicator(color: theme.colorScheme.primary)
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                    ),
                  ),
                  TextButton(
                    onPressed: resendTimer == 0
                        ? () => otpNotifier.resendOtp(widget.mobile)
                        : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      resendTimer == 0
                          ? 'Resend'
                          : 'Resend in ${resendTimer}s',
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: resendTimer == 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.45,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
