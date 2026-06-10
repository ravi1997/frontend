import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSuccess(String message) =>
      _showSnackBar(message, DesignTokens.success);
  void showError(String message) => _showSnackBar(message, DesignTokens.error);
  void showInfo(String message) => _showSnackBar(message, DesignTokens.info);

  void _showSnackBar(String message, Color backgroundColor) {
    final messengerState = messengerKey.currentState;
    if (messengerState == null) return;

    messengerState
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          margin: const EdgeInsets.all(DesignTokens.spaceM),
        ),
      );
  }
}
