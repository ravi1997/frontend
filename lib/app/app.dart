import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/design_system.dart';
import 'theme/theme_controller.dart';
import '../core/services/snackbar_service.dart';

class RidpApp extends ConsumerWidget {
  const RidpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackbarService = ref.watch(snackbarServiceProvider);
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);

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
