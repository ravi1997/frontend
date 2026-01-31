import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../controllers/auth_controller.dart';

part 'otp_controller.g.dart';

@riverpod
class OtpController extends _$OtpController {
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

    await ref.read(authControllerProvider.notifier).generateOtp(mobile);
    startTimer();
  }

  bool get canResend => state == 0;
}
