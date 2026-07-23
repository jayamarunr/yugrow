import 'package:go_router/go_router.dart';
import '../../features/arrival/screens/arrival_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/debug/founder_console_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/network/network_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/messaging/message_screen.dart';
import '../widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    GoRoute(path: '/debug', builder: (_, __) => const FounderConsole()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/live', builder: (_, __) => const ArrivalScreen()),
        GoRoute(path: '/network', builder: (_, __) => const NetworkScreen()),
        GoRoute(path: '/me', builder: (_, __) => const ProfileScreen()),
        GoRoute(path: '/conversations/:id', builder: (_, state) => MessageScreen(conversationId: state.pathParameters['id']!)),
      ],
    ),
  ],
);
