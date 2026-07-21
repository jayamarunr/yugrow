import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final workspace = attendee['workspaceId'] ?? '';
    final mutual = attendee['mutualConnections'] ?? 0;
    final venueName = attendee['venueName'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => context.go('/profile'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    if (venueName.isNotEmpty) Text(venueName, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
                    if (mutual > 0) ...[
                      const SizedBox(height: 2),
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
