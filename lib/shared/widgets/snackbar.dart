import 'package:flutter/material.dart';
import 'package:frontend/core/services/snackbar_service.dart' as core_snackbar;

void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

final snackbarServiceProvider = core_snackbar.snackbarServiceProvider;
