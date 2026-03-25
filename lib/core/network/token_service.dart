import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_service.g.dart';

class AuthTokens {
  final String? accessToken;
  final String? refreshToken;

  AuthTokens({this.accessToken, this.refreshToken});
}

@Riverpod(keepAlive: true)
class TokenService extends _$TokenService {
  static const String _boxName = 'auth_box';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  FutureOr<AuthTokens> build() async {
    final box = await Hive.openBox(_boxName);
    final accessToken = box.get(_accessTokenKey) as String?;
    final refreshToken = box.get(_refreshTokenKey) as String?;

    if (accessToken != null && isTokenExpired(accessToken)) {
      await box.delete(_accessTokenKey);
      await box.delete(_refreshTokenKey);
      return AuthTokens();
    }

    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      if (payload['exp'] == null) return false;

      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  Future<void> checkAndClearIfExpired() async {
    final tokens = state.value;
    if (tokens?.accessToken != null && isTokenExpired(tokens!.accessToken!)) {
      await clearTokens();
    }
  }

  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await box.put(_refreshTokenKey, refreshToken);
    }
    state = AsyncData(
      AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? state.value?.refreshToken,
      ),
    );
  }

  Future<void> clearTokens() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
    state = AsyncData(AuthTokens());
  }
}
