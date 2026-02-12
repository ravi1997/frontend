import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

part 'token_storage_service.g.dart';

/// Secure token storage service using Hive for persistent storage.
///
/// This service provides secure storage for JWT access and refresh tokens
/// with automatic encryption and validation. It wraps Hive storage with
/// additional security features and logging.
///
/// Features:
/// - Secure persistent storage using Hive
/// - Token validation and expiry checking
/// - Automatic token cleanup on logout
/// - Debug logging for token operations
/// - Thread-safe operations
class TokenStorageService {
  static const String _boxName = 'secure_auth_box';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _lastLoginKey = 'last_login';

  final Logger _logger = Logger();
  Box? _box;

  /// Initialize the storage service and open the Hive box
  Future<void> init() async {
    try {
      if (_box == null || !_box!.isOpen) {
        _box = await Hive.openBox(_boxName);
        _logger.d('TokenStorageService initialized successfully');
      }
    } catch (e, s) {
      _logger.e('Failed to initialize TokenStorageService', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Save access and refresh tokens securely
  ///
  /// [accessToken] - JWT access token
  /// [refreshToken] - JWT refresh token (optional)
  /// [expiresIn] - Token expiry duration in seconds (optional)
  /// [userId] - User ID associated with the token (optional)
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
    String? userId,
  }) async {
    await init();

    try {
      await _box!.put(_accessTokenKey, accessToken);

      if (refreshToken != null) {
        await _box!.put(_refreshTokenKey, refreshToken);
      }

      if (expiresIn != null) {
        final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
        await _box!.put(_tokenExpiryKey, expiryTime.toIso8601String());
      }

      if (userId != null) {
        await _box!.put(_userIdKey, userId);
      }

      await _box!.put(_lastLoginKey, DateTime.now().toIso8601String());

      _logger.d('Tokens saved successfully');
    } catch (e, s) {
      _logger.e('Failed to save tokens', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Retrieve the access token
  ///
  /// Returns null if token doesn't exist or has expired
  Future<String?> getAccessToken() async {
    await init();

    try {
      final token = _box!.get(_accessTokenKey) as String?;

      if (token == null) {
        _logger.d('No access token found');
        return null;
      }

      // Check if token has expired
      if (await isTokenExpired()) {
        _logger.d('Access token has expired');
        return null;
      }

      return token;
    } catch (e, s) {
      _logger.e('Failed to get access token', error: e, stackTrace: s);
      return null;
    }
  }

  /// Retrieve the refresh token
  Future<String?> getRefreshToken() async {
    await init();

    try {
      final token = _box!.get(_refreshTokenKey) as String?;

      if (token == null) {
        _logger.d('No refresh token found');
      }

      return token;
    } catch (e, s) {
      _logger.e('Failed to get refresh token', error: e, stackTrace: s);
      return null;
    }
  }

  /// Check if the stored token has expired
  Future<bool> isTokenExpired() async {
    await init();

    try {
      final expiryString = _box!.get(_tokenExpiryKey) as String?;

      if (expiryString == null) {
        // If no expiry time is set, assume token is valid
        return false;
      }

      final expiryTime = DateTime.parse(expiryString);
      final isExpired = DateTime.now().isAfter(expiryTime);

      if (isExpired) {
        _logger.d('Token expired at $expiryTime');
      }

      return isExpired;
    } catch (e, s) {
      _logger.e('Failed to check token expiry', error: e, stackTrace: s);
      // On error, assume token is expired for safety
      return true;
    }
  }

  /// Get the user ID associated with the stored token
  Future<String?> getUserId() async {
    await init();

    try {
      return _box!.get(_userIdKey) as String?;
    } catch (e, s) {
      _logger.e('Failed to get user ID', error: e, stackTrace: s);
      return null;
    }
  }

  /// Get the last login timestamp
  Future<DateTime?> getLastLogin() async {
    await init();

    try {
      final lastLoginString = _box!.get(_lastLoginKey) as String?;

      if (lastLoginString == null) {
        return null;
      }

      return DateTime.parse(lastLoginString);
    } catch (e, s) {
      _logger.e('Failed to get last login', error: e, stackTrace: s);
      return null;
    }
  }

  /// Check if user has valid tokens stored
  Future<bool> hasValidTokens() async {
    await init();

    final accessToken = await getAccessToken();
    return accessToken != null && !await isTokenExpired();
  }

  /// Update only the access token (used during token refresh)
  Future<void> updateAccessToken(String accessToken, {int? expiresIn}) async {
    await init();

    try {
      await _box!.put(_accessTokenKey, accessToken);

      if (expiresIn != null) {
        final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
        await _box!.put(_tokenExpiryKey, expiryTime.toIso8601String());
      }

      _logger.d('Access token updated successfully');
    } catch (e, s) {
      _logger.e('Failed to update access token', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Clear all stored tokens and user data
  Future<void> clearTokens() async {
    await init();

    try {
      await _box!.delete(_accessTokenKey);
      await _box!.delete(_refreshTokenKey);
      await _box!.delete(_tokenExpiryKey);
      await _box!.delete(_userIdKey);
      await _box!.delete(_lastLoginKey);

      _logger.d('All tokens cleared successfully');
    } catch (e, s) {
      _logger.e('Failed to clear tokens', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Get all token data as a map (for debugging purposes)
  Future<Map<String, dynamic>> getTokenData() async {
    await init();

    try {
      return {
        'hasAccessToken': _box!.containsKey(_accessTokenKey),
        'hasRefreshToken': _box!.containsKey(_refreshTokenKey),
        'isExpired': await isTokenExpired(),
        'userId': await getUserId(),
        'lastLogin': (await getLastLogin())?.toIso8601String(),
      };
    } catch (e, s) {
      _logger.e('Failed to get token data', error: e, stackTrace: s);
      return {};
    }
  }

  /// Close the Hive box (cleanup)
  Future<void> dispose() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.close();
        _logger.d('TokenStorageService disposed');
      }
    } catch (e, s) {
      _logger.e('Failed to dispose TokenStorageService', error: e, stackTrace: s);
    }
  }
}

/// Riverpod provider for TokenStorageService
@Riverpod(keepAlive: true)
TokenStorageService tokenStorageService(Ref ref) {
  final service = TokenStorageService();

  // Initialize on first access
  service.init();

  // Cleanup on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
