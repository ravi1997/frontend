import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/snackbar_service.dart';
import '../widgets/auth_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Added
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEmailTab = true;
  bool _obscurePassword = true; // Added for password visibility

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref
            .read(snackbarServiceProvider.notifier)
            .showError(next.error.toString());
      }
      // If login is successful, reset form and navigate
      if (next is AsyncData && next.value != null && previous is AsyncLoading) {
        if (context.mounted) {
          _formKey.currentState?.reset(); // Reset form fields
          // Optionally navigate to dashboard if not handled by router redirect
          // context.go('/');
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.05,
                  ), // Changed from .withValues
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Form(
                // Added Form widget
                key: _formKey, // Assign key
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account to continue',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tab Switcher
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              label: 'Email',
                              icon: Icons.email_outlined,
                              isSelected: _isEmailTab,
                              onTap: () => setState(() {
                                _isEmailTab = true;
                              }),
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              label: 'Mobile',
                              icon: Icons.phone_android_outlined,
                              isSelected: !_isEmailTab,
                              onTap: () => setState(() => _isEmailTab = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_isEmailTab) ...[
                      AuthTextFormField(
                        // Changed from _LoginTextField
                        controller: _emailController,
                        label: 'Email',
                        placeholder: 'you@example.com',
                        keyboardType: TextInputType.emailAddress, // Added
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/forgot-password'),
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.brandBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AuthTextFormField(
                        // Changed from TextField
                        controller: _passwordController,
                        placeholder: '••••••••',
                        obscureText: _obscurePassword, // Use state variable
                        label: 'Password', // Added label for consistency
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          // Add more password validation rules if needed
                          return null;
                        },
                        suffixIcon: IconButton(
                          // Added password visibility toggle
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ] else ...[
                      AuthTextFormField(
                        // Changed from _LoginTextField
                        controller: _phoneController,
                        label: 'Mobile Number',
                        placeholder: '9876543210',
                        keyboardType: TextInputType.phone, // Added
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter your 10-digit mobile number to receive OTP',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // Added validation check
                                  final notifier = ref.read(
                                    authControllerProvider.notifier,
                                  );
                                  if (_isEmailTab) {
                                    notifier.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  } else {
                                    final mobile = _phoneController.text;
                                    // No need for mobile.length == 10 check here as validator handles it
                                    notifier.generateOtp(mobile).then((_) {
                                      if (context.mounted) {
                                        context.push(
                                          '/verify-otp?mobile=$mobile',
                                        );
                                      }
                                    });
                                  }
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
                                _isEmailTab ? 'Sign In' : 'Send OTP',
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
                          "Don't have an account? ",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: Text(
                            'Sign up',
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
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
