import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import '../shared/ui/design_system.dart';
import '../shared/widgets/snackbar.dart';

class RidpApp extends ConsumerWidget {
  const RidpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackbarService = ref.watch(snackbarServiceProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MahaSangrah Setu',
      debugShowCheckedModeBanner: false,
      theme: AppDesignSystem.enterpriseDarkTheme,
      routerConfig: router,
      scaffoldMessengerKey: snackbarService.messengerKey,
    );
  }
}
