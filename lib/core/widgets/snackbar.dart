import 'package:flutter/material.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSuccess(String message) => _showSnackBar(message, Colors.green);
  void showError(String message) => _showSnackBar(message, Colors.red);
  void showInfo(String message) => _showSnackBar(message, Colors.blue);

  void _showSnackBar(String message, Color backgroundColor) {
    final messengerState = messengerKey.currentState;
    if (messengerState == null) return;

    messengerState
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }
}
