import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokens {
  final String? accessToken;
  final String? refreshToken;
  final String? organizationId;

  AuthTokens({this.accessToken, this.refreshToken, this.organizationId});
}

final tokenServiceProvider = AsyncNotifierProvider<TokenService, AuthTokens>(
  TokenService.new,
);

class TokenService extends AsyncNotifier<AuthTokens> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _organizationIdKey = 'organization_id';

  @override
  FutureOr<AuthTokens> build() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final organizationId = await _storage.read(key: _organizationIdKey);

    if (accessToken != null && isTokenExpired(accessToken)) {
      await _storage.delete(key: _accessTokenKey);
      return AuthTokens(
        refreshToken: refreshToken,
        organizationId: organizationId,
      );
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      organizationId: organizationId,
    );
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
      await _storage.delete(key: _accessTokenKey);
      state = AsyncData(
        AuthTokens(
          refreshToken: tokens.refreshToken,
          organizationId: tokens.organizationId,
        ),
      );
    }
  }

  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    String? organizationId,
  }) async {
    final current = state.value;
    if (current?.accessToken == accessToken &&
        (refreshToken == null || current?.refreshToken == refreshToken) &&
        (organizationId == null || current?.organizationId == organizationId)) {
      return;
    }

    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
    if (organizationId != null) {
      await _storage.write(key: _organizationIdKey, value: organizationId);
    } else {
      await _storage.delete(key: _organizationIdKey);
    }
    state = AsyncData(
      AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? state.value?.refreshToken,
        organizationId: organizationId,
      ),
    );
  }

  Future<void> setOrganizationId(String organizationId) async {
    if (state.value?.organizationId == organizationId) {
      return;
    }

    await _storage.write(key: _organizationIdKey, value: organizationId);
    state = AsyncData(
      AuthTokens(
        accessToken: state.value?.accessToken,
        refreshToken: state.value?.refreshToken,
        organizationId: organizationId,
      ),
    );
  }

  String? get organizationId => state.value?.organizationId;

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _organizationIdKey);
    state = AsyncData(AuthTokens());
  }
}
