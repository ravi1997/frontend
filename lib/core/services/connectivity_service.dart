import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

enum ConnectivityStatus { online, offline }

@riverpod
class ConnectivityService extends _$ConnectivityService {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  ConnectivityStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);

    // Initial check
    _checkInitialStatus();

    ref.onDispose(() {
      _subscription.cancel();
    });

    return ConnectivityStatus.online; // Default to online until check completes
  }

  Future<void> _checkInitialStatus() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // If any result is not 'none', we are online
    final isOnline = results.any((result) => result != ConnectivityResult.none);
    state = isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }

  bool get isOnline => state == ConnectivityStatus.online;
  bool get isOffline => state == ConnectivityStatus.offline;
}
