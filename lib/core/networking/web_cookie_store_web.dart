// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

String? readCookieValue(String cookieName) {
  final cookies = html.document.cookie;
  if (cookies == null || cookies.isEmpty) return null;

  final candidateNames = switch (cookieName) {
    'X-CSRF-TOKEN-ACCESS' => const ['csrf_access_token', 'csrf_token'],
    'X-CSRF-TOKEN-REFRESH' => const ['csrf_refresh_token', 'csrf_token'],
    _ => [cookieName],
  };

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
