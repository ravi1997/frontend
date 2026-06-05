import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/theme/app_colors.dart';
import 'package:frontend/shared/widgets/snackbar.dart';
import 'auth_controller.dart';
import 'auth_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider).showError(next.error.toString());
      } else if (next is AsyncData &&
          next.value != null &&
          previous is AsyncLoading &&
          context.mounted) {
        ref
            .read(snackbarServiceProvider)
            .showSuccess('Reset link sent to your email');
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            context.go('/login');
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthCardScaffold(
        headerIcon: Icons.lock_reset_rounded,
        title: 'Forgot Password?',
        subtitle: 'No worries, we\'ll send you reset instructions.',
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthTextFormField(
                controller: _emailController,
                label: 'Email Address',
                placeholder: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .requestPasswordReset(_emailController.text);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Reset Password',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Back to Login',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.bold,
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
