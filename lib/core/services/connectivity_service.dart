import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { online, offline }

final connectivityServiceProvider =
    NotifierProvider<ConnectivityService, ConnectivityStatus>(
      ConnectivityService.new,
    );

class ConnectivityService extends Notifier<ConnectivityStatus> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  ConnectivityStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);

    // Initial check
    _checkInitialStatus();

    ref.onDispose(() {
      unawaited(_subscription.cancel());
    });

    return ConnectivityStatus.online; // Default to online until check completes
  }

  Future<void> _checkInitialStatus() async {
    final result = await Connectivity().checkConnectivity();
    if (!ref.mounted) return;
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    if (!ref.mounted) return;
    // If any result is not 'none', we are online
    final isOnline = results.any((result) => result != ConnectivityResult.none);
    state = isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }

  bool get isOnline => state == ConnectivityStatus.online;
  bool get isOffline => state == ConnectivityStatus.offline;
}
