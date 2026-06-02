import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  SnackbarService(this.scaffoldMessengerKey);

  GlobalKey<ScaffoldMessengerState> get messengerKey => scaffoldMessengerKey;

  void show(String message, {bool isError = false}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
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

  void showError(String message) {
    show(message, isError: true);
  }

  void showSuccess(String message) {
    show(message, isError: false);
  }
}

final snackbarServiceProvider = Provider<SnackbarService>((ref) {
  return SnackbarService(GlobalKey<ScaffoldMessengerState>());
});
