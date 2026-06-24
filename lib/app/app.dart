import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/networking/token_service.dart';
import 'router.dart';
import 'theme/design_system.dart';
import 'theme/theme_controller.dart';
import '../core/services/snackbar_service.dart';

class RidpApp extends ConsumerWidget {
  const RidpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenState = ref.watch(tokenServiceProvider);
    final snackbarService = ref.watch(snackbarServiceProvider);
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);

    if (tokenState.isLoading) {
      return MaterialApp(
        title: 'MahaSangrah Setu',
        debugShowCheckedModeBanner: false,
        theme: AppDesignSystem.enterpriseLightTheme,
        darkTheme: AppDesignSystem.enterpriseDarkTheme,
        themeMode: themeMode,
        home: Scaffold(
          body: Center(
            child: Semantics(
              label: 'Loading application',
              liveRegion: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading application...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'MahaSangrah Setu',
      debugShowCheckedModeBanner: false,
      theme: AppDesignSystem.enterpriseLightTheme,
      darkTheme: AppDesignSystem.enterpriseDarkTheme,
      themeMode: themeMode,
      routerConfig: router,
      scaffoldMessengerKey: snackbarService.messengerKey,
    );
  }
}
