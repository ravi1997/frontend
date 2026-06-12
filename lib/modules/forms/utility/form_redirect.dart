import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'form_redirect_stub.dart'
    if (dart.library.html) 'form_redirect_web.dart'
    as platform_redirect;

Future<void> handlePostSubmitRedirect(BuildContext context, String url) async {
  final target = url.trim();
  if (target.isEmpty) return;

  final uri = Uri.tryParse(target);
  if (uri == null) return;

  if (target.startsWith('/')) {
    if (context.mounted) {
      context.go(target);
    }
    return;
  }

  if (uri.scheme == 'http' || uri.scheme == 'https') {
    await platform_redirect.openExternalUrl(target);
  }
}
