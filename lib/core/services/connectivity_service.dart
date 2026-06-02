import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus {
  connected,
  disconnected,
  checking,
  online,
}

class ConnectivityService {
  ConnectivityStatus _status = ConnectivityStatus.checking;
  
  ConnectivityStatus get status => _status;
  
  Stream<ConnectivityStatus> get statusStream async* {
    yield* Stream.periodic(const Duration(seconds: 5), (_) {
      // In a real app, this would check actual connectivity
      _status = ConnectivityStatus.connected;
      return _status;
    });
  }
  
  Future<bool> get isConnected async {
    // In a real app, this would check actual connectivity
    return true;
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});