import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_service.g.dart';

class AuthTokens {
  final String? accessToken;
  final String? refreshToken;
  final String? organizationId;

  AuthTokens({this.accessToken, this.refreshToken, this.organizationId});
}

@Riverpod(keepAlive: true)
class TokenService extends _$TokenService {
  static const String _boxName = 'auth_box';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _organizationIdKey = 'organization_id';

  @override
  FutureOr<AuthTokens> build() async {
    final box = await Hive.openBox(_boxName);
    final accessToken = box.get(_accessTokenKey) as String?;
    final refreshToken = box.get(_refreshTokenKey) as String?;
    final organizationId = box.get(_organizationIdKey) as String?;

    if (accessToken != null && isTokenExpired(accessToken)) {
      await box.delete(_accessTokenKey);
      await box.delete(_refreshTokenKey);
      return AuthTokens();
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
      await clearTokens();
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

    final box = await Hive.openBox(_boxName);
    await box.put(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await box.put(_refreshTokenKey, refreshToken);
    }
    if (organizationId != null) {
      await box.put(_organizationIdKey, organizationId);
    }
    state = AsyncData(
      AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? state.value?.refreshToken,
        organizationId: organizationId ?? state.value?.organizationId,
      ),
    );
  }

  Future<void> setOrganizationId(String organizationId) async {
    if (state.value?.organizationId == organizationId) {
      return;
    }

    final box = await Hive.openBox(_boxName);
    await box.put(_organizationIdKey, organizationId);
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
    final current = state.value;
    if (current == null ||
        (current.accessToken == null &&
            current.refreshToken == null &&
            current.organizationId == null)) {
      return;
    }

    final box = await Hive.openBox(_boxName);
    await box.delete(_accessTokenKey);
    await box.delete(_refreshTokenKey);
    await box.delete(_organizationIdKey);
    state = AsyncData(AuthTokens());
  }
}
