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
    return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
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
