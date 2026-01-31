import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widgets/snackbar_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _employeeIdController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncData && next.value == null && previous is AsyncLoading) {
        ref
            .read(snackbarServiceProvider.notifier)
            .showSuccess('Account created successfully! Please sign in.');
        context.go('/login');
      } else if (next is AsyncError) {
        ref
            .read(snackbarServiceProvider.notifier)
            .showError(next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create Account',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to start creating and managing forms',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _RegisterTextField(
                    controller: _usernameController,
                    label: 'Username',
                    placeholder: 'johndoe',
                  ),
                  const SizedBox(height: 20),
                  _RegisterTextField(
                    controller: _emailController,
                    label: 'Email',
                    placeholder: 'you@example.com',
                  ),
                  const SizedBox(height: 20),
                  _RegisterTextField(
                    controller: _employeeIdController,
                    label: 'Employee ID (Optional)',
                    placeholder: 'EMP12345',
                  ),
                  const SizedBox(height: 20),
                  _RegisterTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    placeholder: '9876543210',
                  ),
                  const SizedBox(height: 20),
                  _RegisterTextField(
                    controller: _passwordController,
                    label: 'Password',
                    placeholder: '••••••••',
                    isPassword: true,
                    helperText:
                        'Must be 8+ characters with uppercase, number, and special character',
                  ),
                  const SizedBox(height: 20),
                  _RegisterTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    placeholder: '••••••••',
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                ref
                                    .read(snackbarServiceProvider.notifier)
                                    .showError('Passwords do not match');
                                return;
                              }

                              final employeeId = _employeeIdController.text
                                  .trim();
                              ref
                                  .read(authControllerProvider.notifier)
                                  .register(
                                    username: _usernameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    userType: employeeId.isNotEmpty
                                        ? 'employee'
                                        : 'general',
                                    employeeId: employeeId.isNotEmpty
                                        ? employeeId
                                        : null,
                                    mobile: _mobileController.text.trim(),
                                  );
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
                              'Create Account',
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
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/login'),
                        child: Text(
                          'Sign in',
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
        ),
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final bool isPassword;
  final String? helperText;

  const _RegisterTextField({
    required this.controller,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: AppColors.fieldBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.brandBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText!,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGrey),
          ),
        ],
      ],
    );
  }
}
