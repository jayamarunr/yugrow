import 'package:go_router/go_router.dart';
import '../../features/arrival/screens/arrival_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/debug/founder_console_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/network/network_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/messaging/message_screen.dart';
import '../../features/events/public_event_screen.dart';
import '../auth/auth_service.dart';
import '../widgets/main_shell.dart';

/// Cached auth state for GoRouter redirect (cannot use context.read in redirect).
AuthState _cachedAuthState = const AuthState();

/// Update the cached auth state (called by main.dart on auth changes).
void updateCachedAuthState(AuthState state) {
  _cachedAuthState = state;
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final auth = _cachedAuthState;
    final isAuth = auth.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isOnboarding = state.matchedLocation == '/onboarding';
    final isPublicRoute = state.matchedLocation.startsWith('/e/') ||
        state.matchedLocation == '/debug';

    if (isPublicRoute) return null;
    if (!isAuth && !isAuthRoute && !isOnboarding) return '/auth/login';
    if (isAuth && auth.isNewUser && !isOnboarding && !isAuthRoute) {
      return '/onboarding';
    }
    if (isAuth && (isAuthRoute || isOnboarding) && !auth.isNewUser) {
      return '/';
    }
    return null;
  },
  routes: [
    // Auth routes (public)
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/auth/signup', builder: (_, __) => const SignupScreen()),
    // Legacy auth route — redirects to login via the guard
    GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
    // Onboarding (after signup, before home)
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    // Public routes
    GoRoute(path: '/debug', builder: (_, __) => const FounderConsole()),
    GoRoute(path: '/e/:eventId', builder: (_, state) => PublicEventScreen(eventId: state.pathParameters['eventId']!)),
    // Authenticated shell
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
