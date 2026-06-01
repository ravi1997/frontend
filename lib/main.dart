import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/app/app.dart';
import 'package:frontend/shared/ui/design_system.dart';

Future<void> main() async {
  // 1. Capture early Flutter errors
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
  };

  // 2. Capture platform/async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformError: $error\n$stack');
    return true; // Error was handled
  };

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 3. Deliberate initialization
    await Hive.initFlutter();

    // We wrap in ProviderScope here. Riverpod providers will initialize
    // when first watched, but critical ones can be warmed up if needed.
    runApp(const ProviderScope(child: AgentOSApp()));
  } catch (e, stack) {
    debugPrint('Critical startup failure: $e\n$stack');
    runApp(InitializationErrorApp(error: e.toString()));
  }
}

class AgentOSApp extends ConsumerWidget {
  const AgentOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Backwards-compatible wrapper: keep name but delegate to new app widget.
    return const RidpApp();
  }
}

/// Fallback app shown only if Hive or other critical bootstrap logic fails.
class InitializationErrorApp extends StatelessWidget {
  final String error;
  const InitializationErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppDesignSystem.enterpriseDarkTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Failed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The application could not be started due to a technical error.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    error,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () {
                    // On web, this effectively refreshes the page
                    // On mobile, users usually force-close, but this helps intent
                    debugPrint('User requested reload');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Application Load'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
