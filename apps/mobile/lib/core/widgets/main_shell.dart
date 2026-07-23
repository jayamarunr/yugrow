import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api/api_client.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _api = ApiClient();
  bool _hasActivePresence = false;

  @override
  void initState() {
    super.initState();
    _checkPresence();
  }

  Future<void> _checkPresence() async {
    final presence = await _api.getActivePresence('person-self');
    if (mounted) {
      setState(() => _hasActivePresence = presence != null && presence.isNotEmpty);
    }
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/live')) return 1;
    if (location.startsWith('/network')) return 2;
    if (location.startsWith('/me')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/');
            case 1: context.go('/live');
            case 2: context.go('/network');
            case 3: context.go('/me');
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.event_outlined), activeIcon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: _hasActivePresence
                ? const _GreenDot(child: Icon(Icons.explore_outlined))
                : const Icon(Icons.explore_outlined),
            activeIcon: _hasActivePresence
                ? const _GreenDot(child: Icon(Icons.explore))
                : const Icon(Icons.explore),
            label: 'Live',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Network'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

/// Small green dot overlay to indicate active presence.
class _GreenDot extends StatelessWidget {
  final Widget child;
  const _GreenDot({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -2,
          right: -4,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
