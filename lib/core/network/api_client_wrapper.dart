// Core Network - Consolidated exports and functionality
export 'api_client.dart';

import 'package:web/web.dart' as web;

// Web cookie store functionality
String? readCookieValue(String cookieName) => 
    dart.library.html ? _readCookieValueWeb(cookieName) : null;

String? _readCookieValueWeb(String cookieName) {
  final candidateNames = switch (cookieName) {
    'X-CSRF-TOKEN-ACCESS' => const ['csrf_access_token', 'csrf_token'],
    'X-CSRF-TOKEN-REFRESH' => const ['csrf_refresh_token', 'csrf_token'],
    _ => [cookieName],
  };

  final cookies = web.document.cookie;
  if (cookies.isEmpty) return null;

  for (final part in cookies.split(';')) {
    final trimmed = part.trim();
    if (trimmed.isEmpty) continue;

    final separatorIndex = trimmed.indexOf('=');
    if (separatorIndex <= 0) continue;

    final name = trimmed.substring(0, separatorIndex).trim();
    if (!candidateNames.contains(name)) continue;

    return Uri.decodeComponent(trimmed.substring(separatorIndex + 1));
  }

  return null;
}