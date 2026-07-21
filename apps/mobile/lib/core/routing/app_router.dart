import 'package:go_router/go_router.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/checkin/home_screen.dart';
import '../../features/checkin/live_screen.dart';
import '../../features/checkin/checkin_complete_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/connections/connections_screen.dart';
import '../../features/messaging/conversations_screen.dart';
import '../../features/messaging/message_screen.dart';
import '../widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/live/:eventId', builder: (_, state) => LiveScreen(eventId: state.pathParameters['eventId']!)),
        GoRoute(path: '/checkin-complete', builder: (_, __) => const CheckinCompleteScreen()),
        GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
        GoRoute(path: '/connections', builder: (_, __) => const ConnectionsScreen()),
        GoRoute(path: '/conversations', builder: (_, __) => const ConversationsScreen()),
        GoRoute(path: '/conversations/:id', builder: (_, state) => MessageScreen(conversationId: state.pathParameters['id']!)),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
