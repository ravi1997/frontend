import 'package:flutter/material.dart';

Widget buildPrimaryFormActionButton({
  required VoidCallback? onPressed,
  required Widget child,
  required Color primaryColor,
  required double borderRadius,
  bool small = false,
}) {
  return Center(
    child: ElevatedButton(
      onPressed: onPressed,
      style: buildPrimaryFormActionButtonStyle(
        primaryColor: primaryColor,
        borderRadius: borderRadius,
        small: small,
      ),
      child: child,
    ),
  );
}

ButtonStyle buildPrimaryFormActionButtonStyle({
  required Color primaryColor,
  required double borderRadius,
  required bool small,
}) {
  return ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(
      horizontal: small ? 32 : 48,
      vertical: small ? 12 : 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}
