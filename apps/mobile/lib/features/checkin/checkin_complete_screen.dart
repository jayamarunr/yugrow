import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

class CheckinCompleteScreen extends StatelessWidget {
  final String eventName;
  final String venueName;

  const CheckinCompleteScreen({
    super.key,
    this.eventName = '',
    this.venueName = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon with confetti dots
              SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10, top: 8,
                      child: Container(width: 10, height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0F766E))),
                    ),
                    Positioned(
                      right: 15, top: 5,
                      child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF59E0B))),
                    ),
                    Positioned(
                      right: 40, bottom: 8,
                      child: Container(width: 6, height: 6,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF3B82F6))),
                    ),
                    const Icon(Icons.check_circle, color: Color(0xFF0F766E), size: 64),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text("You're visible!",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              if (eventName.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E).withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.map_pin, size: 14, color: const Color(0xFF0F766E)),
                      const SizedBox(width: 6),
                      Text(eventName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500,
                              color: Color(0xFF0F766E))),
                    ],
                  ),
                ),

              Text(
                'Others can now discover and connect with you.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Professionals nearby can see your profile, send connection requests, and start conversations.',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(LucideIcons.eye, size: 18),
                  label: const Text("See Who's Here"),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text('Back to Events',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500])),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
