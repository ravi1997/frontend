import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/localization/locale_controller.dart';
import 'package:frontend/app/theme/tokens.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeControllerProvider);

    return PopupMenuButton<String>(
      tooltip: 'Change Language',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: 20, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72)),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: DesignTokens.fontS,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
      onSelected: (code) =>
          ref.read(localeControllerProvider.notifier).setLocale(code),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'en', child: Text('English (EN)')),
        PopupMenuItem(value: 'es', child: Text('Spanish (ES)')),
        PopupMenuItem(value: 'fr', child: Text('French (FR)')),
        PopupMenuItem(value: 'hi', child: Text('Hindi (HI)')),
      ],
    );
  }
}
