import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/token_service.dart';
import 'package:frontend/features/auth/auth_service.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_source.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final remote = ref.watch(authRemoteSourceProvider);
  final tokenStore = ref.watch(tokenServiceProvider.notifier);
  return AuthService(remote, tokenStore);
});
