import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/auth/auth_service.dart';

void main() {
  runApp(const ProviderScope(child: YugrowApp()));
}

class YugrowApp extends ConsumerStatefulWidget {
  const YugrowApp({super.key});

  @override
  ConsumerState<YugrowApp> createState() => _YugrowAppState();
}

class _YugrowAppState extends ConsumerState<YugrowApp> {
  @override
  void initState() {
    super.initState();
    // Check for existing session on app launch
    Future.microtask(() {
      ref.read(authProvider.notifier).checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep auth state in sync for GoRouter redirect
    ref.listen<AuthState>(authProvider, (_, auth) {
      updateCachedAuthState(auth);
    });
    // Initialize cache on first build
    updateCachedAuthState(ref.read(authProvider));
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
