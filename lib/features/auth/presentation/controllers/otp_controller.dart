import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

final otpControllerProvider = NotifierProvider<OtpController, int>(
  OtpController.new,
);

class OtpController extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void startTimer() {
    _timer?.cancel();
    state = 30; // 30 seconds resend cooldown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp(String mobile) async {
    if (state > 0) return;

    await ref.read(authControllerProvider.notifier).requestOtp(mobile);
    startTimer();
  }

  bool get canResend => state == 0;
}
