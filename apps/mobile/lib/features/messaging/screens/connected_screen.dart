// â”€â”€â”€ You're Connected! Screen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Shown after a connection is accepted.
// Displays the other person's profile and encourages the first message.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../profile/widgets/profile_card.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class ConnectedScreen extends StatelessWidget {
  final String name;
  final String? headline;
  final String? company;
  final String conversationId;

  const ConnectedScreen({
    super.key,
    required this.name,
    this.headline,
    this.company,
    required this.conversationId,
  });

  static const _suggestions = [
    'Hi! Great meeting you ðŸ‘‹',
    'What brought you to this event?',
    'Would love to stay connected.',
    "Let's grab a coffee after this.",
    'Tell me more about your work.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: Colors.green, size: 48),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text("You're Connected!",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xl),

              // Person's profile card
              ProfileCard(
                name: name,
                headline: headline,
                company: company,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Prompt
              Text(
                'Start the conversation while you\'re both still here.',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // First message suggestions
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'action': 'chat',
                      'conversationId': conversationId,
                    });
                  },
                  icon: const Icon(LucideIcons.message_square, size: 18),
                  label: const Text('Send First Message'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdCircular),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Suggestion chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _suggestions.map((s) => ActionChip(
                  label: Text(s, style: AppTypography.caption),
                  onPressed: () {
                    Navigator.of(context).pop({
                      'action': 'chat',
                      'conversationId': conversationId,
                      'suggestion': s,
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.xxlCircular),
                  side: BorderSide(color: Colors.grey[300]!),
                  backgroundColor: Colors.grey[50],
                )).toList(),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );

  }
}
