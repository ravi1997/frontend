import 'package:web/web.dart' as web;

String? readCookieValue(String cookieName) {
  final cookies = web.document.cookie;
  if (cookies.isEmpty) return null;

  for (final part in cookies.split(';')) {
    final trimmed = part.trim();
    if (trimmed.isEmpty) continue;

    final separatorIndex = trimmed.indexOf('=');
    if (separatorIndex <= 0) continue;

    final name = trimmed.substring(0, separatorIndex).trim();
    if (name != cookieName) continue;

    return Uri.decodeComponent(trimmed.substring(separatorIndex + 1));
  }

  return null;
}
