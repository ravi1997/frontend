import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../controllers/otp_controller.dart';
import '../../../../core/widgets/snackbar_service.dart'; // Added import

class OtpVerificationScreen extends ConsumerWidget {
  final String mobile;

  const OtpVerificationScreen({super.key, required this.mobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final resendTimer = ref.watch(otpControllerProvider);
    final otpNotifier = ref.read(otpControllerProvider.notifier);

    ref.listen(authControllerProvider, (previous, next) { // Added listener
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider.notifier).showError(next.error.toString());
      }
    });

    // Initial timer start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (resendTimer == 0) otpNotifier.startTimer();
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue.withOpacity(0.1), // Corrected
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phonelink_lock,
                    color: AppColors.brandBlue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Verify Mobile',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                    children: [
                      const TextSpan(text: 'We have sent a 6-digit code to\n'),
                      TextSpan(
                        text: '+91 $mobile',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onCompleted: (pin) {
                    ref
                        .read(authControllerProvider.notifier)
                        .loginWithOtp(mobile, pin);
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
                      GestureDetector(
                        onTap: resendTimer == 0
                            ? () => otpNotifier.resendOtp(mobile)
                            : null,
                        child: Text(
                          resendTimer == 0
                              ? 'Resend'
                              : 'Resend in ${resendTimer}s',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: resendTimer == 0
                                ? AppColors.brandBlue
                                : AppColors.textGrey.withOpacity(0.5), // Corrected
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
        ),
      ),
    );
  }
}
