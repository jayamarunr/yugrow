import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';

class AttendeeCard extends StatelessWidget {
  final Map<String, dynamic> attendee;
  final bool showConnect;
  final VoidCallback? onConnect;

  const AttendeeCard({
    super.key,
    required this.attendee,
    this.showConnect = true,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = attendee['name'] ?? 'Unknown';
    final mutual = attendee['mutualConnections'] ?? 0;
    final venueName = attendee['venueName'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: InkWell(
        onTap: () => context.go('/profile'),
        borderRadius: AppRadius.mdCircular,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    if (venueName.isNotEmpty) Text(venueName, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                    if (mutual > 0) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text('$mutual mutual connection${mutual == 1 ? '' : 's'}', style: TextStyle(fontSize: 12, color: theme.primaryColor)),
                    ],
                  ],
                ),
              ),
              if (showConnect)
                TextButton(
                  onPressed: onConnect,
                  child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
