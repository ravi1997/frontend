import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/widgets/snackbar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: AgentOSApp()));
}

class AgentOSApp extends ConsumerWidget {
  const AgentOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackbarService = ref.watch(snackbarServiceProvider.notifier);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MahaSangrah Setu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      scaffoldMessengerKey: snackbarService.messengerKey,
    );
  }
}
