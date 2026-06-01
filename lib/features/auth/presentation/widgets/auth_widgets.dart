import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'auth_background.dart';
export 'auth_background.dart';

/// Reusable form card scaffolding for all authentication views.
class AuthCardScaffold extends StatelessWidget {
  final Widget child;
  final IconData headerIcon;
  final String title;
  final String subtitle;

  const AuthCardScaffold({
    super.key,
    required this.child,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Center(
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
                  // Brand Header Icon Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.brandBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      headerIcon,
                      size: 32,
                      color: AppColors.brandBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standardized text input field for all auth forms.
class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final String? helperText;

  const AuthTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.placeholder,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
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
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: AppColors.fieldBackground,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.textGrey.withValues(alpha: 0.7),
                    size: 18,
                  )
                : null,
            suffixIcon: suffixIcon,
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
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ],
    );
  }
}
