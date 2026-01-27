import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_service.g.dart';

@riverpod
class TokenService extends _$TokenService {
  static const String _boxName = 'auth_box';
  static const String _tokenKey = 'access_token';

  @override
  FutureOr<String?> build() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_tokenKey);
  }

  Future<void> setToken(String token) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_tokenKey, token);
    state = AsyncData(token);
  }

  Future<void> clearToken() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_tokenKey);
    state = const AsyncData(null);
  }
}
