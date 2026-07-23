// ─── Yugrow — Production Flavor ────────────────────────────────────
// Run: flutter run --flavor prod --dart-define=FLAVOR=production
// Build: flutter build apk --flavor prod --dart-define=FLAVOR=production

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: YugrowApp()));
}

class YugrowApp extends ConsumerWidget {
  const YugrowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Yugrow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
