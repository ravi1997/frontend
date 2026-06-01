import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:frontend/shared/widgets/snackbar.dart';
import '../controllers/auth_controller.dart';
import '../controllers/otp_controller.dart';
import '../widgets/auth_widgets.dart';

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

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider).showError(next.error.toString());
      }
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.brandBlue, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(color: Colors.white),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
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
              const CircularProgressIndicator()
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textGrey,
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
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: resendTimer == 0
                            ? AppColors.brandBlue
                            : AppColors.textGrey.withValues(alpha: 0.5),
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
