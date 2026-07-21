import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckinCompleteScreen extends StatelessWidget {
  const CheckinCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 48, color: Colors.green),
              ),
              const SizedBox(height: 24),
              Text("You're visible!", style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Others can now discover and connect with you at this event.', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.people),
                label: const Text('See who\'s here'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
