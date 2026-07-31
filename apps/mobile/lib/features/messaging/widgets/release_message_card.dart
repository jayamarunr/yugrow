// â”€â”€â”€ ReleaseMessageCard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Renders a release note message in the conversation.
//
// Expected message content (JSON):
// {
//   "version": "0.9.8",
//   "title": "What's New",
//   "changes": ["Venue search improved", "Profile cards", "Faster check-in"],
//   "actionLabel": "Read More",
//   "actionUrl": null
// }

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'dart:convert';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class ReleaseMessageCard extends StatelessWidget {
  final Map<String, dynamic> message;
  final String? time;

  const ReleaseMessageCard({
    super.key,
    required this.message,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawContent = message['content'] as String? ?? '{}';
    Map<String, dynamic> data;
    try {
      data = jsonDecode(rawContent) as Map<String, dynamic>;
    } catch (_) {
      data = {};
    }

    final title = data['title'] as String? ?? "What's New";
    final version = data['version'] as String?;
    final changes = (data['changes'] as List<dynamic>?)?.cast<String>() ?? [];
    final actionLabel = data['actionLabel'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.lgCircular,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.smCircular,
                    ),
                    child: const Icon(Icons.newspaper, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (version != null)
                          Text(
                            'Version $version',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Changes list
            if (changes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: changes.map((change) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: AppRadius.xsCircular,
                            ),
                            child: const Icon(Icons.check, size: 12, color: AppColors.success),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              change,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Action button
            if (actionLabel != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.smCircular),
                  ),
                  child: Text(actionLabel, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                ),
              ),

            // Timestamp
            if (time != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.none, AppSpacing.lg, AppSpacing.md),
                child: Text(time ?? '', style: TextStyle(fontSize: 10, color: AppColors.textDisabled)),
              ),
          ],
        ),
      ),
    );

  }
}
