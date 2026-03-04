import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/core/app_theme.dart';
import 'shared/core/router.dart';
import 'shared/core/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: BioClockApp(),
    ),
  );
}

class BioClockApp extends ConsumerWidget {
  const BioClockApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.watch(themeProvider); // watch for rebuilds on theme change
    final notifier = ref.read(themeProvider.notifier);

    return MaterialApp.router(
      title: 'Bio-Clock Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: notifier.themeMode,
      routerConfig: router,
    );
  }
}
