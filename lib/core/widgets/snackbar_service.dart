import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'snackbar_service.g.dart';

@riverpod
class SnackbarService extends _$SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void build() {}

  void showSuccess(String message) {
    _showSnackBar(message, Colors.green);
  }

  void showError(String message) {
    _showSnackBar(message, Colors.red);
  }

  void showInfo(String message) {
    _showSnackBar(message, Colors.blue);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
